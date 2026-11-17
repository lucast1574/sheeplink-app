import 'package:flutter/material.dart';
import 'cell_disclosure.dart';

class PlannerActivityTile extends StatelessWidget {
  const PlannerActivityTile({
    super.key,
    required this.title,
    required this.responsible,
    required this.children,
  });
  final String title, responsible;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: CellDisclosure(
      maintainState: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(responsible),
      onExpansionChanged: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      children: children,
    ),
  );
}
