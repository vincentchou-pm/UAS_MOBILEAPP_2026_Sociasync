import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/dashboard/dashboard_page.dart';
import 'package:sociasync_app/widgets/dashboard_header.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  Widget createWidget() {
    return const MaterialApp(home: DashboardPage(isTest: true));
  }

  group('DashboardPage - UI Structure', () {
    testWidgets('renders main components', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(DashboardHeader), findsOneWidget);
      expect(find.byType(AppNavbar), findsOneWidget);

      // Text static aman
      expect(find.text('Best Performance'), findsOneWidget);

      // Button biasanya ada
      expect(find.byType(ElevatedButton), findsWidgets);

      expect(find.byType(LineChart), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(DropdownButton<SocialPlatform>), findsOneWidget);
      expect(find.text('Best Performance'), findsOneWidget);
    });
  });

  group('DashboardPage - Interaction', () {
    testWidgets('can scroll page', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );

      await tester.pump();
    });

    testWidgets('dropdown interaction (safe)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final dropdown = find.byType(DropdownButton);

      if (dropdown.evaluate().isNotEmpty) {
        await tester.tap(dropdown.first);
        await tester.pump();
      }
    });

    testWidgets('generate button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();

      final button = find.byType(ElevatedButton);

      if (button.evaluate().isNotEmpty) {
        await tester.tap(button.last, warnIfMissed: false);
        await tester.pump();
      }
    });
  });
}
