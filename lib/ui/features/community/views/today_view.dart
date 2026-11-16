import '../../../../l10n/locale.dart';
import 'daily_journal.dart';
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
        DateFormat.MMMMEEEEd(appLocale).format(DateTime.now()),
        style: const TextStyle(fontSize: 13),
      ),
      const SizedBox(height: 10),
      Text(
        tr("Hola, {{p0}}.", {'p0': model.session!.name.split(' ').first}),
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 8),
      Text(tr("Lo importante es estar cerca.")),
      const SizedBox(height: 28),
      DailyJournal(model: model),
      const SizedBox(height: 24),
      ServiceSection(
        assignments: model.personal.assignments,
        busy: model.busy,
        onAccept: model.acceptShift,
        onDecline: (shift, reason) => model.declineShift(shift, reason: reason),
      ),
      const SizedBox(height: 24),
      if (model.canWrite)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.cell?.name ?? tr("Tu célula"),
                style: const TextStyle(
                  color: AppTheme.forest,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tr("Cada persona\ncuenta."),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.ink,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                model.cell == null
                    ? tr("Todavía no tienes una célula asignada.")
                    : tr("{{p0}} integrantes para acompañar.", {
                        'p0': model.members.length,
                      }),
                style: const TextStyle(color: AppTheme.muted),
              ),
              const SizedBox(height: 24),
              if (model.cell != null)
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.forest,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onAttendance,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: Text(tr("Marcar asistencia"))),
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
