import 'package:timezone/timezone.dart' as tz;
import 'community.dart';

class ServiceAssignment {
  const ServiceAssignment({
    required this.id,
    this.shiftId = '',
    required this.date,
    required this.time,
    required this.ministry,
    this.role = '',
    this.timezone = 'America/Lima',
    this.confirmation = 'PENDING',
    this.blocked = true,
  });
  final String id, shiftId, date, time, ministry, role, timezone, confirmation;
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
        shiftId: data['shiftId'] as String? ?? '',
        date: data['date'] as String,
        time: data['time'] as String,
        ministry: data['ministry'] as String? ?? 'Mi ministerio',
        role: data['role'] as String? ?? '',
        timezone: data['timezone'] as String? ?? 'America/Lima',
        confirmation: data['confirmation'] as String? ?? 'PENDING',
        blocked: data['blocked'] != false,
      );
}

class ChurchAnnouncement {
  const ChurchAnnouncement({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.senderName = 'Iglesia',
    this.audienceLabel = '',
    this.isPinned = false,
    this.pinnedUntil,
    this.read = true,
    this.sent = false,
    this.activityName,
    this.activityStartDate,
    this.activityTime,
    this.activityLocation,
  });

  final String id, title, body, createdAt, senderName, audienceLabel;
  final bool isPinned, read, sent;
  final String? pinnedUntil,
      activityName,
      activityStartDate,
      activityTime,
      activityLocation;

  ChurchAnnouncement copyWith({bool? read}) => ChurchAnnouncement(
    id: id,
    title: title,
    body: body,
    createdAt: createdAt,
    senderName: senderName,
    audienceLabel: audienceLabel,
    isPinned: isPinned,
    pinnedUntil: pinnedUntil,
    read: read ?? this.read,
    sent: sent,
    activityName: activityName,
    activityStartDate: activityStartDate,
    activityTime: activityTime,
    activityLocation: activityLocation,
  );

  factory ChurchAnnouncement.fromJson(Map<String, dynamic> data) {
    final sender = data['senderId'];
    final activity = data['activitySummary'];
    return ChurchAnnouncement(
      id: data['_id'] as String? ?? '',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      createdAt: data['createdAt'] as String? ?? '',
      senderName: sender is Map<String, dynamic>
          ? (sender['name'] as String? ?? 'Iglesia')
          : 'Iglesia',
      audienceLabel: data['audienceLabel'] as String? ?? '',
      isPinned: data['isPinned'] == true,
      pinnedUntil: data['pinnedUntil'] as String?,
      read: data['read'] != false,
      sent: data['sent'] == true,
      activityName: activity is Map<String, dynamic>
          ? activity['name'] as String?
          : null,
      activityStartDate: activity is Map<String, dynamic>
          ? activity['startDate'] as String?
          : null,
      activityTime: activity is Map<String, dynamic>
          ? activity['time'] as String?
          : null,
      activityLocation: activity is Map<String, dynamic>
          ? activity['location'] as String?
          : null,
    );
  }
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
