import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/calendar/calendar_month_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';
import 'package:sociasync_app/widgets/dashboard_header.dart';

void main() {
  group('CalendarMonthPage - Widget Tests', () {
    Future<void> pumpCalendarMonthPage(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarMonthPage()));
      await tester.pump();
    }

    SliverGridDelegateWithFixedCrossAxisCount monthGridDelegate(
      WidgetTester tester,
    ) {
      final grid = tester.widget<GridView>(
        find.byKey(CalendarMonthPage.monthGridKey),
      );
      return grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    }

    testWidgets('renders header, year display, and view dropdown', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      expect(find.byType(DashboardHeader), findsOneWidget);
      expect(find.byKey(CalendarMonthPage.yearTextKey), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.byKey(CalendarMonthPage.viewDropdownKey), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('opens view dropdown menu with Week Month Year options', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      await tester.tap(find.byKey(CalendarMonthPage.viewDropdownKey));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
      expect(find.text('Week'), findsOneWidget);
      expect(find.text('Month'), findsWidgets);
      expect(find.text('Year'), findsOneWidget);
    });

    testWidgets('marks Month as the active dropdown menu item', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      await tester.tap(find.byKey(CalendarMonthPage.viewDropdownKey));
      await tester.pump(const Duration(milliseconds: 500));

      final monthItem = tester.widget<PopupMenuItem<String>>(
        find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuItem<String> && widget.value == 'Month',
        ),
      );
      final monthText = monthItem.child as Text;
      final style = monthText.style;

      expect(style?.fontWeight, FontWeight.bold);
      expect(style?.color, const Color(0xFF1D5093));
    });

    testWidgets('renders month grid layout with 12 mini month cards', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      final monthGrid = tester.widget<GridView>(
        find.byKey(CalendarMonthPage.monthGridKey),
      );

      expect(find.byKey(CalendarMonthPage.monthGridKey), findsOneWidget);
      expect(monthGrid.semanticChildCount, 12);
    });

    testWidgets('uses 2 month card columns on small phone width', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpCalendarMonthPage(tester);

      final delegate = monthGridDelegate(tester);

      expect(delegate.crossAxisCount, 2);
      expect(delegate.crossAxisSpacing, 8);
      expect(delegate.mainAxisSpacing, 8);
      expect(tester.takeException(), isNull);
    });

    testWidgets('uses 3 month card columns on wider phone width', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpCalendarMonthPage(tester);

      final delegate = monthGridDelegate(tester);

      expect(delegate.crossAxisCount, 3);
      expect(delegate.crossAxisSpacing, 10);
      expect(delegate.mainAxisSpacing, 10);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders mini month card content and day grid', (tester) async {
      await pumpCalendarMonthPage(tester);

      final marchCard = find.byKey(CalendarMonthPage.miniMonthCardKey(3));

      expect(marchCard, findsOneWidget);
      expect(
        find.descendant(of: marchCard, matching: find.text('MARCH')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: marchCard, matching: find.text('31')),
        findsOneWidget,
      );
      expect(
        find.byKey(CalendarMonthPage.miniMonthDayGridKey(3)),
        findsOneWidget,
      );
    });

    testWidgets('highlights March mini month card as the current month', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      final marchCard = find.byKey(CalendarMonthPage.miniMonthCardKey(3));
      final containers = tester.widgetList<Container>(
        find.descendant(of: marchCard, matching: find.byType(Container)),
      );

      final hasPrimaryBlueBackground = containers.any((container) {
        final decoration = container.decoration;
        return decoration is BoxDecoration &&
            decoration.color == const Color(0xFF1D5093);
      });

      expect(hasPrimaryBlueBackground, isTrue);
    });

    testWidgets('does not highlight non-current mini month card', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      final aprilCard = find.byKey(CalendarMonthPage.miniMonthCardKey(4));
      final containers = tester.widgetList<Container>(
        find.descendant(of: aprilCard, matching: find.byType(Container)),
      );

      final hasPrimaryBlueBackground = containers.any((container) {
        final decoration = container.decoration;
        return decoration is BoxDecoration &&
            decoration.color == const Color(0xFF1D5093);
      });

      expect(hasPrimaryBlueBackground, isFalse);
    });

    testWidgets('renders bottom navigation with calendar tab selected', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      final navbar = tester.widget<AppNavbar>(find.byType(AppNavbar));

      expect(find.byType(AppNavbar), findsOneWidget);
      expect(navbar.selectedIndex, 1);
    });
  });
}
