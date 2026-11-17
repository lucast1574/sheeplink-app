import 'package:flutter/material.dart';
import '../../../core/widgets/app_icon.dart';

/// A shared section with an explicit expand/collapse affordance.
class CellDisclosure extends StatefulWidget {
  const CellDisclosure({
    super.key,
    required this.title,
    required this.children,
    this.controller,
    this.tilePadding,
    this.childrenPadding,
    this.subtitle,
    this.maintainState = false,
    this.onExpansionChanged,
  });
  final ExpansibleController? controller;
  final Widget title;
  final Widget? subtitle;
  final List<Widget> children;
  final EdgeInsetsGeometry? tilePadding, childrenPadding;
  final bool maintainState;
  final ValueChanged<bool>? onExpansionChanged;
  @override
  State<CellDisclosure> createState() => _CellDisclosureState();
}

class _CellDisclosureState extends State<CellDisclosure> {
  bool expanded = false;
  final storageKey = Object();
  @override
  Widget build(BuildContext context) => ExpansionTile(
    key: PageStorageKey(storageKey),
    controller: widget.controller,
    title: widget.title,
    subtitle: widget.subtitle,
    tilePadding: widget.tilePadding,
    childrenPadding: widget.childrenPadding,
    maintainState: widget.maintainState,
    shape: const Border(),
    collapsedShape: const Border(),
    trailing: RotatedBox(
      quarterTurns: expanded ? 3 : 1,
      child: const AppIcon(Symbol.arrow, size: 18),
    ),
    onExpansionChanged: (value) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() => expanded = value);
      widget.onExpansionChanged?.call(value);
    },
    children: widget.children,
  );
}
