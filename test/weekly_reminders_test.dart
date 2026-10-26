import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:timezone/data/latest.dart' as data;
import 'package:timezone/timezone.dart' as tz;
import 'package:sheeplink/domain/models/personal_profile.dart';
import 'package:sheeplink/domain/models/reminder_plan.dart';
import 'package:sheeplink/domain/models/weekly_meeting.dart';
import 'package:sheeplink/data/services/photo_service.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'fake_repository.dart';

void main() {
  setUpAll(data.initializeTimeZones);
  ServiceAssignment shift({
    String time = '10:00',
    String confirmation = 'CONFIRMED',
    bool blocked = false,
  }) => ServiceAssignment(
    id: 'sunday-1',
    date: '2026-10-25',
    time: time,
    ministry: 'Alabanza',
    role: 'Voz',
    confirmation: confirmation,
    blocked: blocked,
  );
  List<PlannedReminder> plan(
    List<ServiceAssignment> shifts, {
    DateTime? now,
    bool service = true,
  }) => reminderPlan(
    members: [],
    assignments: shifts,
    birthdayTimezone: 'America/Bogota',
    now: now ?? DateTime.utc(2026, 10, 23),
    service: service,
  );
  test(
    'confirmed service has previous evening and same-day reminders in local timezone',
    () {
      final reminders = plan([shift(), shift()]);
      expect(reminders.length, 2);
      expect(
        reminders[0].when,
        tz.TZDateTime(tz.getLocation('America/Lima'), 2026, 10, 24, 19),
      );
      expect(
        reminders[1].when,
        tz.TZDateTime(tz.getLocation('America/Lima'), 2026, 10, 25, 8),
      );
    },
  );
  test(
    'pending, declined and restricted shifts do not notify; preferences are respected',
    () {
      expect(
        plan([
          shift(confirmation: 'PENDING'),
          shift(confirmation: 'DECLINED'),
          shift(blocked: true),
        ]),
        isEmpty,
      );
      expect(plan([shift()], service: false), isEmpty);
    },
  );
  test(
    'early service remains on same day; past reminders are not backfilled',
    () {
      final reminders = plan([shift(time: '01:00')]);
      expect(reminders.last.when.hour, 0);
      expect(reminders.last.when.day, 25);
      expect(plan([shift()], now: DateTime.utc(2026, 10, 25, 14)).length, 0);
    },
  );
  test(
    'weekly boundaries cross year; future default meeting dates are avoided',
    () {
      expect(startOfWeek(DateTime(2027, 1, 3)), DateTime(2026, 12, 28));
      expect(
        meetingDateForWeek(
          DateTime(2026, 10, 19),
          'Saturday',
          DateTime(2026, 10, 22),
        ),
        DateTime(2026, 10, 22),
      );
    },
  );
  test(
    'partial weekly save keeps photo and supports retry without losing attendance',
    () async {
      final repo = FakeRepository()..failMeeting = true;
      final vm = CommunityViewModel(repo);
      await vm.restore();
      vm.mark('a', true);
      vm.markRemainingAbsent();
      vm.setPhoto(Uint8List.fromList([1, 2, 3]));
      await vm.save();
      expect(repo.records.length, 3);
      expect(vm.dirty, isTrue);
      expect(vm.pendingPhoto, isNotNull);
      expect(vm.error, contains('La asistencia está guardada'));
      repo.failMeeting = false;
      await vm.save();
      expect(vm.dirty, isFalse);
      expect(vm.meeting?.photoUrl, isNotNull);
      expect(vm.pendingPhoto, isNull);
      vm.dispose();
    },
  );
  test('servant profile loads without cell management permissions', () async {
    final repo = FakeRepository()
      ..permissions = {}
      ..profile = PersonalProfile(phone: '555', assignments: [shift()]);
    final vm = CommunityViewModel(repo);
    await vm.restore();
    expect(vm.error, isNull);
    expect(vm.personal.assignments.length, 1);
    expect(vm.canWrite, isFalse);
    vm.dispose();
  });
  test(
    'photo is resized, stripped and compressed before upload; invalid bytes rejected',
    () {
      final input = image.Image(width: 1600, height: 800);
      input.exif.imageIfd['Make'] = 'Private camera';
      final output = preparePhoto(Uint8List.fromList(image.encodeJpg(input)));
      final decoded = image.decodeJpg(output)!;
      expect(decoded.width, 1280);
      expect(decoded.height, 640);
      expect(decoded.exif.imageIfd['Make'], isNull);
      expect(output.length, lessThanOrEqualTo(512000));
      expect(
        () => preparePhoto(Uint8List.fromList([1, 2, 3])),
        throwsStateError,
      );
    },
  );
}
