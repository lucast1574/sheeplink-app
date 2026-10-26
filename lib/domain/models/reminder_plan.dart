import 'package:timezone/timezone.dart' as tz;
import 'community.dart';
import 'personal_profile.dart';

class PlannedReminder {
  const PlannedReminder({
    required this.when,
    required this.title,
    required this.body,
    required this.destination,
  });
  final tz.TZDateTime when;
  final String title, body, destination;
}

List<PlannedReminder> reminderPlan({
  required List<Member> members,
  required List<ServiceAssignment> assignments,
  required String birthdayTimezone,
  required DateTime now,
  bool birthdays = true,
  bool service = true,
}) {
  final planned = <PlannedReminder>[];
  void add(PlannedReminder reminder) {
    if (reminder.when.isAfter(now) &&
        reminder.when.difference(now) <= const Duration(days: 31)) {
      planned.add(reminder);
    }
  }

  if (birthdays) {
    final location = tz.getLocation(birthdayTimezone),
        local = tz.TZDateTime.from(now, tz.getLocation(birthdayTimezone));
    for (final member in members) {
      if (member.birthday == null) continue;
      var date = nextBirthday(member.birthday!, local);
      var when = tz.TZDateTime(location, date.year, date.month, date.day, 9);
      if (!when.isAfter(now)) {
        date = nextBirthday(
          member.birthday!,
          DateTime(local.year, local.month, local.day + 1),
        );
        when = tz.TZDateTime(location, date.year, date.month, date.day, 9);
      }
      add(
        PlannedReminder(
          when: when,
          title: 'Un día para acompañar',
          body:
              'Hoy cumple años ${member.name}. Un saludo puede alegrarle el día.',
          destination: 'birthdays',
        ),
      );
    }
  }
  if (service) {
    final seen = <String>{};
    for (final assignment in assignments) {
      if (!assignment.confirmed || !seen.add(assignment.id)) continue;
      final start = assignment.startsAt;
      if (!start.isAfter(now)) continue;
      final previous = tz.TZDateTime(
        start.location,
        start.year,
        start.month,
        start.day - 1,
        19,
      );
      final midnight = tz.TZDateTime(
        start.location,
        start.year,
        start.month,
        start.day,
      );
      final early = start.subtract(const Duration(hours: 2));
      final sameDay = early.isBefore(midnight) ? midnight : early;
      final detail =
          '${assignment.ministry}${assignment.role.isEmpty ? '' : ' · ${assignment.role}'} a las ${assignment.time}.';
      add(
        PlannedReminder(
          when: previous,
          title: 'Mañana te toca servir',
          body: detail,
          destination: 'service',
        ),
      );
      add(
        PlannedReminder(
          when: sameDay,
          title: 'Hoy te toca servir',
          body: detail,
          destination: 'service',
        ),
      );
    }
  }
  planned.sort((a, b) => a.when.compareTo(b.when));
  return List.unmodifiable(planned.take(60));
}
