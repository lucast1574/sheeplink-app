import 'package:sheeplink/ui/core/widgets/person_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sheeplink/data/repositories/community_repository.dart';
import 'package:sheeplink/data/services/api_client.dart';
import 'package:sheeplink/domain/models/community.dart';
import 'package:sheeplink/ui/core/theme/app_theme.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'package:sheeplink/ui/features/community/views/cell_planner.dart';
import 'package:sheeplink/ui/features/community/views/daily_journal.dart';
import 'package:sheeplink/app/sheeplink_app.dart';
import 'package:sheeplink/ui/features/community/views/course_cover.dart';
import 'package:sheeplink/ui/features/community/views/attendance_person_card.dart';
import 'app_test.dart' show capture, TestNotifications;

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    await initializeDateFormatting('es');
    await (FontLoader(
      'Figtree',
    )..addFont(rootBundle.load('assets/fonts/Figtree.ttf'))).load();
  });
  testWidgets(
    'planner title remains editable, saves and does not overlap date',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Map<String, dynamic>? saved;
      final client = ApiClient();
      client.dio.interceptors.clear();
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            if (request.method == 'PUT') {
              saved = Map<String, dynamic>.from(request.data);
            }
            handler.resolve(
              Response(
                requestOptions: request,
                data: {
                  'plannerSettings': {
                    'activities': [
                      for (final name in [
                        'Bienvenida',
                        'Alabanza',
                        'Palabra',
                        'Oración',
                      ])
                        {'key': name, 'title': name, 'minutes': 10},
                    ],
                    'options': [
                      for (final name in [
                        'Bienvenida',
                        'Alabanza',
                        'Palabra',
                        'Oración',
                        'Rompehielo',
                        'Dinámica 1',
                        'Dinámica 2',
                      ])
                        {'key': name, 'title': name, 'minutes': 10},
                    ],
                    'version': 0,
                  },
                  'members': [
                    {'name': 'Ana · Prueba', '_id': 'member'},
                  ],
                  'plan': {
                    'title': saved?['title'] ?? 'Un encuentro para compartir',
                    'version': 2,
                    'items': [
                      for (final name in [
                        'Bienvenida',
                        'Alabanza',
                        'Palabra',
                        'Oración',
                      ])
                        {'key': name, 'title': name, 'minutes': 10},
                    ],
                  },
                },
              ),
            );
          },
        ),
      );
      final model = CommunityViewModel(ApiCommunityRepository(client))
        ..session = const Session(
          id: 'user',
          name: 'Lucas',
          email: 'test@example.test',
          churchName: 'Prueba',
          permissions: {'planner.write'},
        )
        ..cell = const Cell(
          id: 'cell',
          name: 'Célula de pruebas',
          timezone: 'America/Lima',
        )
        ..date = DateTime(2026, 11, 10);
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: RepaintBoundary(
              key: key,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: CellPlanner(model: model),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final input = find.byType(TextField);
      final assignments = find.byType(PersonPicker);
      expect(
        tester.getTopLeft(find.text('Guardar plan')).dy -
            tester.getBottomLeft(assignments.last).dy,
        greaterThanOrEqualTo(32),
      );
      expect(tester.widget<TextField>(input).readOnly, isFalse);
      expect(
        tester.getBottomLeft(find.textContaining('martes')).dy + 16,
        lessThan(tester.getTopLeft(input).dy),
      );
      await tester.enterText(input, 'La esperanza de esta semana');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.tap(find.text('Elegir actividades de esta reunión'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(CheckboxListTile, 'Alabanza'));
      await tester.tap(find.widgetWithText(CheckboxListTile, 'Rompehielo'));
      await tester.tap(find.text('Aplicar selección'));
      await tester.pumpAndSettle();
      await tester.tap(assignments.first);
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);
      await tester.tap(find.text('Ana · Prueba'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      await tester.ensureVisible(find.text('Guardar plan'));
      await tester.tap(find.text('Guardar plan'));
      await tester.pumpAndSettle();
      expect(saved?['title'], 'La esperanza de esta semana');
      expect(saved?['version'], 2);
      expect((saved?['items'] as List).first['memberId'], 'member');
      expect(
        (saved?['items'] as List).firstWhere(
          (x) => x['title'] == 'Alabanza',
        )['enabled'],
        false,
      );
      expect(
        (saved?['items'] as List).firstWhere(
          (x) => x['title'] == 'Rompehielo',
        )['enabled'],
        true,
      );
      expect(tester.takeException(), isNull);
      await capture(tester, key, 'qa-planner-fixed', pixelRatio: 1);
    },
  );

  testWidgets(
    'teacher sees course covers, shared attendance cards and profile last',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Map<String, dynamic>? saved;
      final client = ApiClient();
      client.dio.interceptors.clear();
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            dynamic data = <String, dynamic>{};
            if (request.path == '/academy/courses') {
              data = [
                for (final name in ['Fundamentos', 'Vida cristiana'])
                  {
                    '_id': name,
                    'name': name,
                    'leaderId': 'teacher',
                    'status': 'ACTIVE',
                    'studentsCount': 1,
                  },
              ];
            }
            if (request.path.endsWith('/students')) {
              data = [
                {'memberId': 'ana', 'memberName': 'Ana'},
              ];
            }
            if (request.path.endsWith('/attendance')) {
              data = <dynamic>[];
              if (request.method == 'POST') {
                saved = Map<String, dynamic>.from(request.data);
              }
            }
            handler.resolve(Response(requestOptions: request, data: data));
          },
        ),
      );
      final repo = ApiCommunityRepository(client);
      final model = CommunityViewModel(repo)
        ..restoring = false
        ..session = const Session(
          id: 'teacher',
          name: 'Maestro',
          email: 'teacher@example.test',
          churchName: 'Prueba',
          permissions: {'academy.teach'},
        );
      final notices = TestNotifications(repo);
      final courseCapture = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: courseCapture,
          child: SheeplinkApp(model: model, notifications: notices),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<NavigationDestination>(
              find.byType(NavigationDestination),
            )
            .map((x) => x.label)
            .last,
        'Perfil',
      );
      await tester.tap(find.text('Asistencia'));
      await tester.pumpAndSettle();
      expect(find.byType(CourseCover), findsNWidgets(2));
      await capture(tester, courseCapture, 'qa-course-tiles', pixelRatio: 1);
      await tester.tap(find.text('Fundamentos'));
      await tester.pumpAndSettle();
      expect(find.byType(AttendancePersonCard), findsOneWidget);
      await tester.tap(find.text('Presente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar asistencia'));
      await tester.pumpAndSettle();
      expect((saved?['records'] as List).first['present'], true);
      await capture(
        tester,
        courseCapture,
        'qa-course-attendance',
        pixelRatio: 1,
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(CourseCover), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      notices.dispose();
      model.dispose();
    },
  );

  testWidgets('journal uses fixed labels and a quiet save action', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final client = ApiClient();
    client.dio.interceptors.clear();
    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) => handler.resolve(
          Response(
            requestOptions: request,
            data: request.path == '/personal'
                ? {
                    'member': {'_id': 'member'},
                  }
                : {'entry': {}},
          ),
        ),
      ),
    );
    final model = CommunityViewModel(ApiCommunityRepository(client));
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: RepaintBoundary(
            key: key,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: DailyJournal(model: model),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FilledButton), findsNothing);
    expect(find.text('Lectura bíblica'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Salmo 23');
    await tester.enterText(
      find.byType(TextField).last,
      'Una reflexión para hoy.',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await capture(tester, key, 'qa-journal-fixed', pixelRatio: 1);
  });
}
