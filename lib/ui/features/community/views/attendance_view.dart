import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/community.dart';
import '../../../../domain/models/weekly_meeting.dart';
import 'weekly_photo.dart';
import '../view_models/community_view_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/feedback_panel.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key, required this.model});
  final CommunityViewModel model;
  Future<void> changeDate(BuildContext context) async {
    if (model.dirty && !await confirmDiscard(context)) return;
    if (!context.mounted) return;
    final date = await showDatePicker(
      context: context,
      initialDate: model.date,
      firstDate: startOfWeek(model.date),
      lastDate:
          startOfWeek(
            model.date,
          ).add(const Duration(days: 6)).isAfter(DateTime.now())
          ? DateTime.now()
          : startOfWeek(model.date).add(const Duration(days: 6)),
      locale: const Locale('es'),
    );
    if (date != null) await model.refresh(selectedDate: date);
  }

  Future<void> changeCell(BuildContext context) async {
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
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Elige tu célula',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
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
      ),
    );
    if (selected != null) await model.refresh(selected: selected);
  }

  Future<void> changeWeek(BuildContext context, int offset) async {
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

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Mi célula', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 8),
      Text(model.cell?.name ?? 'Sin célula asignada'),
      if (model.cells.length > 1)
        TextButton(
          onPressed: model.busy ? null : () => changeCell(context),
          child: const Text('Cambiar célula'),
        ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Text(
              "Semana del ${DateFormat('d MMM', 'es').format(startOfWeek(model.date))}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          TextButton(
            onPressed: model.busy || model.pickingPhoto
                ? null
                : () => changeWeek(context, -1),
            child: const Text('Anterior'),
          ),
          TextButton(
            onPressed:
                model.busy ||
                    model.pickingPhoto ||
                    !startOfWeek(
                      model.date,
                    ).isBefore(startOfWeek(DateTime.now()))
                ? null
                : () => changeWeek(context, 1),
            child: const Text('Siguiente'),
          ),
        ],
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed:
            model.busy || model.pickingPhoto || model.meeting?.date != null
            ? null
            : () => changeDate(context),
        icon: const AppIcon(Symbol.calendar, size: 20),
        label: Text(DateFormat("EEEE d 'de' MMMM", 'es').format(model.date)),
      ),
      const SizedBox(height: 20),
      if (!model.canWrite)
        const FeedbackPanel(
          'Tu cuenta puede consultar esta célula. El registro requiere permiso de asistencia.',
        ),
      if (model.members.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text('Aún no hay integrantes activos en esta célula.'),
        ),
      if (model.members.isNotEmpty) ...[
        Text(
          '${model.markedCount} de ${model.members.length} marcados · ${model.presentCount} presentes',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const Text('Marca presente o ausente para cada persona.'),
        const SizedBox(height: 16),
        for (final member in model.members)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Mark(
                        label: 'Presente',
                        selected: model.marked(member.id) == true,
                        symbol: Symbol.check,
                        onTap: model.canWrite && !model.busy
                            ? () => model.mark(member.id, true)
                            : null,
                      ),
                      _Mark(
                        label: 'Ausente',
                        selected: model.marked(member.id) == false,
                        symbol: Symbol.close,
                        onTap: model.canWrite && !model.busy
                            ? () => model.mark(member.id, false)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (model.canWrite)
          TextButton(
            onPressed: model.busy ? null : model.markRemainingAbsent,
            child: const Text('Marcar pendientes como ausentes'),
          ),
        WeeklyPhoto(
          key: ValueKey('${model.cell?.id}/${model.week}'),
          model: model,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: model.canSave ? model.save : null,
            child: Text(
              model.busy
                  ? 'Guardando…'
                  : model.dirty
                  ? 'Guardar reunión'
                  : model.markedCount == model.members.length
                  ? 'Reunión guardada'
                  : 'Guardar reunión',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          model.markedCount < model.members.length
              ? 'Completa todas las marcas para guardar.'
              : 'Puedes corregir las marcas antes de guardar.',
        ),
      ],
    ],
  );
}

class _Mark extends StatelessWidget {
  const _Mark({
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
        backgroundColor: selected ? AppTheme.leaf : const Color(0xFFF2F4EF),
        foregroundColor: AppTheme.ink,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      icon: AppIcon(symbol, size: 18),
      label: Text(label),
    ),
  );
}
