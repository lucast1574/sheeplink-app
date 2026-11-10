import 'package:flutter/material.dart';
import '../../../../data/services/api_client.dart';

Future<void> showPlannerActivityPicker(
  BuildContext context, {
  required String title,
  required String description,
  required List<Map<String, dynamic>> options,
  required Set<String> selected,
  required Future<void> Function(Set<String>) onSave,
}) async {
  final draft = {...selected};
  bool saving = false;
  String? error;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, update) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(description),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final option in options)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(option['title']),
                          value: draft.contains(option['key']),
                          onChanged: saving
                              ? null
                              : (value) => update(() {
                                  if (value == true) {
                                    draft.add(option['key']);
                                  } else {
                                    draft.remove(option['key']);
                                  }
                                }),
                        ),
                    ],
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(error!),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: saving
                      ? null
                      : () async {
                          update(() {
                            saving = true;
                            error = null;
                          });
                          try {
                            await onSave(draft);
                            if (context.mounted) Navigator.pop(context);
                          } catch (e) {
                            if (context.mounted) {
                              update(() => error = friendlyError(e));
                            }
                          } finally {
                            if (context.mounted) update(() => saving = false);
                          }
                        },
                  child: Text(saving ? 'Guardando…' : 'Aplicar selección'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
