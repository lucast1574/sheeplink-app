import 'dart:convert';
import '../../../../domain/models/personal_profile.dart';
import '../../../../domain/models/weekly_meeting.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/community_repository.dart';
import '../../../../data/services/api_client.dart';
import '../../../../data/services/google_identity.dart';
import '../../../../domain/models/community.dart';

class CommunityViewModel extends ChangeNotifier {
  CommunityViewModel(this.repository, {this.googleIdentity});
  final GoogleIdentity? googleIdentity;
  final CommunityRepository repository;
  Session? session;
  List<Cell> cells = [];
  List<Member> members = [];
  Cell? cell;
  PersonalProfile personal = const PersonalProfile();
  WeeklyMeeting? meeting;
  Uint8List? photoBytes, pendingPhoto;
  bool _metadataDirty = false;
  bool pickingPhoto = false;
  String get week => DateFormat('yyyy-MM-dd').format(startOfWeek(date));
  String? photoError;

  Map<String, bool> _saved = {}, _draft = {};
  DateTime date = DateTime.now();
  bool busy = false, restoring = true;
  String? error, notice;
  int _generation = 0;
  bool get dirty =>
      !mapEquals(_saved, _draft) || pendingPhoto != null || _metadataDirty;
  bool? marked(String id) => _draft[id];
  int get markedCount => members.where((m) => _draft.containsKey(m.id)).length;
  int get presentCount => members.where((m) => _draft[m.id] == true).length;
  bool get canWrite =>
      session?.permissions.contains('attendance.write') ?? false;
  bool get canSave =>
      canWrite &&
      members.isNotEmpty &&
      markedCount == members.length &&
      dirty &&
      !busy &&
      !pickingPhoto;
  String get day => DateFormat('yyyy-MM-dd').format(date);
  Future<void> restore() async {
    busy = true;
    notifyListeners();
    try {
      session = await repository.session();
      await _loadCells();
    } catch (e) {
      if (session != null) {
        error = friendlyError(e);
      }
    } finally {
      busy = false;
      restoring = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) =>
      _signIn(() => repository.login(email, password));

  Future<void> loginGoogle() => _signIn(() async {
    final identity = googleIdentity;
    if (identity == null) throw StateError('Google access is not configured.');
    final token = await identity.firebaseIdToken();
    return token == null ? null : repository.loginGoogle(token);
  });

  Future<void> _signIn(Future<Session?> Function() authenticate) async {
    if (busy) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      final authenticated = await authenticate();
      if (authenticated == null) return;
      session = authenticated;
      await _loadCells();
    } catch (e) {
      error = friendlyError(e);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> _loadCells() async {
    personal = await repository.personal();
    cells = session!.permissions.contains('cells.read')
        ? await repository.cells()
        : [];
    cell = cells.isEmpty ? personal.cell : cells.first;
    if (cell != null) {
      date = meetingDateForWeek(
        DateTime.now(),
        cell!.meetingDay,
        DateTime.now(),
      );
    }
    await _loadRoster();
  }

  Future<void> _loadRoster() async {
    final selected = cell;
    if (selected == null || !session!.permissions.contains('members.read')) {
      members = [];
      _saved = {};
      _draft = {};
      meeting = null;
      photoBytes = null;
      pendingPhoto = null;
      _metadataDirty = false;
      return;
    }
    final generation = ++_generation;
    final loadedMeeting = await repository.meeting(selected.id, week);
    final loadedDate = loadedMeeting.date == null
        ? date
        : DateTime.parse(loadedMeeting.date!);
    final loadedMembers = await repository.members(selected.id);
    final loadedAttendance = await repository.attendance(
      selected.id,
      DateFormat('yyyy-MM-dd').format(loadedDate),
    );
    Uint8List? loadedPhoto;
    String? loadedPhotoError;
    if (loadedMeeting.photoUrl != null) {
      try {
        loadedPhoto = await repository.photo(loadedMeeting.photoUrl!);
      } catch (_) {
        loadedPhotoError = 'No pudimos cargar la foto de esta semana.';
      }
    }
    if (generation != _generation) return;
    date = loadedDate;
    meeting = loadedMeeting;
    members = List.unmodifiable(loadedMembers);
    _saved = Map.of(loadedAttendance);
    _draft = Map.of(loadedAttendance);
    photoBytes = loadedPhoto;
    photoError = loadedPhotoError;
    pendingPhoto = null;
    _metadataDirty = false;
  }

  void photoSelection(bool value) {
    pickingPhoto = value;
    notifyListeners();
  }

  void setPhoto(Uint8List bytes) {
    if (!canWrite || busy) return;
    pendingPhoto = bytes;
    photoError = null;
    notice = null;
    notifyListeners();
  }

  void discardPhoto() {
    pendingPhoto = null;
    notifyListeners();
  }

  Future<void> refresh({Cell? selected, DateTime? selectedDate}) async {
    if (busy || pickingPhoto) return;
    busy = true;
    error = null;
    notice = null;
    notifyListeners();
    final oldCell = cell, oldDate = date;
    if (selected != null) cell = selected;
    if (selectedDate != null) date = selectedDate;
    try {
      final loadedProfile = await repository.personal();
      await _loadRoster();
      personal = loadedProfile;
    } catch (e) {
      cell = oldCell;
      date = oldDate;
      error = friendlyError(e);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void mark(String id, bool present) {
    if (!canWrite || busy) return;
    _draft = {..._draft, id: present};
    notice = null;
    notifyListeners();
  }

  void markRemainingAbsent() {
    if (!canWrite || busy) return;
    _draft = {
      for (final member in members) member.id: _draft[member.id] ?? false,
    };
    notifyListeners();
  }

  Future<void> save() async {
    if (!canSave || cell == null) return;
    busy = true;
    error = null;
    notice = null;
    notifyListeners();
    try {
      final records = {
        for (final member in members) member.id: _draft[member.id]!,
      };
      await repository.saveAttendance(cell!.id, day, records);
      _saved = Map.of(records);
      _metadataDirty = true;
      meeting = await repository.saveMeeting(
        cell!.id,
        week,
        day,
        pendingPhoto == null
            ? null
            : 'data:image/jpeg;base64,${base64Encode(pendingPhoto!)}',
      );
      if (pendingPhoto != null) photoBytes = pendingPhoto;
      pendingPhoto = null;
      _metadataDirty = false;
      notice =
          'Reunión semanal guardada. Ya forma parte del historial de tu célula.';
    } catch (e) {
      error = _metadataDirty
          ? 'La asistencia está guardada; falta guardar la foto o el registro semanal. Reintenta. ${friendlyError(e)}'
          : friendlyError(e);
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> updateAvatar(Uint8List bytes) async {
    final owner = session?.id;
    if (owner == null) return;
    final updated = await repository.updateAvatar(
      'data:image/jpeg;base64,${base64Encode(bytes)}',
    );
    if (session?.id == owner) {
      session = updated;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    if (busy) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await repository.logout();
      ++_generation;
      session = null;
      cells = [];
      members = [];
      cell = null;
      personal = const PersonalProfile();
      meeting = null;
      photoBytes = null;
      pendingPhoto = null;
      _metadataDirty = false;
      _saved = {};
      _draft = {};
      notice = null;
      return true;
    } catch (e) {
      error = friendlyError(e);
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}
