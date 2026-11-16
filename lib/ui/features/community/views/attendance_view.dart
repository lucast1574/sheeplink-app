import 'cell_meeting_selector.dart';
import 'attendance_person_card.dart';
import 'package:flutter/material.dart';
import 'meeting_topic.dart';
import 'weekly_photo.dart';
import '../view_models/community_view_model.dart';
import '../../../core/widgets/feedback_panel.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({
    super.key,
    required this.model,
    this.showSelector = true,
  });
  final CommunityViewModel model;
  final bool showSelector;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showSelector) ...[
        CellMeetingSelector(model: model),
        const SizedBox(height: 24),
      ],
      if (model.isFutureMeeting) ...[
        const FeedbackPanel(
          'La reunión está por realizarse. Prepara el plan ahora y registra la asistencia cuando llegue el día.',
        ),
      ] else ...[
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
            AttendancePersonCard(
              name: member.name,
              present: model.marked(member.id),
              onChanged: model.canWrite && !model.busy
                  ? (present) => model.mark(member.id, present)
                  : null,
            ),
          if (model.canWrite)
            TextButton(
              onPressed: model.busy ? null : model.markRemainingAbsent,
              child: const Text('Marcar pendientes como ausentes'),
            ),
          MeetingTopic(
            model: model,
            key: ValueKey('topic-${model.cell?.id}/${model.week}'),
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
    ],
  );
}
