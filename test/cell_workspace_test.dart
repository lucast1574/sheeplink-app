import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sheeplink/domain/models/community.dart';
import 'package:sheeplink/ui/core/theme/app_theme.dart';
import 'package:sheeplink/ui/core/widgets/person_picker.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'package:sheeplink/ui/features/community/views/community_shell.dart';
import 'package:sheeplink/ui/features/community/views/meeting_topic.dart';
import 'app_test.dart' show TestNotifications, capture;
import 'cell_planning_test.dart' show PlannerApi;

Future<GlobalKey> mountShell(
  WidgetTester tester,
  CommunityViewModel model,
) async {
  final key = GlobalKey();
  final notifications = TestNotifications(model.repository);
  addTearDown(notifications.dispose);
  await tester.pumpWidget(
    RepaintBoundary(
      key: key,
      child: MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        locale: const Locale('es'),
        supportedLocales: const [Locale('es'), Locale('en'), Locale('pt')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: ListenableBuilder(
          listenable: model,
          builder: (_, _) =>
              CommunityShell(model: model, notifications: notifications),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await mainTab(tester, 'Mi célula');
  return key;
}

Future<void> mainTab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String label) async {
  final sheet = find.byType(BottomSheet);
  final target = sheet.evaluate().isEmpty
      ? find.text(label)
      : find.descendant(of: sheet, matching: find.text(label));
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<CommunityViewModel> readyModel(WidgetTester tester) async {
  final model = PlannerApi().model();
  await tester.runAsync(() => model.refresh());
  final user = model.session!;
  model.session = Session(
    id: user.id,
    name: user.name,
    email: user.email,
    churchName: user.churchName,
    permissions: {...user.permissions, 'members.write'},
  );
  model.members = const [
    Member(id: 'ana', name: 'Ana de la Cruz'),
    Member(id: 'luis', name: 'Luis Mendoza'),
    Member(id: 'sofia', name: 'Sofía Pérez'),
  ];
  return model;
}

void main() {
  setUpAll(() async {
    tz.initializeTimeZones();
    await initializeDateFormatting('es');
    await (FontLoader(
      'Figtree',
    )..addFont(rootBundle.load('assets/fonts/Figtree.ttf'))).load();
  });
  testWidgets(
    'three task panes retain attendance, topic and planner drafts across main navigation',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final model = await readyModel(tester);
      final key = await mountShell(tester, model);
      await tester.tap(find.byTooltip('Presente').first);
      await tester.pumpAndSettle();
      expect(model.marked('ana'), true);
      await tester.tap(find.byTooltip('Presente').first);
      await tester.pumpAndSettle();
      expect(model.marked('ana'), null);
      await tester.tap(find.byTooltip('Presente').first);
      await tester.pumpAndSettle();
      model.mark('luis', false);
      model.mark('sofia', true);
      await tester.pumpAndSettle();
      await capture(tester, key, 'cell-ux-01-attendance', pixelRatio: 1);
      await tapText(tester, 'Tema y foto del encuentro');
      final topic = find.descendant(
        of: find.byType(MeetingTopic),
        matching: find.byType(TextField),
      );
      await tester.enterText(topic, 'Un tema por guardar');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(model.topicDirty, true);
      await tapText(tester, 'Planificador');
      final title = find.byKey(const ValueKey('meeting-title'));
      await tester.enterText(title, 'Una fe que se comparte');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tapText(tester, 'Bienvenida');
      await tester.ensureVisible(find.byType(PersonPicker).first);
      await tester.tap(find.byType(PersonPicker).first);
      await tester.pumpAndSettle();
      await tapText(tester, 'Ana de la Cruz');
      expect(
        tester.widget<PersonPicker>(find.byType(PersonPicker).first).value,
        'ana',
      );
      await tester.tap(find.byType(PersonPicker).first);
      await tester.pumpAndSettle();
      await tapText(tester, 'Sin asignar');
      expect(
        tester.widget<PersonPicker>(find.byType(PersonPicker).first).value,
        '',
      );
      await tapText(tester, 'Bienvenida');
      await tester.ensureVisible(
        find.byKey(const ValueKey('meeting-date-selector')),
      );
      await tester.pumpAndSettle();
      await capture(tester, key, 'cell-ux-02-planner', pixelRatio: 1);
      await tapText(tester, 'Integrantes');
      final search = find.byKey(const ValueKey('member-search'));
      await tester.enterText(search, 'sin coincidencias');
      await tester.pumpAndSettle();
      expect(
        find.text('No encontramos integrantes con ese nombre.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Limpiar búsqueda'));
      await tester.pumpAndSettle();
      expect(find.text('Sofía Pérez'), findsOneWidget);
      await capture(tester, key, 'cell-ux-03-members', pixelRatio: 1);
      await mainTab(tester, 'Hoy');
      await mainTab(tester, 'Mi célula');
      expect(find.text('Integrantes'), findsNWidgets(2));
      await tapText(tester, 'Planificador');
      expect(find.text('Una fe que se comparte'), findsOneWidget);
      expect(model.plannerDirty, true);
      await tapText(tester, 'Asistencia');
      expect(model.marked('ana'), true);
      expect(find.text('Un tema por guardar'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );
  testWidgets(
    'date draft cancellation is harmless and applying another week protects all unsaved work',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final model = await readyModel(tester);
      final key = await mountShell(tester, model);
      await tapText(tester, 'Planificador');
      await tester.enterText(
        find.byKey(const ValueKey('meeting-title')),
        'Conservar este plan',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      final day = model.day;
      await tester.tap(find.byKey(const ValueKey('meeting-date-selector')));
      await tester.pumpAndSettle();
      await tapText(tester, 'Siguiente');
      await capture(tester, key, 'cell-ux-04-dates', pixelRatio: 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(model.day, day);
      expect(find.text('Conservar este plan'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('meeting-date-selector')));
      await tester.pumpAndSettle();
      await tapText(tester, 'Siguiente');
      await tapText(tester, 'Aplicar selección');
      await tapText(tester, 'Seguir editando');
      expect(model.day, day);
      expect(model.plannerDirty, true);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );
  for (final size in [
    const Size(320, 640),
    const Size(844, 390),
    const Size(1024, 768),
  ]) {
    testWidgets('bounded cell panes fit $size with large text and keyboard', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final model = await readyModel(tester);
      final key = await mountShell(tester, model);
      await tester.ensureVisible(find.text('Guardar reunión'));
      await tester.pumpAndSettle();
      expect(find.text('Guardar reunión').hitTestable(), findsOneWidget);
      await tapText(tester, 'Planificador');
      await tester.ensureVisible(find.text('Guardar plan'));
      await tester.pumpAndSettle();
      expect(find.text('Guardar plan').hitTestable(), findsOneWidget);
      await tapText(tester, 'Integrantes');
      await tester.enterText(
        find.byKey(const ValueKey('member-search')),
        'Ana',
      );
      tester.view.viewInsets = FakeViewPadding(
        bottom: size.height > 400 ? 260 : 150,
      );
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      await capture(
        tester,
        key,
        'cell-ux-keyboard-${size.width.toInt()}',
        pixelRatio: 1,
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, false);
      await tester.tap(find.byTooltip('Limpiar búsqueda'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    });
  }
}
