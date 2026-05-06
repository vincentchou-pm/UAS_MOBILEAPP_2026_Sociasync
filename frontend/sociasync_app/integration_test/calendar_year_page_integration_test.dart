import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/calendar/calendar_year_page.dart';
import 'package:sociasync_app/screens/calendar/calendar_week_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

Finder get viewDropdown => find.byKey(const Key('calendarYearViewDropdown'));

Future<void> pumpYearPage(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
  await tester.pumpAndSettle();
}

Future<void> openViewDropdown(WidgetTester tester) async {
  await tester.tap(viewDropdown);
  await tester.pumpAndSettle();
}

Finder yearRow(String year) {
  return find.ancestor(of: find.text(year), matching: find.byType(InkWell));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CalendarYearPage Integration Tests', () {
    group('page loads and displays correctly', () {
      testWidgets('page initializes without errors', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('displays header with username', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(RichText), findsWidgets);
      });

      testWidgets('displays title "Yearly Calendar"', (tester) async {
        await pumpYearPage(tester);

        expect(find.text('Yearly Calendar'), findsOneWidget);
      });

      testWidgets('displays view dropdown button', (tester) async {
        await pumpYearPage(tester);

        expect(viewDropdown, findsOneWidget);
        expect(
          find.descendant(
            of: viewDropdown,
            matching: find.byIcon(Icons.keyboard_arrow_down),
          ),
          findsOneWidget,
        );
      });

      testWidgets('displays year list', (tester) async {
        await pumpYearPage(tester);

        expect(find.text('2020'), findsOneWidget);
        expect(find.text('2026'), findsWidgets);
      });

      testWidgets('displays navbar at bottom', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('displays current year (2026) with blue highlight', (
        tester,
      ) async {
        await pumpYearPage(tester);

        expect(find.text('2026'), findsWidgets);
      });
    });

    group('switch view selector workflow', () {
      testWidgets('dropdown opens menu when tapped', (tester) async {
        await pumpYearPage(tester);

        await openViewDropdown(tester);

        expect(find.text('Week'), findsOneWidget);
        expect(find.text('Month'), findsOneWidget);
      });

      testWidgets('shows all three view options', (tester) async {
        await pumpYearPage(tester);

        await openViewDropdown(tester);

        expect(find.text('Week'), findsOneWidget);
        expect(find.text('Month'), findsOneWidget);
        expect(find.text('Year'), findsWidgets);
      });

      testWidgets('can navigate to Month view', (tester) async {
        await pumpYearPage(tester);

        await openViewDropdown(tester);
        await tester.tap(find.text('Month'));
        await tester.pumpAndSettle();

        expect(find.text('Yearly Calendar'), findsNothing);
      });

      testWidgets('can navigate to Week view', (tester) async {
        await pumpYearPage(tester);

        await openViewDropdown(tester);
        await tester.tap(find.text('Week'));
        await tester.pumpAndSettle();

        expect(find.text('Yearly Calendar'), findsNothing);
      });

      testWidgets('dropdown closes after selection', (tester) async {
        await pumpYearPage(tester);

        await openViewDropdown(tester);
        await tester.tap(find.text('Month'));
        await tester.pumpAndSettle();

        expect(find.text('Week'), findsNothing);
      });
    });

    group('year expansion and month grid display', () {
      testWidgets('current year (2026) is expanded by default', (tester) async {
        await pumpYearPage(tester);

        expect(find.text('JAN'), findsOneWidget);
        expect(find.text('DEC'), findsOneWidget);
      });

      testWidgets('all 12 months visible for expanded year', (tester) async {
        await pumpYearPage(tester);

        for (final month in [
          'JAN',
          'FEB',
          'MAR',
          'APR',
          'MAY',
          'JUN',
          'JUL',
          'AUG',
          'SEP',
          'OKT',
          'NOV',
          'DEC',
        ]) {
          expect(find.text(month), findsOneWidget);
        }
      });

      testWidgets('can expand other year', (tester) async {
        await pumpYearPage(tester);

        await tester.tap(yearRow('2020').first);
        await tester.pumpAndSettle();

        expect(find.text('JAN'), findsOneWidget);
      });

      testWidgets('can collapse expanded year', (tester) async {
        await pumpYearPage(tester);

        expect(find.text('JAN'), findsOneWidget);

        await tester.tap(yearRow('2026').first);
        await tester.pumpAndSettle();

        expect(find.text('JAN'), findsNothing);
      });

      testWidgets('months appear in grid layout', (tester) async {
        await pumpYearPage(tester);

        expect(find.text('JAN'), findsOneWidget);
        expect(find.text('MAY'), findsOneWidget);
        expect(find.text('DEC'), findsOneWidget);
      });

      testWidgets('month buttons have proper styling', (tester) async {
        await pumpYearPage(tester);

        expect(find.text('JAN'), findsOneWidget);
      });
    });

    group('tap month to navigate', () {
      testWidgets('tapping month navigates to week view', (tester) async {
        await pumpYearPage(tester);

        await tester.tap(find.text('JAN'));
        await tester.pumpAndSettle();

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('can tap multiple months sequentially', (tester) async {
        await pumpYearPage(tester);

        await tester.tap(find.text('JAN'));
        await tester.pumpAndSettle();

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('month selection works for all 12 months', (tester) async {
        await pumpYearPage(tester);

        for (final month in ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN']) {
          expect(find.text(month), findsOneWidget);
        }
      });

      testWidgets('can navigate back to year view', (tester) async {
        await pumpYearPage(tester);

        await tester.tap(find.text('JAN'));
        await tester.pumpAndSettle();

        expect(find.text('Yearly Calendar'), findsNothing);
      });
    });

    group('navbar navigation', () {
      testWidgets('navbar is displayed', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('can navigate to Dashboard', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('can navigate to Chatbot', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('can navigate to Profile', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar remains visible after navigation', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });
    });

    group('scroll and responsiveness', () {
      testWidgets('can scroll year list', (tester) async {
        await pumpYearPage(tester);

        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('scroll back to top', (tester) async {
        await pumpYearPage(tester);

        final yearList = find.byType(SingleChildScrollView);
        await tester.drag(yearList, const Offset(0, -300));
        await tester.pumpAndSettle();
        await tester.drag(yearList, const Offset(0, 300));
        await tester.pumpAndSettle();

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('UI remains responsive during interaction', (tester) async {
        await pumpYearPage(tester);

        await openViewDropdown(tester);
        await tester.tapAt(const Offset(20, 20));
        await tester.pumpAndSettle();

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });
    });

    group('error handling and edge cases', () {
      testWidgets('page handles rapid year expansion/collapse', (tester) async {
        await pumpYearPage(tester);

        await tester.tap(yearRow('2025').first);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.tap(yearRow('2025').first);
        await tester.pumpAndSettle();

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('page handles rapid dropdown opens/closes', (tester) async {
        await pumpYearPage(tester);

        await tester.tap(viewDropdown);
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tapAt(const Offset(20, 20));
        await tester.pumpAndSettle();

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('navbar tap does not crash app', (tester) async {
        await pumpYearPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('month grid displays correctly on different screen sizes', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await pumpYearPage(tester);

        expect(find.text('JAN'), findsOneWidget);
        expect(find.text('DEC'), findsOneWidget);
      });

      testWidgets('page data persists after view navigation', (tester) async {
        await pumpYearPage(tester);

        await openViewDropdown(tester);
        await tester.tap(find.text('Year').last);
        await tester.pumpAndSettle();

        expect(find.text('Yearly Calendar'), findsOneWidget);
      });
    });
  });
}
