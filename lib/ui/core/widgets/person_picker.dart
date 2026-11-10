import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_icon.dart';

/// A full-width field with a scrollable, accessible sheet for choosing a person.
class PersonPicker extends StatelessWidget {
  const PersonPicker({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final Map<String, String> options;
  final String? value;
  final ValueChanged<String>? onChanged;

  Future<void> choose(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.pop(context),
                      icon: const AppIcon(Symbol.close),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: options.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final id = index == 0
                        ? ''
                        : options.keys.elementAt(index - 1);
                    final selected = (value ?? '') == id;
                    return Semantics(
                      selected: selected,
                      child: ListTile(
                        minVerticalPadding: 16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        tileColor: selected ? AppTheme.leaf : AppTheme.surface,
                        title: Text(id.isEmpty ? 'Sin asignar' : options[id]!),
                        trailing: selected
                            ? const AppIcon(
                                Symbol.check,
                                color: AppTheme.forest,
                              )
                            : null,
                        onTap: () => Navigator.pop(context, id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected != null) onChanged?.call(selected);
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    button: true,
    enabled: onChanged != null,
    child: Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onChanged == null ? null : () => choose(context),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  options[value] ?? 'Sin asignar',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              RotatedBox(
                quarterTurns: 1,
                child: AppIcon(Symbol.arrow, size: 18, color: AppTheme.muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
