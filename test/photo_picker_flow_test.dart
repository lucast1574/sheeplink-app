import 'dart:async';
import 'dart:io';
import 'package:sheeplink/l10n/locale.dart';
import 'package:sheeplink/data/services/photo_service.dart';
import 'package:sheeplink/ui/features/community/views/cell_disclosure.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:sheeplink/ui/features/community/views/weekly_photo.dart';
import 'app_test.dart' show capture;
import 'cell_workspace_test.dart' show readyModel, mountShell, tapText;

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    await initializeDateFormatting('es');
    await (FontLoader(
      'Figtree',
    )..addFont(rootBundle.load('assets/fonts/Figtree.ttf'))).load();
  });
  test(
    'invalid image processing remains independent from Flutter bindings in worker',
    () async {
      await expectLater(
        compute(preparePhoto, Uint8List.fromList([1, 2, 3])),
        throwsA(
          isA<PhotoException>().having(
            (e) => e.failure,
            'failure',
            PhotoFailure.invalidImage,
          ),
        ),
      );
    },
  );
  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    testWidgets(
      'first photo policy opens correctly on $platform before native picker',
      (tester) async {
        tester.platformDispatcher.localesTestValue = const [Locale('en')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);
        FlutterSecureStorage.setMockInitialValues({});
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const channel = MethodChannel('plugins.flutter.io/image_picker');
        var opened = 0;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          (call) async {
            if (call.method == 'pickImage') opened++;
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            channel,
            null,
          ),
        );
        final model = await readyModel(tester);
        await mountShell(tester, model);
        await tapText(tester, tr('Elegir de galería'));
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(ErrorWidget), findsNothing);
        expect(opened, 0);
        expect(model.pickingPhoto, true);
        final revision = model.meetingRevision;
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pumpAndSettle();
        expect(model.busy, false);
        expect(model.meetingRevision, revision);
        expect(find.byType(ErrorWidget), findsNothing);
        await tester.tap(find.text(tr('Cancelar')));
        await tester.pumpAndSettle();
        expect(model.pickingPhoto, false);
        await tapText(tester, tr('Tomar foto'));
        await tester.tap(find.text(tr('Aceptar y continuar')));
        await tester.pumpAndSettle();
        expect(opened, 1);
        expect(model.pickingPhoto, false);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        model.dispose();
      },
      variant: TargetPlatformVariant({platform}),
    );
  }
  testWidgets(
    'unresponsive native picker releases the UI and ignores late response',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({
        'sheeplink.photo-policy.2026-10-22.leader': 'true',
      });
      final response = Completer<String?>();
      const channel = MethodChannel('plugins.flutter.io/image_picker');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (call) async => call.method == 'pickImage' ? response.future : null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      final model = await readyModel(tester);
      await mountShell(tester, model);
      await tapText(tester, 'Elegir de galería');
      expect(model.pickingPhoto, true);
      await tester.pump(
        PhotoService.pickerTimeout + const Duration(seconds: 1),
      );
      await tester.pumpAndSettle();
      expect(model.pickingPhoto, false);
      expect(
        find.text(
          'El selector de fotos no respondió. Ciérralo y vuelve a intentarlo.',
        ),
        findsOneWidget,
      );
      response.complete(null);
      await tester.pumpAndSettle();
      expect(model.pendingPhoto, null);
      expect(find.byType(ErrorWidget), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );
  for (final action in ['Tomar foto', 'Elegir de galería']) {
    for (final result in ['cancel', 'photo', 'denied']) {
      testWidgets(
        '$action returns from native picker with $result without breaking cell pane',
        (tester) async {
          FlutterSecureStorage.setMockInitialValues({
            'sheeplink.photo-policy.2026-10-22.leader': 'true',
          });
          tester.view.physicalSize = const Size(390, 844);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final response = Completer<String?>();
          var opened = 0;
          const channel = MethodChannel('plugins.flutter.io/image_picker');
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            channel,
            (call) async {
              if (call.method == 'retrieve') return null;
              if (call.method == 'pickImage') {
                opened++;
                return response.future;
              }
              throw StateError(call.method);
            },
          );
          addTearDown(
            () => tester.binding.defaultBinaryMessenger
                .setMockMethodCallHandler(channel, null),
          );
          final model = await readyModel(tester);
          final captureKey = await mountShell(tester, model);
          await tester.ensureVisible(find.text(action));
          await tester.pumpAndSettle();
          await tester.tap(find.text(action));
          await tester.pumpAndSettle();
          expect(opened, 1);
          expect(model.pickingPhoto, true);
          tester.binding.handleAppLifecycleStateChanged(
            AppLifecycleState.inactive,
          );
          tester.binding.handleAppLifecycleStateChanged(
            AppLifecycleState.resumed,
          );
          await tester.pumpAndSettle();
          if (result == 'cancel') {
            response.complete(null);
          } else if (result == 'denied') {
            response.completeError(
              PlatformException(code: 'photo_access_denied'),
            );
          } else {
            final path = await tester.runAsync(() async {
              final dir = await Directory.systemTemp.createTemp(
                'sheeplink-photo-test-',
              );
              addTearDown(() => dir.delete(recursive: true));
              final f = File('${dir.path}/selected.jpg');
              await f.writeAsBytes(
                image.encodeJpg(image.Image(width: 320, height: 240)),
              );
              return f.path;
            });
            response.complete(path);
          }
          await tester.pump();
          for (var i = 0; i < 150 && model.pickingPhoto; i++) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 20)),
            );
            await tester.pump();
          }
          await tester.pumpAndSettle();
          expect(model.pickingPhoto, false);
          expect(find.byType(ErrorWidget), findsNothing);
          expect(find.byType(WeeklyPhoto), findsOneWidget);
          expect(
            find.ancestor(
              of: find.byType(WeeklyPhoto),
              matching: find.byType(CellDisclosure),
            ),
            findsNothing,
          );
          expect(
            tester.getCenter(find.text('Elegir de galería')).dx,
            greaterThan(tester.getCenter(find.text('Tomar foto')).dx),
          );
          expect(model.pendingPhoto != null, result == 'photo');
          if (result == 'cancel' && action == 'Elegir de galería') {
            await tester.ensureVisible(find.text('La foto de esta semana'));
            await tester.pumpAndSettle();
            await capture(
              tester,
              captureKey,
              'photo-picker-fixed',
              pixelRatio: 1,
            );
          }
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
          model.dispose();
        },
      );
    }
  }
}
