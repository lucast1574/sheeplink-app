import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheeplink/domain/models/community.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'fake_repository.dart';
import 'package:sheeplink/data/services/google_identity.dart';

class FakeGoogleIdentity implements GoogleIdentity {
  FakeGoogleIdentity(this.token);
  final String? token;
  @override
  Future<String?> firebaseIdToken() async => token;
}

void main() {
  test(
    'avatar update refreshes session without touching attendance draft',
    () async {
      final vm = CommunityViewModel(FakeRepository());
      await vm.restore();
      vm.mark('a', true);
      await vm.updateAvatar(Uint8List.fromList([1, 2, 3]));
      expect(vm.session?.photoUrl, contains('/api/media/users/leader/avatar'));
      expect(vm.marked('a'), isTrue);
      expect(vm.dirty, isTrue);
      vm.dispose();
    },
  );
  test('Google identity creates the existing backend session', () async {
    final repository = FakeRepository();
    final model = CommunityViewModel(
      repository,
      googleIdentity: FakeGoogleIdentity('firebase-test-id'),
    );
    await model.loginGoogle();
    expect(repository.googleToken, 'firebase-test-id');
    expect(model.session?.id, 'leader');
    expect(model.members.length, 3);
    expect(model.busy, isFalse);
    model.dispose();
  });
  test(
    'cancelled Google picker does not contact backend or show an error',
    () async {
      final repository = FakeRepository();
      final model = CommunityViewModel(
        repository,
        googleIdentity: FakeGoogleIdentity(null),
      );
      await model.loginGoogle();
      expect(repository.googleToken, isNull);
      expect(model.session, isNull);
      expect(model.error, isNull);
      expect(model.busy, isFalse);
      model.dispose();
    },
  );
  test('rejected Google account leaves the login usable', () async {
    final repository = FakeRepository()..rejectGoogle = true;
    final model = CommunityViewModel(
      repository,
      googleIdentity: FakeGoogleIdentity('firebase-test-id'),
    );
    await model.loginGoogle();
    expect(model.session, isNull);
    expect(model.error, isNotNull);
    expect(model.busy, isFalse);
    model.dispose();
  });

  test('birthday wraps year and preserves today', () {
    expect(
      nextBirthday(DateTime(1990, 1, 2), DateTime(2026, 12, 31)),
      DateTime(2027, 1, 2),
    );
    expect(
      nextBirthday(DateTime(1990, 10, 22), DateTime(2026, 10, 22, 23)),
      DateTime(2026, 10, 22),
    );
  });
  test('Feb 29 observed on Feb 28 without March rollover', () {
    expect(
      nextBirthday(DateTime(2000, 2, 29), DateTime(2027, 1)),
      DateTime(2027, 2, 28),
    );
    expect(
      nextBirthday(DateTime(2000, 2, 29), DateTime(2028, 1)),
      DateTime(2028, 2, 29),
    );
  });
  test('unmarked people are not silently absent and cannot save', () async {
    final repo = FakeRepository();
    final vm = CommunityViewModel(repo);
    await vm.restore();
    expect(vm.marked('a'), isNull);
    vm.mark('a', true);
    expect(vm.canSave, isFalse);
    await vm.save();
    expect(repo.writes, 0);
    vm.dispose();
  });
  test('remaining absent is explicit and completed attendance saves', () async {
    final repo = FakeRepository();
    final vm = CommunityViewModel(repo);
    await vm.restore();
    vm.mark('a', true);
    vm.markRemainingAbsent();
    expect(vm.marked('a'), isTrue);
    expect(vm.marked('b'), isFalse);
    expect(vm.canSave, isTrue);
    await vm.save();
    expect(vm.dirty, isFalse);
    expect(repo.records.length, 3);
    expect(vm.notice, isNotNull);
    vm.dispose();
  });
  test('save failure preserves draft for retry', () async {
    final repo = FakeRepository()..failSave = true;
    final vm = CommunityViewModel(repo);
    await vm.restore();
    vm.mark('a', true);
    vm.markRemainingAbsent();
    await vm.save();
    expect(vm.dirty, isTrue);
    expect(vm.marked('a'), isTrue);
    expect(vm.error, isNotNull);
    repo.failSave = false;
    await vm.save();
    expect(vm.dirty, isFalse);
    vm.dispose();
  });
  test('read-only permission prevents changes and writes', () async {
    final repo = FakeRepository()..permissions = {};
    final vm = CommunityViewModel(repo);
    await vm.restore();
    vm.mark('a', true);
    vm.markRemainingAbsent();
    await vm.save();
    expect(vm.markedCount, 0);
    expect(repo.writes, 0);
    vm.dispose();
  });
  test('restore loads saved records and logout clears private data', () async {
    final repo = FakeRepository()..records['a'] = true;
    final vm = CommunityViewModel(repo);
    await vm.restore();
    expect(vm.marked('a'), isTrue);
    expect(vm.dirty, isFalse);
    await vm.logout();
    expect(vm.session, isNull);
    expect(vm.members, isEmpty);
    expect(vm.markedCount, 0);
    vm.dispose();
  });
}
