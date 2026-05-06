import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/analytics/monthly_summary_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Monthly Summary Integration Tests', () {
    Future<void> pumpMonthlySummaryPage(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MonthlySummaryPage()));
      await tester.pumpAndSettle();
    }

    testWidgets('menampilkan header dan platform selector', (tester) async {
      await pumpMonthlySummaryPage(tester);

      expect(find.text('Monthly Summary'), findsOneWidget);
      expect(find.byType(DropdownButton<AnalyticsPlatform>), findsOneWidget);
      expect(find.text('Instagram'), findsOneWidget);
    });

    testWidgets('menampilkan chart wrapper atau pesan koneksi', (tester) async {
      await pumpMonthlySummaryPage(tester);

      expect(find.textContaining('Instagram belum terhubung.'), findsOneWidget);
      expect(find.text('Connect Username'), findsOneWidget);
    });

    testWidgets('menampilkan stats grid dan card labels', (tester) async {
      await pumpMonthlySummaryPage(tester);

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('Engagement'), findsOneWidget);
      expect(find.text('Reach'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('menampilkan insight alert card dan AppNavbar', (tester) async {
      await pumpMonthlySummaryPage(tester);

      expect(find.text('More Insight'), findsOneWidget);
      expect(find.text('AI Suggestion'), findsOneWidget);
      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('berubah ke TikTok saat memilih platform TikTok', (
      tester,
    ) async {
      await pumpMonthlySummaryPage(tester);

      await tester.tap(find.byType(DropdownButton<AnalyticsPlatform>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('TikTok').last);
      await tester.pumpAndSettle();

      expect(find.text('TikTok'), findsWidgets);
      expect(find.text('TikTok belum terhubung.'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
    });
  });
}
