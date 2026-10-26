import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheeplink/ui/core/widgets/report_content.dart';
import 'package:sheeplink/ui/core/widgets/photo_policy.dart';
import 'fake_repository.dart';

void main() {
  testWidgets(
    'photo policy can be declined and consent is remembered per user',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({});
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await acceptPhotoPolicy(context, 'demo');
              },
              child: const Text('Foto'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Foto'));
      await tester.pumpAndSettle();
      expect(find.text('Fotos que cuidan de todos'), findsOneWidget);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
      await tester.tap(find.text('Foto'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceptar y continuar'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
      await tester.tap(find.text('Foto'));
      await tester.pumpAndSettle();
      expect(find.text('Fotos que cuidan de todos'), findsNothing);
    },
  );
  testWidgets(
    'content report validates description and sends to existing support',
    (tester) async {
      final repo = FakeRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    openContentReport(context, repo, 'cell/demo/week'),
                child: const Text('Reportar'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Reportar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enviar reporte'));
      await tester.pumpAndSettle();
      expect(repo.report, isNull);
      await tester.enterText(
        find.byType(TextField),
        'Una foto inapropiada en esta reunión.',
      );
      await tester.tap(find.text('Enviar reporte'));
      await tester.pumpAndSettle();
      expect(repo.report, contains('cell/demo/week'));
      expect(
        find.text('Reporte enviado. El equipo de SheepLink lo revisará.'),
        findsOneWidget,
      );
    },
  );
}
