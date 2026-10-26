import 'package:flutter/material.dart';

class FeedbackPanel extends StatelessWidget {
  const FeedbackPanel(this.text, {super.key, this.error = false, this.action});
  final String text;
  final bool error;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: error ? const Color(0xFFF9E9E4) : const Color(0xFFE7EEDB),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(liveRegion: true, child: Text(text)),
        ?action,
      ],
    ),
  );
}

Future<bool> confirmDiscard(BuildContext context) => showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Tienes asistencia sin guardar'),
    content: const Text('Si continúas perderás las marcas de esta reunión.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Seguir marcando'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Descartar cambios'),
      ),
    ],
  ),
).then((value) => value ?? false);
