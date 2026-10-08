import 'package:couple_schedule_app/app/theme/app_theme.dart';
import 'package:couple_schedule_app/features/schedule/presentation/pages/schedule_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> openForm(WidgetTester tester, {bool editing = false}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: ScheduleFormPage(
            isEditing: editing,
            initialDate: DateTime(2026, 9, 5),
            initialTitle: editing ? '수업' : '',
          ),
        ),
      ),
    );
  }

  testWidgets('undecided time and shared category only change the form UI', (
    tester,
  ) async {
    await openForm(tester);
    expect(find.text('일정 추가'), findsOneWidget);
    expect(find.text('일정 삭제'), findsNothing);
    await tester.tap(find.text('시간 미정'));
    await tester.pumpAndSettle();
    expect(find.text('시작 시간'), findsNothing);
    await tester.tap(find.text('우리'));
    await tester.pumpAndSettle();
    expect(find.text('데이트'), findsOneWidget);
    await tester.tap(find.text('여행'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '여행')).selected,
      isTrue,
    );
    await tester.tap(find.text('시간 미정'));
    await tester.pumpAndSettle();
    expect(find.text('오후 02:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('date confirmation updates the field and cancel preserves it', (
    tester,
  ) async {
    await openForm(tester);
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10'));
    await tester.tap(find.text('선택'));
    await tester.pumpAndSettle();
    expect(find.text('2026-09-10'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('12'));
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(find.text('2026-09-10'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('edit mode and time picker render without persisting changes', (
    tester,
  ) async {
    await openForm(tester, editing: true);
    expect(find.text('일정 수정'), findsOneWidget);
    expect(find.text('수업'), findsOneWidget);
    expect(find.text('일정 삭제'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.access_time_rounded).first);
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoPicker), findsNWidgets(3));
    final wheels = tester
        .widgetList<CupertinoPicker>(find.byType(CupertinoPicker))
        .toList();
    wheels[0].scrollController!.jumpToItem(0);
    wheels[1].scrollController!.jumpToItem(11);
    wheels[2].scrollController!.jumpToItem(30);
    await tester.pumpAndSettle();
    await tester.tap(find.text('선택'));
    await tester.pumpAndSettle();
    expect(find.text('오전 12:30'), findsOneWidget);
    expect(find.text('오후 03:00'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.access_time_rounded).last);
    await tester.pumpAndSettle();
    final endWheels = tester
        .widgetList<CupertinoPicker>(find.byType(CupertinoPicker))
        .toList();
    endWheels[1].scrollController!.jumpToItem(11);
    await tester.pumpAndSettle();
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(find.text('오후 03:00'), findsOneWidget);
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();
    expect(find.text('일정 수정'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
