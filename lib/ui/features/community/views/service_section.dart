import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '../../../../domain/models/personal_profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key, required this.assignments});
  final List<ServiceAssignment> assignments;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcoming =
        assignments
            .where(
              (s) =>
                  !s.blocked &&
                  s.confirmation != 'DECLINED' &&
                  s.startsAt.add(const Duration(hours: 3)).isAfter(now),
            )
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const AppIcon(Symbol.calendar, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Tu servicio',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (upcoming.isEmpty)
          const Text(
            'No tienes turnos próximos asignados. Cuando tu líder programe uno, aparecerá aquí.',
          ),
        for (final shift in upcoming.take(3))
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: shift.confirmed ? AppTheme.leaf : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateUtils.isSameDay(
                        shift.startsAt,
                        tz.TZDateTime.from(now, shift.startsAt.location),
                      )
                      ? (shift.confirmed
                            ? 'Hoy te toca servir'
                            : 'Asignación de hoy')
                      : '${DateFormat("EEEE d 'de' MMMM", 'es').format(shift.startsAt)} · ${shift.time}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  shift.ministry,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${shift.role.isEmpty ? 'Servicio' : shift.role} · ${shift.time}',
                ),
                if (!shift.confirmed)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Asignación pendiente de confirmar. Aún no genera recordatorios.',
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
