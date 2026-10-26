import 'dart:math';
import 'package:flutter/material.dart';
import '../../../data/repositories/community_repository.dart';
import '../../../data/services/api_client.dart';

class ReportContent extends StatefulWidget {
  const ReportContent({
    super.key,
    required this.repository,
    required this.reference,
  });
  final CommunityRepository repository;
  final String reference;
  @override
  State<ReportContent> createState() => _ReportContentState();
}

class _ReportContentState extends State<ReportContent> {
  final text = TextEditingController();
  final requestId =
      'mobile-${DateTime.now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}';
  bool sending = false;
  String? error;
  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  Future<void> send() async {
    if (text.text.trim().length < 10) {
      setState(
        () => error = 'Describe lo ocurrido con al menos 10 caracteres.',
      );
      return;
    }
    setState(() {
      sending = true;
      error = null;
    });
    try {
      await widget.repository.reportContent(
        widget.reference,
        text.text.trim(),
        requestId,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !sending,
    child: AlertDialog(
      title: const Text('Reportar contenido o usuario'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Indica qué contenido o usuario debemos revisar. El reporte lo recibe el equipo de soporte de SheepLink.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: text,
              enabled: !sending,
              maxLines: 5,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: '¿Qué ocurrió?',
                hintText:
                    'Incluye la célula, semana o nombre del usuario. No envíes contraseñas.',
              ),
            ),
            if (error != null)
              Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: sending ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: sending ? null : send,
          child: Text(sending ? 'Enviando…' : 'Enviar reporte'),
        ),
      ],
    ),
  );
}

Future<void> openContentReport(
  BuildContext context,
  CommunityRepository repository,
  String reference,
) async {
  final sent = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        ReportContent(repository: repository, reference: reference),
  );
  if (sent == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reporte enviado. El equipo de SheepLink lo revisará.'),
      ),
    );
  }
}
