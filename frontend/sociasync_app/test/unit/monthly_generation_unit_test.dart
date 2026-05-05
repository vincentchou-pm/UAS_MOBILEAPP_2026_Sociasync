import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/analytics/monthly_summary_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  group('Monthly Summary Unit Tests', () {
    Future<void> pumpMonthlySummaryPage(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MonthlySummaryPage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('menampilkan header, platform selector, dan tanggal', (
      tester,
    ) async {
      await pumpMonthlySummaryPage(tester);

      expect(find.text('Monthly Summary'), findsOneWidget);
      expect(find.text('Instagram'), findsWidgets);
      expect(find.textContaining('Jan - Jul 2026'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('menampilkan chart loading atau chart wrapper awal', (
      tester,
    ) async {
      await pumpMonthlySummaryPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('menampilkan stats grid dan kartu statistik utama', (
      tester,
    ) async {
      await pumpMonthlySummaryPage(tester);

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('Engagement'), findsOneWidget);
      expect(find.text('Reach'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('menampilkan insight card dan AppNavbar di halaman', (
      tester,
    ) async {
      await pumpMonthlySummaryPage(tester);

      expect(find.text('More Insight'), findsOneWidget);
      expect(find.text('AI Suggestion'), findsOneWidget);
      expect(find.byType(AppNavbar), findsOneWidget);
    });
  });
}
