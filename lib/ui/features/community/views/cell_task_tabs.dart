import 'package:flutter/material.dart';
import '../../../../l10n/locale.dart';
import '../../../core/theme/app_theme.dart';

class CellTaskTabs extends StatelessWidget {
  const CellTaskTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final buttons = [
      for (final (index, label) in [
        'Asistencia',
        'Planificador',
        'Integrantes',
      ].indexed)
        Semantics(
          selected: selected == index,
          child: TextButton(
            onPressed: () => onChanged(index),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              shape: const RoundedRectangleBorder(),
              foregroundColor: selected == index
                  ? AppTheme.forest
                  : AppTheme.muted,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr(label),
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected == index
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 3,
                  color: selected == index
                      ? AppTheme.forest
                      : Colors.transparent,
                ),
              ],
            ),
          ),
        ),
    ];
    if (scale > 1.2) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final button in buttons)
              SizedBox(width: scale * 106, child: button),
          ],
        ),
      );
    }
    return Row(
      children: [for (final button in buttons) Expanded(child: button)],
    );
  }
}
