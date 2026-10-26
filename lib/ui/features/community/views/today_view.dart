import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../view_models/community_view_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import 'birthday_section.dart';
import 'service_section.dart';

class TodayView extends StatelessWidget {
  const TodayView({super.key, required this.model, required this.onAttendance});
  final CommunityViewModel model;
  final VoidCallback onAttendance;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        DateFormat("EEEE d 'de' MMMM", 'es').format(DateTime.now()),
        style: const TextStyle(fontSize: 13),
      ),
      const SizedBox(height: 10),
      Text(
        'Hola, ${model.session!.name.split(' ').first}.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 8),
      const Text('Lo importante es estar cerca.'),
      const SizedBox(height: 28),
      ServiceSection(assignments: model.personal.assignments),
      const SizedBox(height: 24),
      if (model.canWrite)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.forest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.cell?.name ?? 'Tu célula',
                style: const TextStyle(
                  color: Color(0xFFC8DBAC),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cada persona\ncuenta.',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                model.cell == null
                    ? 'Todavía no tienes una célula asignada.'
                    : '${model.members.length} integrantes para acompañar.',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              if (model.cell != null)
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.leaf,
                    foregroundColor: AppTheme.ink,
                  ),
                  onPressed: onAttendance,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: Text('Marcar asistencia')),
                      SizedBox(width: 14),
                      AppIcon(Symbol.arrow),
                    ],
                  ),
                ),
            ],
          ),
        ),
      const SizedBox(height: 36),
      BirthdaySection(
        members: model.members,
        timezone: model.cell?.timezone ?? "America/Lima",
      ),
    ],
  );
}
