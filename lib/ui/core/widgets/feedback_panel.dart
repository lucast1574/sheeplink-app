import '../../../l10n/locale.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
      color: error ? const Color(0xFFF9E9E4) : AppTheme.surface,
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

Future<bool> confirmDiscard(BuildContext context, {String? message}) =>
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr("Tienes cambios sin guardar")),
        content: Text(
          message ?? tr("Si continúas perderás los cambios de esta reunión."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr("Seguir editando")),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr("Descartar cambios")),
          ),
        ],
      ),
    ).then((value) => value ?? false);
