import '../../../../l10n/locale.dart';
import '../../../core/widgets/picker_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/community.dart';
import '../../../../domain/models/weekly_meeting.dart';
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
    if (model.dirty && !await confirmDiscard(context)) return;
    if (!context.mounted) return;
    final date = await showDatePicker(
      context: context,
      initialDate: model.date,
      firstDate: DateTime(model.date.year - 10),
      lastDate: DateTime(model.date.year + 10, 12, 31),
      cancelText: tr("Cancelar"),
      barrierDismissible: true,
    );
    if (date != null) await model.refresh(selectedDate: date);
  }

  Future<void> changeCell(BuildContext context) async {
    if (locked) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (model.dirty && !await confirmDiscard(context)) return;
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
    if (selected != null) await model.refresh(selected: selected);
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(tr("Mi célula"), style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 8),
      Text(model.cell?.name ?? tr("Sin célula asignada")),
      if (model.cells.length > 1)
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: locked ? null : () => changeCell(context),
            child: Text(tr("Cambiar célula")),
          ),
        ),
      if (model.cell != null) ...[
        const SizedBox(height: 24),
        Text(
          tr("Semana del {{p0}}", {
            'p0': DateFormat.MMMd(appLocale).format(startOfWeek(model.date)),
          }),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            TextButton(
              onPressed: locked ? null : () => changeWeek(context, -1),
              child: Text(tr("Anterior")),
            ),
            TextButton(
              onPressed: locked ? null : () => changeWeek(context, 1),
              child: Text(tr("Siguiente")),
            ),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: locked ? null : () => changeDate(context),
          icon: const AppIcon(Symbol.calendar, size: 20),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              tr("Elegir fecha · {{p0}}", {
                'p0': DateFormat.MMMMEEEEd(appLocale).format(model.date),
              }),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (model.meeting?.date != null) ...[
          const SizedBox(height: 12),
          Text(
            tr(
              "Esta semana tiene una reunión registrada. Para una nueva reunión, elige otra semana.",
            ),
          ),
        ],
        if (model.session?.permissions.contains('planner.write') ?? false) ...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: locked ? null : () => prepareNext(context),
            icon: const AppIcon(Symbol.calendar, color: Colors.white, size: 20),
            label: Text(
              tr("Preparar próxima célula"),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    ],
  );
}
