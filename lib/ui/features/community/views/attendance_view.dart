import '../../../../l10n/locale.dart';
import 'cell_meeting_selector.dart';
import 'cell_pane.dart';
import 'attendance_person_card.dart';
import 'package:flutter/material.dart';
import 'cell_disclosure.dart';
import 'meeting_topic.dart';
import 'weekly_photo.dart';
import '../view_models/community_view_model.dart';
import '../../../core/widgets/feedback_panel.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({
    super.key,
    required this.model,
    this.showSelector = true,
    this.onPrepare,
  });
  final CommunityViewModel model;
  final bool showSelector;
  final VoidCallback? onPrepare;
  @override
  Widget build(BuildContext context) => CellPane(
    storageKey: 'attendance',
    model: model,
    footer: !model.isFutureMeeting && model.members.isNotEmpty && model.canWrite
        ? FilledButton(
            onPressed: model.canSave ? model.save : null,
            child: Text(tr(model.busy ? 'Guardando…' : 'Guardar reunión')),
          )
        : null,
    children: [
      if (model.cell != null) ...[
        CellMeetingSelector(model: model, onPrepare: onPrepare),
        const SizedBox(height: 24),
      ],
      if (model.isFutureMeeting) ...[
        FeedbackPanel(
          tr(
            "La reunión está por realizarse. Prepara el plan ahora y registra la asistencia cuando llegue el día.",
          ),
        ),
      ] else ...[
        if (!model.canWrite)
          FeedbackPanel(
            tr(
              "Tu cuenta puede consultar esta célula. El registro requiere permiso de asistencia.",
            ),
          ),
        if (model.members.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text(tr("Aún no hay integrantes activos en esta célula.")),
          ),
        if (model.members.isNotEmpty) ...[
          Text(
            tr("{{p0}} de {{p1}} marcados · {{p2}} presentes", {
              'p0': model.markedCount,
              'p1': model.members.length,
              'p2': model.presentCount,
            }),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(tr("Marca presente o ausente para cada persona.")),
          const SizedBox(height: 16),
          for (final member in model.members)
            AttendancePersonCard(
              compact: true,
              name: member.name,
              present: model.marked(member.id),
              onClear: model.canWrite && !model.busy
                  ? () => model.clearMark(member.id)
                  : null,
              onChanged: model.canWrite && !model.busy
                  ? (present) => model.mark(member.id, present)
                  : null,
            ),
          if (model.canWrite)
            CellDisclosure(
              tilePadding: EdgeInsets.zero,
              title: Text(tr('Opciones de asistencia')),
              children: [
                TextButton(
                  onPressed: model.busy ? null : model.markRemainingAbsent,
                  child: Text(tr('Marcar pendientes como ausentes')),
                ),
              ],
            ),
          const SizedBox(height: 24),
          CellDisclosure(
            title: Text(tr('Tema y foto del encuentro')),
            tilePadding: EdgeInsets.zero,
            maintainState: true,
            onExpansionChanged: (_) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            children: [
              MeetingTopic(
                model: model,
                key: ValueKey(
                  'topic-${model.cell?.id}/${model.week}/${model.meetingRevision}',
                ),
              ),
              WeeklyPhoto(
                key: ValueKey('${model.cell?.id}/${model.week}'),
                model: model,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 8),
          Text(
            model.markedCount < model.members.length
                ? tr("Completa todas las marcas para guardar.")
                : tr("Puedes corregir las marcas antes de guardar."),
          ),
        ],
      ],
    ],
  );
}
