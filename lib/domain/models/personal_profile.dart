import 'package:timezone/timezone.dart' as tz;
import 'community.dart';

class ServiceAssignment {
  const ServiceAssignment({
    required this.id,
    required this.date,
    required this.time,
    required this.ministry,
    this.role = '',
    this.timezone = 'America/Lima',
    this.confirmation = 'PENDING',
    this.blocked = true,
  });
  final String id, date, time, ministry, role, timezone, confirmation;
  final bool blocked;
  bool get confirmed => !blocked && confirmation == 'CONFIRMED';
  tz.TZDateTime get startsAt {
    final day = DateTime.parse(date), clock = time.split(':');
    return tz.TZDateTime(
      tz.getLocation(timezone),
      day.year,
      day.month,
      day.day,
      int.parse(clock[0]),
      int.parse(clock[1]),
    );
  }

  factory ServiceAssignment.fromJson(Map<String, dynamic> data) =>
      ServiceAssignment(
        id: data['id'] as String,
        date: data['date'] as String,
        time: data['time'] as String,
        ministry: data['ministry'] as String? ?? 'Mi ministerio',
        role: data['role'] as String? ?? '',
        timezone: data['timezone'] as String? ?? 'America/Lima',
        confirmation: data['confirmation'] as String? ?? 'PENDING',
        blocked: data['blocked'] != false,
      );
}

class PersonalProfile {
  const PersonalProfile({
    this.phone = '',
    this.birthday,
    this.roles = const [],
    this.ministries = const [],
    this.responsibilities = const [],
    this.assignments = const [],
    this.cell,
  });
  final String phone;
  final DateTime? birthday;
  final List<String> roles, ministries, responsibilities;
  final List<ServiceAssignment> assignments;
  final Cell? cell;
  factory PersonalProfile.fromJson(Map<String, dynamic> data) =>
      PersonalProfile(
        phone: data['phone'] as String? ?? '',
        birthday: DateTime.tryParse(data['birthday'] as String? ?? ''),
        roles: List.unmodifiable(
          (data['roles'] as List? ?? []).map((e) => e['name'] as String),
        ),
        ministries: List.unmodifiable(
          (data['ministries'] as List? ?? []).map((e) => e['name'] as String),
        ),
        responsibilities: List.unmodifiable(
          (data['responsibilities'] as List? ?? []).map(
            (e) => '${e['type']} · ${e['name']}',
          ),
        ),
        assignments: List.unmodifiable(
          (data['calendar'] as List? ?? [])
              .where(
                (e) =>
                    e['shiftId'] is String &&
                    RegExp(
                      r'^\d{4}-\d{2}-\d{2}$',
                    ).hasMatch(e['date'] as String? ?? '') &&
                    RegExp(
                      r'^([01]\d|2[0-3]):[0-5]\d$',
                    ).hasMatch(e['time'] as String? ?? ''),
              )
              .map(
                (e) => ServiceAssignment.fromJson(e as Map<String, dynamic>),
              ),
        ),
        cell: data['cell'] is Map<String, dynamic>
            ? Cell.fromJson(data['cell'] as Map<String, dynamic>)
            : null,
      );
}
