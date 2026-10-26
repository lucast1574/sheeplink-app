class Session {
  const Session({
    required this.id,
    required this.name,
    required this.email,
    required this.churchName,
    required this.permissions,
    this.photoUrl,
  });
  final String id, name, email, churchName;
  final Set<String> permissions;
  final String? photoUrl;
  Session withPhoto(String? value) => Session(
    id: id,
    name: name,
    email: email,
    churchName: churchName,
    permissions: permissions,
    photoUrl: photoUrl ?? value,
  );
  factory Session.fromJson(Map<String, dynamic> data) {
    final user = data['user'] as Map<String, dynamic>;
    return Session(
      id: user['id'] as String,
      name: user['name'] as String,
      email: user['email'] as String,
      churchName: data['church']?['name'] as String? ?? 'Mi comunidad',
      photoUrl: user['photoUrl'] as String?,
      permissions: Set<String>.from(user['permissions'] as List? ?? []),
    );
  }
}

class Cell {
  const Cell({
    required this.id,
    required this.name,
    required this.timezone,
    this.meetingDay = "Saturday",
  });
  final String id, name, timezone, meetingDay;
  factory Cell.fromJson(Map<String, dynamic> data) => Cell(
    id: data['_id'] as String,
    name: data['name'] as String,
    timezone: data['timezone'] as String? ?? 'America/Lima',
    meetingDay: data['meetingDay'] as String? ?? 'Saturday',
  );
}

class Member {
  const Member({required this.id, required this.name, this.birthday});
  final String id, name;
  final DateTime? birthday;
  factory Member.fromJson(Map<String, dynamic> data) => Member(
    id: data['_id'] as String,
    name: data['name'] as String,
    birthday: DateTime.tryParse(data['birthday'] as String? ?? '')?.toUtc(),
  );
}

/// Calendar-only rule: Feb 29 is observed on Feb 28 in non-leap years.
DateTime nextBirthday(DateTime birth, DateTime today) {
  DateTime inYear(int year) {
    final last = DateTime(year, birth.month + 1, 0).day;
    return DateTime(year, birth.month, birth.day > last ? last : birth.day);
  }

  final day = DateTime(today.year, today.month, today.day);
  final candidate = inYear(today.year);
  return candidate.isBefore(day) ? inYear(today.year + 1) : candidate;
}

String? googlePhoto(Object? value) {
  if (value is! String || value.length > 2048) return null;
  final url = Uri.tryParse(value);
  return url != null &&
          url.scheme == 'https' &&
          url.host.endsWith('.googleusercontent.com') &&
          url.userInfo.isEmpty &&
          url.port == 443
      ? url.toString()
      : null;
}
