import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/calendar/calendar_month_page.dart';
import 'package:sociasync_app/screens/calendar/calendar_week_page.dart';
import 'package:sociasync_app/screens/calendar/calendar_year_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';
import 'package:sociasync_app/widgets/dashboard_header.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CalendarMonthPage - Integration Tests', () {
    Future<void> pumpCalendarMonthPage(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarMonthPage()));
      await tester.pump();
    }

    Future<void> pumpUntilFound(
      WidgetTester tester,
      Finder finder, {
      int maxPumps = 20,
    }) async {
      for (int i = 0; i < maxPumps; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (finder.evaluate().isNotEmpty) return;
      }
    }

    testWidgets('page loads with header, year, month grid, and navbar', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      expect(find.byType(CalendarMonthPage), findsOneWidget);
      expect(find.byType(DashboardHeader), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.byKey(CalendarMonthPage.monthGridKey), findsOneWidget);
      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('view dropdown navigates from Month view to Year view', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      await tester.tap(find.byKey(CalendarMonthPage.viewDropdownKey));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Year').last);
      await pumpUntilFound(tester, find.byType(CalendarYearPage));

      expect(find.byType(CalendarYearPage), findsOneWidget);
      expect(find.text('Yearly Calendar'), findsOneWidget);
    });

    testWidgets('selecting Month from view dropdown stays on Month view', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      await tester.tap(find.byKey(CalendarMonthPage.viewDropdownKey));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Month').last);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CalendarMonthPage), findsOneWidget);
      expect(find.byKey(CalendarMonthPage.monthGridKey), findsOneWidget);
      expect(find.byType(CalendarWeekPage), findsNothing);
      expect(find.byType(CalendarYearPage), findsNothing);
    });

    testWidgets('tapping a mini month card opens week view for that month', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      final aprilCard = find.byKey(CalendarMonthPage.miniMonthCardKey(4));
      await tester.ensureVisible(aprilCard);
      await tester.pump();

      await tester.tap(
        find.descendant(of: aprilCard, matching: find.text('APRIL')),
      );
      await pumpUntilFound(tester, find.byType(CalendarWeekPage));

      expect(find.byType(CalendarWeekPage), findsOneWidget);
      expect(find.text('Apr 2026'), findsOneWidget);
    });

    testWidgets('mini month day grid displays days inside the card', (
      tester,
    ) async {
      await pumpCalendarMonthPage(tester);

      final marchCard = find.byKey(CalendarMonthPage.miniMonthCardKey(3));

      expect(
        find.byKey(CalendarMonthPage.miniMonthDayGridKey(3)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: marchCard, matching: find.text('MARCH')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: marchCard, matching: find.text('1')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: marchCard, matching: find.text('31')),
        findsOneWidget,
      );
    });
  });
}
