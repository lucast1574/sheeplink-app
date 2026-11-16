import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheeplink/app/sheeplink_app.dart';
import 'package:sheeplink/data/services/notification_service.dart';
import 'package:sheeplink/l10n/locale.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'fake_repository.dart';
import 'app_test.dart' show TestNotifications;

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    await (FontLoader(
      'Figtree',
    )..addFont(rootBundle.load('assets/fonts/Figtree.ttf'))).load();
  });
  test('ordered device languages, regional variants and Spanish fallback', () {
    expect(
      resolveLocale([const Locale('fr'), const Locale('pt', 'PT')]),
      const Locale('pt'),
    );
    expect(
      resolveLocale([const Locale('en', 'GB'), const Locale('es')]),
      const Locale('en'),
    );
    expect(resolveLocale([const Locale('de')]), const Locale('es'));
    expect(resolveLocale(null), const Locale('es'));
  });

  for (final entry in {
    'es': 'Correo electrónico',
    'en': 'Email address',
    'pt': 'E-mail',
    'fr': 'Correo electrónico',
  }.entries) {
    testWidgets(
      'automatic ${entry.key} login has no selector or text overflow',
      (tester) async {
        tester.binding.platformDispatcher.localesTestValue = [
          Locale(entry.key),
        ];
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = FakeRepository();
        final model = CommunityViewModel(repository)..restoring = false;
        final notifications = NotificationService(repository);
        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: SheeplinkApp(model: model, notifications: notifications),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(entry.value), findsOneWidget);
        expect(
          Localizations.localeOf(tester.element(find.byType(Scaffold))),
          resolveLocale([Locale(entry.key)]),
        );
        expect(find.byType(DropdownButton), findsNothing);
        expect(tester.takeException(), isNull);
        expect(
          tr('Guardar'),
          {
            'es': 'Guardar',
            'en': 'Save',
            'pt': 'Salvar',
            'fr': 'Guardar',
          }[entry.key],
        );
        if (entry.key != 'fr') {
          await tester.runAsync(() async {
            final boundary =
                key.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            final image = await boundary.toImage();
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            final file = File('artifacts/i18n/login-${entry.key}.png');
            await file.parent.create(recursive: true);
            await file.writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
        await tester.pumpWidget(const SizedBox());
        notifications.dispose();
        model.dispose();
      },
    );
  }
  for (final language in ['es', 'en', 'pt']) {
    testWidgets('$language community and profile fit a small phone', (
      tester,
    ) async {
      tester.binding.platformDispatcher.localesTestValue = [Locale(language)];
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = FakeRepository();
      final model = CommunityViewModel(repository);
      await model.restore();
      final notifications = TestNotifications(repository);
      await tester.pumpWidget(
        SheeplinkApp(model: model, notifications: notifications),
      );
      await tester.pumpAndSettle();
      expect(find.text(tr('Hoy')), findsWidgets);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(tr('Perfil')));
      await tester.pumpAndSettle();
      expect(find.text(tr('Cerrar sesión')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      notifications.dispose();
      model.dispose();
    });
  }
}
