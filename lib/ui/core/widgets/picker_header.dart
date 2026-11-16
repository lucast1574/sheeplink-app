import 'package:flutter/material.dart';
import 'app_icon.dart';

/// Keeps an explicit exit visible above a selector's scrollable options.
class PickerHeader extends StatelessWidget {
  const PickerHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      const SizedBox(width: 16),
      IconButton(
        tooltip: 'Cerrar selector',
        onPressed: () => Navigator.pop(context),
        icon: const AppIcon(Symbol.close),
      ),
    ],
  );
}
