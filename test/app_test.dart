import 'package:sheeplink/domain/models/personal_profile.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:sheeplink/app/sheeplink_app.dart';
import 'package:sheeplink/data/services/notification_service.dart';
import 'package:sheeplink/domain/models/community.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'fake_repository.dart';
import 'community_test.dart' show FakeGoogleIdentity;

class TestNotifications extends NotificationService {
  TestNotifications(super.repository);
  bool offer = false;
  bool failDisable = false;
  @override
  Future<void> disable() async {
    if (failDisable) throw StateError("offline");
  }

  int prompts = 0;
  @override
  Future<void> synchronize(
    List<Member> members,
    String timezone, {
    List<ServiceAssignment> assignments = const [],
  }) async {}
  @override
  Future<bool> shouldOffer() async => offer;
  @override
  Future<void> markPromptSeen() async {
    prompts++;
    offer = false;
  }
}

Future<void> capture(WidgetTester tester, GlobalKey key, String name) async {
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('artifacts/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(png!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    await initializeDateFormatting('es');
    final font = FontLoader('Figtree')
      ..addFont(rootBundle.load('assets/fonts/Figtree.ttf'));
    await font.load();
  });
  testWidgets(
    'notification invitation can be deferred and does not nag on refresh',
    (tester) async {
      final repo = FakeRepository();
      final model = CommunityViewModel(repo);
      await model.restore();
      final notifications = TestNotifications(repo)..offer = true;
      await tester.pumpWidget(
        SheeplinkApp(model: model, notifications: notifications),
      );
      await tester.pumpAndSettle();
      expect(find.text('Mantente cerca de tu comunidad'), findsOneWidget);
      await tester.tap(find.text('Ahora no'));
      await tester.pumpAndSettle();
      await model.refresh();
      await tester.pumpAndSettle();
      expect(find.text('Mantente cerca de tu comunidad'), findsNothing);
      expect(notifications.prompts, 1);
      await tester.pumpWidget(const SizedBox());
      notifications.dispose();
      model.dispose();
    },
  );
  testWidgets('logout succeeds when notification cleanup fails', (
    tester,
  ) async {
    final repo = FakeRepository();
    final model = CommunityViewModel(repo);
    await model.restore();
    final notifications = TestNotifications(repo)..failDisable = true;
    await tester.pumpWidget(
      SheeplinkApp(model: model, notifications: notifications),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(model.session, isNull);
    expect(find.text('Continuar con Google'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    notifications.dispose();
    model.dispose();
  });
  testWidgets('Google login button opens community without email validation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = FakeRepository();
    final model = CommunityViewModel(
      repository,
      googleIdentity: FakeGoogleIdentity('firebase-test-id'),
    )..restoring = false;
    final notifications = TestNotifications(repository);
    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: SheeplinkApp(model: model, notifications: notifications),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Continuar con Google'), findsOneWidget);
    await capture(tester, key, 'login-google-mobile');
    await tester.tap(find.text('Continuar con Google'));
    await tester.pumpAndSettle();
    expect(repository.googleToken, 'firebase-test-id');
    expect(find.text('Mi célula'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    notifications.dispose();
    model.dispose();
  });
  testWidgets('simple navigation, attendance and profile-only logout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repo = FakeRepository(), key = GlobalKey();
    final model = CommunityViewModel(repo);
    await model.restore();
    final notifications = TestNotifications(repo);
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: SheeplinkApp(model: model, notifications: notifications),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Cerrar sesión'), findsNothing);
    await capture(tester, key, 'today-mobile');
    await tester.tap(find.text('Mi célula'));
    await tester.pumpAndSettle();
    expect(find.text('Guardar reunión'), findsOneWidget);
    await tester.tap(find.text('Presente').first);
    await tester.pump();
    await tester.ensureVisible(find.text('Marcar pendientes como ausentes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marcar pendientes como ausentes'));
    await tester.pump();
    await tester.ensureVisible(find.text('Guardar reunión'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar reunión'));
    await tester.pumpAndSettle();
    expect(repo.records.length, 3);
    expect(tester.takeException(), isNull);
    await capture(tester, key, 'attendance-mobile');
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Cerrar sesión'), findsOneWidget);
    await capture(tester, key, 'profile-mobile');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    notifications.dispose();
    model.dispose();
  });
  testWidgets('small phone and large text do not overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repo = FakeRepository();
    final model = CommunityViewModel(repo);
    await model.restore();
    final n = TestNotifications(repo);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
        child: SheeplinkApp(model: model, notifications: n),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Mi célula'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    n.dispose();
    model.dispose();
  });
}
