import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sheeplink/domain/models/community.dart';
import 'package:sheeplink/ui/core/theme/app_theme.dart';
import 'package:sheeplink/ui/core/widgets/person_picker.dart';
import 'package:sheeplink/ui/features/community/view_models/community_view_model.dart';
import 'package:sheeplink/ui/features/community/views/cell_meeting_selector.dart';
import 'package:sheeplink/ui/features/community/views/planner_activity_picker.dart';
import 'fake_repository.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es'));
  for (final selector in ['fecha', 'célula', 'responsable', 'actividades']) {
    final exits = [
      selector == 'fecha' ? 'Cancelar' : 'Cerrar',
      'fuera',
      'atrás',
      'Escape',
      if (selector != 'fecha') 'arrastrar',
    ];
    for (final exit in exits) {
      testWidgets('$selector can exit via $exit without applying changes', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.5;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final model = CommunityViewModel(FakeRepository())
          ..date = DateTime(2026, 11, 10)
          ..cell = const Cell(
            id: 'a',
            name: 'Célula A',
            timezone: 'America/Lima',
          )
          ..cells = [
            const Cell(id: 'a', name: 'Célula A', timezone: 'America/Lima'),
            const Cell(id: 'b', name: 'Célula B', timezone: 'America/Lima'),
          ];
        var applied = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: const [Locale('es')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: TextButton(
                    onPressed: () {
                      switch (selector) {
                        case 'fecha':
                          CellMeetingSelector(model: model).changeDate(context);
                        case 'célula':
                          CellMeetingSelector(model: model).changeCell(context);
                        case 'responsable':
                          PersonPicker(
                            label: 'Responsable',
                            options: const {'ana': 'Ana'},
                            value: '',
                            onChanged: (_) => applied++,
                          ).choose(context);
                        case 'actividades':
                          showPlannerActivityPicker(
                            context,
                            title: 'Actividades',
                            description: 'Elige actividades',
                            options: [
                              {'key': 'welcome', 'title': 'Bienvenida'},
                            ],
                            selected: {'welcome'},
                            onSave: (_) async {
                              applied++;
                            },
                          );
                      }
                    },
                    child: const Text('Abrir selector'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Abrir selector'));
        await tester.pumpAndSettle();
        if (selector == 'actividades') {
          await tester.tap(find.byType(CheckboxListTile));
          await tester.pumpAndSettle();
        }
        switch (exit) {
          case 'Cancelar':
            await tester.tap(find.text('Cancelar'));
          case 'Cerrar':
            await tester.tap(find.byTooltip('Cerrar selector'));
          case 'fuera':
            await tester.tapAt(const Offset(5, 5));
          case 'atrás':
            await tester.binding.handlePopRoute();
          case 'Escape':
            await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          case 'arrastrar':
            final top = tester.getTopLeft(find.byType(BottomSheet));
            await tester.dragFrom(
              Offset(200, top.dy + 12),
              const Offset(0, 600),
            );
        }
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsNothing);
        expect(find.byType(DatePickerDialog), findsNothing);
        expect(find.text('Abrir selector').hitTestable(), findsOneWidget);
        expect(applied, 0);
        expect(model.cell?.id, 'a');
        expect(model.day, '2026-11-10');
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        model.dispose();
      });
    }
  }
}
