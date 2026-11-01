import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:sheeplink/app/sheeplink_app.dart';
import 'package:sheeplink/domain/models/personal_profile.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'fake_repository.dart';
import 'app_test.dart' show TestNotifications, capture;

void main() {
  testWidgets('capture store listing with fictional community data', (
    tester,
  ) async {
    tz.initializeTimeZones();
    await initializeDateFormatting('es');
    final font = FontLoader('Figtree')
      ..addFont(rootBundle.load('assets/fonts/Figtree.ttf'));
    await font.load();
    const iosStore = bool.fromEnvironment('STORE_IOS');
    final prefix = iosStore ? 'ios' : 'play';
    final ratio = iosStore ? 3.0 : 2.0;
    tester.view.physicalSize = iosStore
        ? const Size(1290, 2796)
        : const Size(1080, 1920);
    tester.view.devicePixelRatio = ratio;
    if (iosStore) {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final next = DateTime.now().add(const Duration(days: 1));
    final repo = FakeRepository()
      ..profile = PersonalProfile(
        phone: '+51 999 000 000',
        roles: ['Líder de célula'],
        ministries: ['Alabanza'],
        assignments: [
          ServiceAssignment(
            id: 'demo',
            date: DateFormat('yyyy-MM-dd').format(next),
            time: '10:00',
            ministry: 'Alabanza',
            role: 'Voz',
            confirmation: 'CONFIRMED',
            blocked: false,
          ),
        ],
      );
    final vm = CommunityViewModel(repo);
    await vm.restore();
    final notifications = TestNotifications(repo), key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: SheeplinkApp(model: vm, notifications: notifications),
      ),
    );
    await tester.pumpAndSettle();
    await capture(
      tester,
      key,
      '$prefix-01-hoy',
      pixelRatio: ratio,
      jpeg: iosStore,
    );
    await tester.tap(find.text('Mi célula'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Presente').first);
    await tester.pump();
    await capture(
      tester,
      key,
      '$prefix-02-asistencia',
      pixelRatio: ratio,
      jpeg: iosStore,
    );
    await tester.ensureVisible(find.text('La foto de esta semana'));
    await tester.pumpAndSettle();
    await capture(
      tester,
      key,
      '$prefix-03-semana',
      pixelRatio: ratio,
      jpeg: iosStore,
    );
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await capture(
      tester,
      key,
      '$prefix-04-perfil',
      pixelRatio: ratio,
      jpeg: iosStore,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    notifications.dispose();
    vm.dispose();
    debugDefaultTargetPlatformOverride = null;
  });
}
