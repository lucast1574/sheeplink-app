import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../domain/models/community.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';

class BirthdaySection extends StatelessWidget {
  const BirthdaySection({
    super.key,
    required this.members,
    required this.timezone,
  });
  final List<Member> members;
  final String timezone;
  @override
  Widget build(BuildContext context) {
    final now = tz.TZDateTime.now(tz.getLocation(timezone));
    final upcoming =
        members
            .where((m) => m.birthday != null)
            .map((m) => (member: m, day: nextBirthday(m.birthday!, now)))
            .where(
              (e) =>
                  e.day
                      .difference(DateTime(now.year, now.month, now.day))
                      .inDays <=
                  30,
            )
            .toList()
          ..sort((a, b) => a.day.compareTo(b.day));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const AppIcon(Symbol.gift, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Un día para celebrar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text('Cumpleaños de tu célula · próximos 30 días'),
        const SizedBox(height: 16),
        if (upcoming.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('No hay cumpleaños registrados para estos días.'),
          ),
        for (final birthday in upcoming)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.leaf,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat(
                          'MMM',
                          'es',
                        ).format(birthday.day).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${birthday.day.day}',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        birthday.member.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        DateUtils.isSameDay(birthday.day, now)
                            ? 'Hoy · un saludo hace la diferencia'
                            : 'Un buen día para hacerle sentir parte.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
