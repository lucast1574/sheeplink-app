import 'package:flutter/material.dart';
import '../../../../data/repositories/community_repository.dart';
import '../view_models/community_view_model.dart';

class MeetingTopic extends StatefulWidget {
  const MeetingTopic({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<MeetingTopic> createState() => _MeetingTopicState();
}

class _MeetingTopicState extends State<MeetingTopic> {
  final text = TextEditingController();
  bool busy = false;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final repository = widget.model.repository;
    if (repository is! ApiCommunityRepository || widget.model.cell == null) {
      return;
    }
    try {
      final data = await repository.client.dio.get<Map<String, dynamic>>(
        '/cells/${widget.model.cell!.id}/meetings/${widget.model.week}',
      );
      if (mounted) text.text = data.data?['title'] as String? ?? '';
    } catch (_) {
      if (mounted) setState(() => error = 'No pudimos cargar el tema.');
    }
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: text,
          readOnly: !widget.model.canWrite,
          maxLength: 120,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: const InputDecoration(
            labelText: 'Tema o título de la reunión',
          ),
        ),
        if (error != null) Text(error!),
        if (widget.model.canWrite)
          TextButton(
            onPressed: busy
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    setState(() => busy = true);
                    try {
                      final repository =
                          widget.model.repository as ApiCommunityRepository;
                      await repository.client.dio.put<void>(
                        '/cells/${widget.model.cell!.id}/meetings/${widget.model.week}',
                        data: {
                          'date': widget.model.day,
                          'title': text.text.trim(),
                        },
                      );
                      if (mounted) setState(() => error = 'Tema guardado.');
                    } catch (_) {
                      if (mounted) {
                        setState(
                          () =>
                              error = 'No se pudo guardar el tema. Reintenta.',
                        );
                      }
                    } finally {
                      if (mounted) setState(() => busy = false);
                    }
                  },
            child: Text(busy ? 'Guardando…' : 'Guardar tema'),
          ),
      ],
    ),
  );
}
