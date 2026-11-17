import 'dart:async';
import 'package:sheeplink/domain/models/community.dart';
import 'package:sheeplink/ui/core/widgets/person_picker.dart';
import 'cell_planning_test.dart' as planner_fixture;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sheeplink/data/repositories/community_repository.dart';
import 'package:sheeplink/data/services/api_client.dart';
import 'package:sheeplink/domain/models/new_cell_member.dart';
import 'package:sheeplink/ui/core/theme/app_theme.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'package:sheeplink/ui/features/community/views/add_cell_member_page.dart';
import 'package:sheeplink/ui/features/community/views/cell_planner.dart';
import 'fake_repository.dart';
import 'app_test.dart' show capture;

Future<void> mountMemberFlow(
  WidgetTester tester,
  CommunityViewModel model, {
  GlobalKey? captureKey,
}) async {
  await tester.pumpWidget(
    RepaintBoundary(
      key: captureKey,
      child: MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('es'), Locale('en'), Locale('pt')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: Scaffold(
          body: ListenableBuilder(
            listenable: model,
            builder: (context, _) => SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: CellWorkspace(model: model),
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
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

class SlowMemberRepository extends FakeRepository {
  final release = Completer<void>();
  int started = 0;
  @override
  Future<Member> createMember(String cellId, NewCellMember member) async {
    started++;
    await release.future;
    return super.createMember(cellId, member);
  }
}

void main() {
  setUpAll(() async {
    for (final locale in ['es', 'en', 'pt_BR']) {
      await initializeDateFormatting(locale);
    }
    await (FontLoader(
      'Figtree',
    )..addFont(rootBundle.load('assets/fonts/Figtree.ttf'))).load();
  });

  test(
    'adding a roster record preserves meeting drafts and does not create a user',
    () async {
      final repository = FakeRepository()..permissions.add('members.write');
      final model = CommunityViewModel(repository);
      await model.restore();
      model.mark('a', true);
      model.setPlannerDirty(true);
      final oldDay = model.day, oldRevision = model.meetingRevision;
      final member = await model.addMember(
        const NewCellMember(name: '  Nuevo integrante  '),
      );
      expect(repository.createdCell, 'cell');
      expect(repository.createdDraft?.email, isEmpty);
      expect(repository.memberCreates, 1);
      expect(model.members.any((m) => m.id == member.id), isTrue);
      expect(model.marked('a'), isTrue);
      expect(model.marked(member.id), isNull);
      expect(model.plannerDirty, isTrue);
      expect(model.day, oldDay);
      expect(model.meetingRevision, oldRevision);
      expect(repository.writes, 0);
      model.dispose();
    },
  );

  test(
    'member management permission is enforced before sending requests',
    () async {
      final repository = FakeRepository();
      final model = CommunityViewModel(repository);
      await model.restore();
      expect(
        () => model.addMember(const NewCellMember(name: 'Persona')),
        throwsStateError,
      );
      expect(repository.memberCreates, 0);
      model.dispose();
    },
  );

  test(
    'member creation uses only the roster endpoint and omits blank optional data',
    () async {
      final client = ApiClient();
      client.dio.interceptors.clear();
      final requests = <RequestOptions>[];
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request);
            handler.resolve(
              Response(
                requestOptions: request,
                data: {
                  '_id': 'new',
                  'name': request.data['name'],
                  'birthday': request.data['birthday'],
                },
              ),
            );
          },
        ),
      );
      final repo = ApiCommunityRepository(client);
      await repo.createMember(
        'cell',
        const NewCellMember(name: ' Ana ', email: '  '),
      );
      expect(requests.single.method, 'POST');
      expect(requests.single.path, '/members');
      expect(requests.single.data, {'cellId': 'cell', 'name': 'Ana'});
      await repo.createMember(
        'cell',
        NewCellMember(
          name: 'Luis',
          email: ' luis@example.test ',
          age: 0,
          birthday: DateTime(2026, 1, 2),
        ),
      );
      expect(requests.last.data, {
        'cellId': 'cell',
        'name': 'Luis',
        'email': 'luis@example.test',
        'age': 0,
        'birthday': '2026-01-02',
      });
      expect(requests.every((r) => r.path == '/members'), isTrue);
    },
  );

  testWidgets('leader adds a member from My cell using a name only', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final repository = FakeRepository()..permissions.add('members.write');
    final model = CommunityViewModel(repository);
    await model.restore();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await mountMemberFlow(tester, model, captureKey: key);
    await press(tester, 'Añadir integrante');
    await capture(tester, key, 'add-member-es-390', pixelRatio: 1);
    expect(find.byType(AddCellMemberPage), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('new-member-name')),
      'Camila Nueva',
    );
    await press(tester, 'Guardar integrante');
    expect(find.byType(AddCellMemberPage), findsNothing);
    expect(find.text('Camila Nueva'), findsOneWidget);
    expect(repository.memberCreates, 1);
    expect(repository.createdDraft?.email, isEmpty);
    await tester.pumpWidget(const SizedBox());
    model.dispose();
  });

  testWidgets(
    'invalid data is shown inline and a failed save retains the form for retry',
    (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('es')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final repository = FakeRepository()
        ..permissions.add('members.write')
        ..failCreateMember = true;
      final model = CommunityViewModel(repository);
      await model.restore();
      await mountMemberFlow(tester, model);
      await press(tester, 'Añadir integrante');
      await press(tester, 'Guardar integrante');
      expect(find.text('Escribe el nombre del integrante.'), findsOneWidget);
      expect(repository.memberCreates, 0);
      await tester.enterText(
        find.byKey(const ValueKey('new-member-name')),
        'Camila Nueva',
      );
      await tester.enterText(
        find.byKey(const ValueKey('new-member-email')),
        'correo inválido',
      );
      await tester.enterText(
        find.byKey(const ValueKey('new-member-age')),
        '121',
      );
      await press(tester, 'Guardar integrante');
      expect(
        find.text('Introduce un correo válido o deja el campo vacío.'),
        findsOneWidget,
      );
      expect(
        find.text('La edad debe estar entre 0 y 120 años.'),
        findsOneWidget,
      );
      expect(repository.memberCreates, 0);
      await tester.enterText(
        find.byKey(const ValueKey('new-member-email')),
        '',
      );
      await tester.enterText(
        find.byKey(const ValueKey('new-member-age')),
        '21',
      );
      await press(tester, 'Guardar integrante');
      expect(repository.memberCreates, 1);
      expect(find.text('Camila Nueva'), findsOneWidget);
      expect(find.byType(AddCellMemberPage), findsOneWidget);
      repository.failCreateMember = false;
      await press(tester, 'Guardar integrante');
      expect(repository.memberCreates, 2);
      expect(repository.addedMembers.length, 1);
      expect(find.byType(AddCellMemberPage), findsNothing);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );

  testWidgets(
    'native back protects a member draft and discard returns to the cell',
    (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('es')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final repository = FakeRepository()..permissions.add('members.write');
      final model = CommunityViewModel(repository);
      await model.restore();
      await mountMemberFlow(tester, model);
      await press(tester, 'Añadir integrante');
      await tester.enterText(
        find.byKey(const ValueKey('new-member-name')),
        'Borrador',
      );
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(
        find.text('Si sales ahora, perderás los datos de este integrante.'),
        findsOneWidget,
      );
      await press(tester, 'Seguir editando');
      expect(find.text('Borrador'), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await press(tester, 'Descartar cambios');
      expect(find.byType(AddCellMemberPage), findsNothing);
      expect(repository.memberCreates, 0);
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );

  testWidgets('an in-flight save cannot create the same member twice', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final repository = SlowMemberRepository()..permissions.add('members.write');
    final model = CommunityViewModel(repository);
    await model.restore();
    await mountMemberFlow(tester, model);
    await press(tester, 'Añadir integrante');
    await tester.enterText(
      find.byKey(const ValueKey('new-member-name')),
      'Una sola persona',
    );
    await press(tester, 'Guardar integrante');
    expect(repository.started, 1);
    await tester.tap(find.text('Guardando…'));
    await tester.pump();
    expect(repository.started, 1);
    repository.release.complete();
    await tester.pumpAndSettle();
    expect(repository.memberCreates, 1);
    expect(find.byType(AddCellMemberPage), findsNothing);
    await tester.pumpWidget(const SizedBox());
    model.dispose();
  });

  testWidgets(
    'adding from a planner draft immediately updates responsible-person choices',
    (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('es')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final api = planner_fixture.PlannerApi();
      api.client.dio.interceptors.insert(
        0,
        InterceptorsWrapper(
          onRequest: (request, handler) {
            if (request.path == '/members' && request.method == 'POST') {
              handler.resolve(
                Response(
                  requestOptions: request,
                  data: {'_id': 'new-member', 'name': request.data['name']},
                ),
              );
            } else {
              handler.next(request);
            }
          },
        ),
      );
      final model = api.model();
      final user = model.session!;
      model.session = Session(
        id: user.id,
        name: user.name,
        email: user.email,
        churchName: user.churchName,
        permissions: {...user.permissions, 'members.write'},
      );
      await mountMemberFlow(tester, model);
      await press(tester, 'Planificador');
      await tester.enterText(
        find.byKey(const ValueKey('meeting-title')),
        'Plan protegido',
      );
      await press(tester, 'Añadir integrante');
      await tester.enterText(
        find.byKey(const ValueKey('new-member-name')),
        'Débora Nueva',
      );
      await press(tester, 'Guardar integrante');
      expect(find.text('Plan protegido'), findsOneWidget);
      expect(model.plannerDirty, isTrue);
      expect(
        tester
            .widget<PersonPicker>(find.byType(PersonPicker).first)
            .options['new-member'],
        'Débora Nueva',
      );
      await tester.pumpWidget(const SizedBox());
      model.dispose();
    },
  );

  for (final entry in {
    'es': 'Añadir integrante',
    'en': 'Add member',
    'pt': 'Adicionar integrante',
  }.entries) {
    testWidgets(
      'member form fits a small phone with large ${entry.key} text and keyboard',
      (tester) async {
        tester.platformDispatcher.localesTestValue = [Locale(entry.key)];
        tester.platformDispatcher.textScaleFactorTestValue = 1.5;
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = FakeRepository()..permissions.add('members.write');
        final model = CommunityViewModel(repository);
        await model.restore();
        final key = GlobalKey();
        await mountMemberFlow(tester, model, captureKey: key);
        await press(tester, entry.value);
        await capture(
          tester,
          key,
          'add-member-${entry.key}-320',
          pixelRatio: 1,
        );
        expect(tester.takeException(), isNull);
        await tester.enterText(
          find.byKey(const ValueKey('new-member-age')),
          '28',
        );
        tester.view.viewInsets = const FakeViewPadding(bottom: 260);
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpAndSettle();
        expect(
          find
              .text(
                {
                  'es': 'Guardar integrante',
                  'en': 'Save member',
                  'pt': 'Salvar integrante',
                }[entry.key]!,
              )
              .hitTestable(),
          findsOneWidget,
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        expect(tester.testTextInput.isVisible, isFalse);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        model.dispose();
      },
    );
  }
}
