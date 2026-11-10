import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';

class AttendancePersonCard extends StatelessWidget {
  const AttendancePersonCard({
    super.key,
    required this.name,
    required this.present,
    required this.onChanged,
  });
  final String name;
  final bool? present;
  final ValueChanged<bool>? onChanged;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AttendanceMark(
                label: 'Presente',
                selected: present == true,
                symbol: Symbol.check,
                onTap: onChanged == null ? null : () => onChanged!(true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _AttendanceMark(
                label: 'Ausente',
                selected: present == false,
                symbol: Symbol.close,
                onTap: onChanged == null ? null : () => onChanged!(false),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _AttendanceMark extends StatelessWidget {
  const _AttendanceMark({
    required this.label,
    required this.selected,
    required this.symbol,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Symbol symbol;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: selected ? AppTheme.forest : AppTheme.control,
        foregroundColor: selected ? Colors.white : AppTheme.ink,
        textStyle: TextStyle(
          fontFamily: 'Figtree',
          fontSize: 14,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      icon: AppIcon(
        symbol,
        size: 18,
        color: selected ? Colors.white : AppTheme.ink,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppTheme.ink,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ),
  );
}
