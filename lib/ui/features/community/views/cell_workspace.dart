import 'package:flutter/material.dart';
import '../view_models/community_view_model.dart';
import 'attendance_view.dart';
import 'cell_planner.dart';
import 'cell_members_view.dart';
import 'cell_task_tabs.dart';
import 'cell_workspace_header.dart';

class CellWorkspace extends StatefulWidget {
  const CellWorkspace({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<CellWorkspace> createState() => _CellWorkspaceState();
}

class _CellWorkspaceState extends State<CellWorkspace> {
  int tab = 0;
  bool plannerOpened = false;
  void openPlanner() {
    if (!mounted) return;
    setState(() {
      tab = 1;
      plannerOpened = true;
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final model = widget.model;
      final panes = [
        AttendanceView(
          model: model,
          showSelector: false,
          onPrepare: openPlanner,
        ),
        if (plannerOpened)
          CellPlanner(
            key: ValueKey(
              '${model.cell?.id}/${model.day}/${model.meetingRevision}',
            ),
            model: model,
            onPrepare: openPlanner,
          )
        else
          const SizedBox.shrink(),
        CellMembersView(key: ValueKey(model.cell?.id), model: model),
      ];
      final body = constraints.hasBoundedHeight
          ? IndexedStack(index: tab, children: panes)
          : Column(
              children: [
                for (var i = 0; i < panes.length; i++)
                  Visibility(
                    visible: tab == i,
                    maintainState: true,
                    child: panes[i],
                  ),
              ],
            );
      return Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.hasBoundedHeight ? 20 : 0,
                ),
                child: CellWorkspaceHeader(
                  model: model,
                  compact:
                      constraints.hasBoundedHeight &&
                      constraints.maxHeight < 340,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.hasBoundedHeight ? 12 : 0,
                ),
                child: CellTaskTabs(
                  selected: tab,
                  onChanged: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      tab = value;
                      if (tab == 1) plannerOpened = true;
                    });
                  },
                ),
              ),
              if (constraints.hasBoundedHeight)
                Expanded(child: body)
              else ...[
                const SizedBox(height: 24),
                body,
              ],
            ],
          ),
        ),
      );
    },
  );
}
