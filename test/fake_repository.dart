import 'dart:typed_data';
import 'package:sheeplink/domain/models/personal_profile.dart';
import 'package:sheeplink/domain/models/weekly_meeting.dart';
import 'package:sheeplink/data/repositories/community_repository.dart';
import 'package:sheeplink/domain/models/community.dart';

class FakeRepository implements CommunityRepository {
  bool failSave = false;
  String? report;
  @override
  Future<void> reportContent(
    String context,
    String message,
    String requestId,
  ) async {
    report = '$context: $message';
  }

  int writes = 0;
  String? registeredId;
  String? googleToken;
  bool rejectGoogle = false;
  Set<String> permissions = {'attendance.write', 'cells.read', 'members.read'};
  @override
  Future<Session> updateAvatar(String photoData) async {
    final user = await session();
    return Session(
      id: user.id,
      name: user.name,
      email: user.email,
      churchName: user.churchName,
      permissions: user.permissions,
      photoUrl: '/api/media/users/leader/avatar?v=1',
    );
  }

  PersonalProfile profile = const PersonalProfile();
  bool failMeeting = false;
  WeeklyMeeting? savedMeeting;
  @override
  Future<PersonalProfile> personal() async => profile;
  @override
  Future<WeeklyMeeting> meeting(String cellId, String week) async =>
      savedMeeting?.weekStart == week
      ? savedMeeting!
      : WeeklyMeeting(weekStart: week);
  @override
  Future<WeeklyMeeting> saveMeeting(
    String cellId,
    String week,
    String date,
    String? photoData,
  ) async {
    if (failMeeting) throw StateError('photo upload failed');
    return savedMeeting = WeeklyMeeting(
      weekStart: week,
      date: date,
      photoUrl: photoData == null
          ? null
          : '/api/cells/cell/meetings/$week/photo',
    );
  }

  @override
  Future<Uint8List> photo(String url) async => Uint8List(0);
  final records = <String, bool>{};
  @override
  Future<Session> session() async => Session(
    id: 'leader',
    name: 'Lucía Torres',
    email: 'leader@example.test',
    churchName: 'Comunidad de prueba',
    permissions: permissions,
  );
  @override
  Future<Session> login(String email, String password) => session();
  @override
  Future<Session> loginGoogle(String firebaseIdToken) async {
    googleToken = firebaseIdToken;
    if (rejectGoogle) throw StateError('Account unavailable');
    return session();
  }

  @override
  Future<void> logout() async {}
  @override
  Future<List<Cell>> cells() async => [
    const Cell(id: 'cell', name: 'Célula Los Olivos', timezone: 'America/Lima'),
  ];
  @override
  Future<List<Member>> members(String cellId) async => [
    Member(
      id: 'a',
      name: 'Ana de la Cruz',
      birthday: DateTime(1995, DateTime.now().month, DateTime.now().day),
    ),
    const Member(id: 'b', name: 'Mateo Ríos'),
    const Member(id: 'c', name: 'Valentina Rodríguez Martínez'),
  ];
  @override
  Future<Map<String, bool>> attendance(String cellId, String day) async =>
      Map.of(records);
  @override
  Future<void> saveAttendance(
    String cellId,
    String day,
    Map<String, bool> values,
  ) async {
    writes++;
    if (failSave) throw StateError('offline');
    records.addAll(values);
  }

  @override
  Future<void> registerDevice(String token) async {
    registeredId = token;
  }

  @override
  Future<void> revokeDevice(String token) async {}
}
