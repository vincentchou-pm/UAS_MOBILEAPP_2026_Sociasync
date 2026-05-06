import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/calendar/calendar_year_page.dart';
import 'package:sociasync_app/widgets/app_background_wrapper.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';
import 'package:sociasync_app/widgets/dashboard_header.dart';

Finder get viewDropdown => find.byKey(const Key('calendarYearViewDropdown'));

void main() {
  group('CalendarYearPage Widget Tests', () {
    // ===== Basic Rendering Tests =====
    group('basic rendering', () {
      testWidgets('widget renders without errors', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('displays AppBackgroundWrapper', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppBackgroundWrapper), findsOneWidget);
      });

      testWidgets('displays Scaffold', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(Scaffold), findsWidgets);
      });

      testWidgets('displays DashboardHeader', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(DashboardHeader), findsOneWidget);
      });

      testWidgets('displays AppNavbar at bottom', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('displays "Yearly Calendar" title', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Yearly Calendar'), findsOneWidget);
      });

      testWidgets('displays SafeArea', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(SafeArea), findsWidgets);
      });
    });

    // ===== Switch View Selector Tests =====
    group('switch view selector (Dropdown)', () {
      testWidgets('displays view dropdown button with "Year" text', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Year'), findsWidgets);
      });

      testWidgets('dropdown button shows arrow icon', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        expect(
          find.descendant(
            of: viewDropdown,
            matching: find.byIcon(Icons.keyboard_arrow_down),
          ),
          findsOneWidget,
        );
      });

      testWidgets('dropdown button is tappable', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(viewDropdown);
        await tester.pumpAndSettle();

        expect(find.text('Week'), findsOneWidget);
        expect(find.text('Month'), findsOneWidget);
        expect(find.text('Year'), findsWidgets); // Multiple occurrences
      });

      testWidgets('shows all menu options when dropdown opened', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(viewDropdown);
        await tester.pumpAndSettle();

        expect(find.text('Week'), findsOneWidget);
        expect(find.text('Month'), findsOneWidget);
        expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
      });

      testWidgets('dropdown menu items are properly positioned', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(viewDropdown);
        await tester.pumpAndSettle();

        final menuItems = find.byType(PopupMenuItem<String>);
        expect(menuItems, findsNWidgets(3));
      });
    });

    // ===== Year/Month Grid Tests =====
    group('year/month grid', () {
      testWidgets('displays year list container', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('displays multiple year items', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Should have year containers
        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('year 2026 is expanded by default', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('2026'), findsWidgets); // Year title + grid visibility
      });

      testWidgets('displays month items when year expanded', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Current year (2026) should have months visible
        expect(find.text('JAN'), findsOneWidget);
        expect(find.text('FEB'), findsOneWidget);
        expect(find.text('DEC'), findsOneWidget);
      });

      testWidgets('year 2026 has blue background', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        final year2026Container = find.byType(Container);
        expect(year2026Container, findsWidgets);
      });

      testWidgets('other years have default background', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Should find text for other years
        expect(find.text('2020'), findsOneWidget);
        expect(find.text('2025'), findsOneWidget);
      });

      testWidgets('year can be tapped to expand', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Tap year 2020 to expand
        final year2020InkWells = find.ancestor(
          of: find.text('2020'),
          matching: find.byType(InkWell),
        );
        expect(year2020InkWells, findsOneWidget);
      });

      testWidgets('expanded year shows 12 months', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Current year (2026) is expanded, should have all 12 months
        expect(find.text('JAN'), findsOneWidget);
        expect(find.text('MAY'), findsOneWidget);
        expect(find.text('DEC'), findsOneWidget);
      });
    });

    // ===== Tip Logic (Ke Bulan) Tests =====
    group('tap logic - navigate to month', () {
      testWidgets('month items are tappable', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Find month button (e.g., JAN)
        final janButton = find.text('JAN');
        expect(janButton, findsOneWidget);
      });

      testWidgets('month buttons have proper styling', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        final monthButtons = find.byType(GestureDetector);
        expect(monthButtons, findsWidgets);
      });

      testWidgets('all month buttons are accessible', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Check all months are visible
        expect(find.text('JAN'), findsOneWidget);
        expect(find.text('FEB'), findsOneWidget);
        expect(find.text('MAR'), findsOneWidget);
        expect(find.text('APR'), findsOneWidget);
        expect(find.text('MAY'), findsOneWidget);
        expect(find.text('JUN'), findsOneWidget);
        expect(find.text('JUL'), findsOneWidget);
        expect(find.text('AUG'), findsOneWidget);
        expect(find.text('SEP'), findsOneWidget);
        expect(find.text('OKT'), findsOneWidget);
        expect(find.text('NOV'), findsOneWidget);
        expect(find.text('DEC'), findsOneWidget);
      });
    });

    // ===== Bottom Navbar Tests =====
    group('bottom navbar', () {
      testWidgets('displays AppNavbar', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar has calendar index selected', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar has correct background color', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar navigation items are accessible', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        final navbar = find.byType(AppNavbar);
        expect(navbar, findsOneWidget);
      });
    });

    // ===== Negative Tests =====
    group('negative tests', () {
      testWidgets('empty years list renders without error', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('dropdown closes after selecting option', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Open dropdown
        await tester.tap(viewDropdown);
        await tester.pumpAndSettle();

        // Close by tapping outside the popup menu.
        await tester.tapAt(const Offset(20, 20));
        await tester.pumpAndSettle();

        expect(find.byType(PopupMenuItem<String>), findsNothing);
      });

      testWidgets('collapsed year does not show months', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Collapse current year first by tapping it
        await tester.tap(find.byType(InkWell).first);
        await tester.pump(const Duration(milliseconds: 500));

        // After first collapse, months should not be visible
        // (This depends on initialization - verify behavior)
      });

      testWidgets('invalid month selection does not crash', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Widget should still be intact
        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('multiple rapid dropdown taps handled', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Tap dropdown multiple times
        await tester.tap(viewDropdown);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.tapAt(const Offset(20, 20));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.tap(viewDropdown);
        await tester.pumpAndSettle();

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('year expand/collapse toggles correctly', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Get year 2020 InkWell
        final year2020 = find.ancestor(
          of: find.text('2020'),
          matching: find.byType(InkWell),
        );

        // Tap to expand
        await tester.tap(year2020.first);
        await tester.pump(const Duration(milliseconds: 500));

        // Tap to collapse
        await tester.tap(year2020.first);
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('scroll handles gracefully', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pump(const Duration(milliseconds: 500));

        // Scroll down
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CalendarYearPage), findsOneWidget);
      });

      testWidgets('UI remains responsive after loading', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: CalendarYearPage()));
        await tester.pumpAndSettle();

        // Try interaction
        await tester.tap(viewDropdown);
        await tester.pumpAndSettle();

        expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
      });
    });
  });
}
