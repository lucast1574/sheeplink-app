import 'package:flutter/material.dart';
import '../../../../l10n/locale.dart';
import '../../../core/widgets/app_icon.dart';
import '../view_models/community_view_model.dart';
import 'cell_meeting_selector.dart';

class CellWorkspaceHeader extends StatelessWidget {
  const CellWorkspaceHeader({
    super.key,
    required this.model,
    this.compact = false,
  });
  final CommunityViewModel model;
  final bool compact;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!compact)
        Text(tr('Mi célula'), style: Theme.of(context).textTheme.headlineLarge),
      if (model.cells.length > 1)
        TextButton.icon(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: model.busy || model.plannerBusy || model.pickingPhoto
              ? null
              : () => CellMeetingSelector(model: model).changeCell(context),
          icon: const AppIcon(Symbol.people, size: 18),
          label: Text(model.cell?.name ?? tr('Cambiar célula')),
        )
      else ...[
        const SizedBox(height: 6),
        Text(
          model.cell?.name ?? tr('Sin célula asignada'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
      ],
    ],
  );
}
