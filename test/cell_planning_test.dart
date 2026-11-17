import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sheeplink/data/repositories/community_repository.dart';
import 'package:sheeplink/data/services/api_client.dart';
import 'package:sheeplink/domain/models/community.dart';
import 'package:sheeplink/domain/models/weekly_meeting.dart';
import 'package:sheeplink/ui/core/theme/app_theme.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'package:sheeplink/ui/features/community/views/cell_planner.dart';
import 'app_test.dart' show capture;

class PlannerApi {
  final plans = <String, Map<String, dynamic>>{};
  final attendanceWrites = <String>[];
  String? recordedDate;
  bool failLoad = false;
  late final ApiClient client = ApiClient()
    ..dio.interceptors.clear()
    ..dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          final date = request.queryParameters['date'] as String?;
          dynamic data = <String, dynamic>{};
          if (request.path.startsWith('/care/cells/')) {
            if (failLoad) {
              handler.reject(
                DioException(
                  requestOptions: request,
                  type: DioExceptionType.connectionError,
                ),
              );
              return;
            }
            if (request.method == 'PUT') {
              final body = Map<String, dynamic>.from(request.data);
              plans[body['date']] = {
                ...body,
                'version': (body['version'] as int) + 1,
              };
            } else {
              data = {
                'plan': plans[date],
                'members': [
                  {'_id': 'ana', 'name': 'Ana'},
                ],
              };
            }
          } else if (request.path.contains('/meetings/')) {
            final week = request.path.split('/').last;
            data = {
              'weekStart': week,
              'date':
                  recordedDate != null &&
                      startOfWeek(DateTime.parse(recordedDate!)) ==
                          DateTime.parse(week)
                  ? recordedDate
                  : null,
            };
          } else if (request.path == '/members') {
            data = [
              {'_id': 'ana', 'name': 'Ana'},
            ];
          } else if (request.path == '/attendances') {
            if (request.method == 'POST') {
              attendanceWrites.add(request.data['date']);
            }
            data = [];
          }
          handler.resolve(Response(requestOptions: request, data: data));
        },
      ),
    );

  CommunityViewModel model() =>
      CommunityViewModel(ApiCommunityRepository(client))
        ..session = const Session(
          id: 'leader',
          name: 'Líder',
          email: 'leader@example.test',
          churchName: 'Prueba',
          permissions: {
            'planner.write',
            'cells.read',
            'members.read',
            'attendance.write',
          },
        )
        ..cell = const Cell(
          id: 'cell',
          name: 'Célula Los Olivos',
          timezone: 'America/Lima',
          meetingDay: 'Saturday',
        )
        ..date = DateTime(2026, 11, 10);
}

Future<void> mount(
  WidgetTester tester,
  CommunityViewModel model, {
  GlobalKey? captureKey,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Scaffold(
        body: RepaintBoundary(
          key: captureKey,
          child: ColoredBox(
            color: AppTheme.paper,
            child: AnimatedBuilder(
              animation: model,
              builder: (context, _) => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: CellWorkspace(model: model),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> press(WidgetTester tester, String text) async {
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text(text));
  await tester.pumpAndSettle();
  expect(find.text(text).hitTestable(), findsOneWidget);
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es');
    await (FontLoader(
      'Figtree',
    )..addFont(rootBundle.load('assets/fonts/Figtree.ttf'))).load();
  });

  test('future weeks retain their habitual date across the year', () {
    expect(
      meetingDateForWeek(
        DateTime(2026, 11, 16),
        'Saturday',
        DateTime(2026, 11, 16),
        allowFuture: true,
      ),
      DateTime(2026, 11, 21),
    );
    expect(
      meetingDateForWeek(
        DateTime(2027, 1, 4),
        'Saturday',
        DateTime(2026, 12, 31),
      ),
      DateTime(2027, 1, 9),
    );
    expect(
      nextMeetingDate(
        DateTime(2026, 11, 10),
        'Saturday',
        DateTime(2026, 11, 10),
      ),
      DateTime(2026, 11, 14),
    );
    expect(
      nextMeetingDate(
        DateTime(2026, 11, 14),
        'Saturday',
        DateTime(2026, 11, 14),
      ),
      DateTime(2026, 11, 21),
    );
  });

  testWidgets(
    'leader prepares a future plan, saves it and reloads it without creating attendance',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = PlannerApi();
      final model = api.model();
      final key = GlobalKey();
      await mount(tester, model, captureKey: key);
      expect(find.text('Planificador').hitTestable(), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Planificador')).dy,
        lessThan(tester.getTopLeft(find.text('Mi célula')).dy),
      );
      await press(tester, 'Preparar próxima célula');
      expect(model.isFutureMeeting, isTrue);
      final day = model.day;
      expect(find.byKey(const ValueKey('meeting-title')), findsOneWidget);
      await tester.ensureVisible(find.byKey(const ValueKey('meeting-title')));
      await tester.enterText(
        find.byKey(const ValueKey('meeting-title')),
        'Una nueva reunión',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(model.plannerDirty, isTrue);
      await press(tester, 'Asistencia');
      expect(
        find.textContaining('La reunión está por realizarse'),
        findsOneWidget,
      );
      await press(tester, 'Planificador');
      expect(find.text('Una nueva reunión'), findsOneWidget);
      await press(tester, 'Guardar plan');
      expect(api.plans[day]?['title'], 'Una nueva reunión');
      expect(model.plannerDirty, isFalse);
      expect(api.attendanceWrites, isEmpty);
      await press(tester, 'Siguiente');
      expect(model.day, isNot(day));
      await press(tester, 'Anterior');
      expect(model.day, day);
      expect(find.text('Una nueva reunión'), findsOneWidget);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, 3000),
      );
      await tester.pumpAndSettle();
      await capture(tester, key, 'restored-planner-390', pixelRatio: 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );

  testWidgets(
    'date selection is available after attendance was recorded and next week is reachable',
    (tester) async {
      final api = PlannerApi()..recordedDate = '2026-11-10';
      final model = api.model();
      await tester.runAsync(() => model.refresh());
      await mount(tester, model);
      await tester.tap(find.textContaining('Elegir fecha'));
      await tester.pumpAndSettle();
      final calendar = tester.widget<CalendarDatePicker>(
        find.byType(CalendarDatePicker),
      );
      expect(calendar.lastDate.isAfter(DateTime.now()), isTrue);
      // Select a different week directly through the calendar's selection callback.
      calendar.onDateChanged(DateTime(2026, 11, 21));
      await tester.pump();
      await tester.tap(
        find.text(
          MaterialLocalizations.of(
            tester.element(find.byType(CalendarDatePicker)),
          ).okButtonLabel,
        ),
      );
      await tester.pumpAndSettle();
      expect(model.day, '2026-11-21');
      await press(tester, 'Siguiente');
      expect(model.day, '2026-11-28');
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );

  testWidgets(
    'changing date protects the unsaved plan and cancellation retains it',
    (tester) async {
      final model = PlannerApi().model();
      await mount(tester, model);
      await press(tester, 'Planificador');
      await tester.enterText(
        find.byKey(const ValueKey('meeting-title')),
        'Borrador protegido',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await press(tester, 'Siguiente');
      expect(find.text('Tienes cambios sin guardar'), findsOneWidget);
      await press(tester, 'Seguir editando');
      expect(model.day, '2026-11-10');
      expect(find.text('Borrador protegido'), findsOneWidget);
      await press(tester, 'Siguiente');
      await press(tester, 'Descartar cambios');
      expect(model.day, '2026-11-21');
      expect(model.plannerDirty, isFalse);
      expect(find.text('Borrador protegido'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );

  testWidgets(
    'failed plan load offers retry without an empty destructive save',
    (tester) async {
      final api = PlannerApi()..failLoad = true;
      final model = api.model();
      await mount(tester, model);
      await press(tester, 'Planificador');
      expect(find.text('Guardar plan'), findsNothing);
      expect(find.text('Reintentar plan'), findsOneWidget);
      api.failLoad = false;
      await press(tester, 'Reintentar plan');
      expect(find.text('Guardar plan'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );

  testWidgets('failed save preserves the plan draft for retry', (tester) async {
    final api = PlannerApi();
    final model = api.model();
    await mount(tester, model);
    await press(tester, 'Planificador');
    await tester.enterText(
      find.byKey(const ValueKey('meeting-title')),
      'Conservar mi preparación',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    api.failLoad = true;
    await press(tester, 'Guardar plan');
    await tester.runAsync(() async {
      for (var attempt = 0; model.plannerBusy && attempt < 50; attempt++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();
    expect(model.plannerBusy, isFalse);
    expect(api.plans, isEmpty);
    expect(model.plannerDirty, isTrue);
    expect(find.text('Conservar mi preparación'), findsOneWidget);
    api.failLoad = false;
    await press(tester, 'Guardar plan');
    expect(model.plannerDirty, isFalse);
    expect(api.plans[model.day]?['title'], 'Conservar mi preparación');
    await tester.pumpWidget(const SizedBox());
    model.dispose();
  });

  test(
    'future meeting cannot submit attendance or create attendance drafts',
    () async {
      final api = PlannerApi();
      final model = api.model()
        ..date = DateTime.now().add(const Duration(days: 30))
        ..members = [const Member(id: 'ana', name: 'Ana')];
      model.mark('ana', true);
      model.markRemainingAbsent();
      await model.save();
      expect(model.markedCount, 0);
      expect(model.canSave, isFalse);
      expect(api.attendanceWrites, isEmpty);
      model.dispose();
    },
  );

  for (final size in [
    const Size(320, 640),
    const Size(844, 390),
    const Size(1024, 768),
  ]) {
    testWidgets('meeting controls fit $size with large text', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final model = PlannerApi().model();
      final key = GlobalKey();
      await mount(tester, model, captureKey: key);
      expect(find.text('Planificador').hitTestable(), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Planificador')).dy,
        lessThan(tester.getTopLeft(find.text('Mi célula')).dy),
      );
      await press(tester, 'Preparar próxima célula');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, 3000),
      );
      await tester.pumpAndSettle();
      await capture(
        tester,
        key,
        'restored-planner-${size.width.toInt()}',
        pixelRatio: 1,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    });
  }
}
