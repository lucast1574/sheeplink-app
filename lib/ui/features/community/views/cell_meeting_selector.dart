import '../../../../l10n/locale.dart';
import '../../../core/widgets/picker_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/community.dart';
import '../../../../domain/models/weekly_meeting.dart';
import 'meeting_date_sheet.dart';
import '../view_models/community_view_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/feedback_panel.dart';

/// Date and cell selection shared by attendance and the planner.
class CellMeetingSelector extends StatelessWidget {
  const CellMeetingSelector({super.key, required this.model, this.onPrepare});
  final CommunityViewModel model;
  final VoidCallback? onPrepare;
  bool get locked => model.busy || model.pickingPhoto || model.plannerBusy;
  Future<void> changeDate(BuildContext context) async {
    if (locked) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => MeetingDateSheet(
        date: model.date,
        meetingDay: model.cell?.meetingDay ?? 'Saturday',
        canPrepare:
            model.session?.permissions.contains('planner.write') ?? false,
        recorded: model.meeting?.date != null,
      ),
    );
    if (!context.mounted || selected == null) return;
    if (selected == MeetingDateAction.prepare) {
      await prepareNext(context);
      return;
    }
    if (selected is! DateTime || selected == model.date) return;
    if (model.dirty && !await confirmDiscard(context)) return;
    await model.refresh(selectedDate: selected);
  }

  Future<void> changeCell(BuildContext context) async {
    if (locked) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (!context.mounted) return;
    final selected = await showModalBottomSheet<Cell>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 16, 16),
                child: PickerHeader(title: tr("Elige tu célula")),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    for (final cell in model.cells)
                      ListTile(
                        title: Text(cell.name),
                        selected: cell.id == model.cell?.id,
                        selectedTileColor: AppTheme.leaf,
                        trailing: cell.id == model.cell?.id
                            ? const AppIcon(Symbol.check)
                            : null,
                        onTap: () => Navigator.pop(context, cell),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected == null || selected.id == model.cell?.id || !context.mounted) {
      return;
    }
    if (model.dirty && !await confirmDiscard(context)) return;
    await model.refresh(selected: selected);
  }

  Future<void> changeWeek(BuildContext context, int offset) async {
    if (locked) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (model.dirty && !await confirmDiscard(context)) return;
    final week = startOfWeek(model.date).add(Duration(days: offset * 7));
    await model.refresh(
      selectedDate: meetingDateForWeek(
        week,
        model.cell?.meetingDay ?? 'Saturday',
        DateTime.now(),
        allowFuture: true,
      ),
    );
  }

  Future<void> prepareNext(BuildContext context) async {
    if (locked) return;
    if (model.dirty && !await confirmDiscard(context)) return;
    if (locked) return;
    FocusManager.instance.primaryFocus?.unfocus();
    var next = nextMeetingDate(
      model.date,
      model.cell!.meetingDay,
      DateTime.now(),
    );
    if (model.meeting?.date != null &&
        startOfWeek(next) == startOfWeek(model.date)) {
      next = next.add(const Duration(days: 7));
    }
    await model.refresh(selectedDate: next);
    if (model.error == null) onPrepare?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (model.cell == null) return const SizedBox.shrink();
    return Semantics(
      label: tr('Elegir fecha'),
      child: OutlinedButton(
        key: const ValueKey('meeting-date-selector'),
        onPressed: locked ? null : () => openMeetingDates(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: AppTheme.control),
        ),
        child: Row(
          children: [
            const AppIcon(Symbol.calendar, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.MMMMEEEEd(appLocale).format(model.date),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr(
                      model.isFutureMeeting
                          ? 'Próximo encuentro'
                          : 'Fecha del encuentro',
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const RotatedBox(
              quarterTurns: 1,
              child: AppIcon(Symbol.arrow, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openMeetingDates(BuildContext context) => changeDate(context);
}
