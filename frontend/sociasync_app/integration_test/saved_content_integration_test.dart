import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/main.dart' as app;

/// ===========================================================
/// INTEGRATION TEST - Saved Content Page
/// Tester : Gracello
/// File   : saved_content_integration_test.dart
/// Jalankan: flutter test integration_test/saved_content_integration_test.dart
///
/// Menguji: header, search field, sort/filter chips, date filter,
///         saved content card, detail navigation, dan bottom navbar.
/// ===========================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration - Navigasi ke SavedContentPage', () {
    testWidgets('tap bookmark icon → tampil halaman Saved Strategy', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      final bookmarkIcon = find.byIcon(Icons.bookmark);
      expect(bookmarkIcon, findsWidgets);

      await tester.tap(bookmarkIcon.first);
      await tester.pumpAndSettle();

      expect(find.text('Saved Strategy'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('Integration - Search, Sort, dan Filter Date', () {
    testWidgets('search field menerima teks dan menampilkan input', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      final bookmarkIcon = find.byIcon(Icons.bookmark).first;
      await tester.tap(bookmarkIcon);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'strategy');
      await tester.pumpAndSettle();

      expect(find.text('strategy'), findsOneWidget);
    });

    testWidgets('sort chips Platform dan Latest (Date) dapat ditekan', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark).first);
      await tester.pumpAndSettle();

      final platformChip = find.text('Platform');
      final dateChip = find.text('Latest (Date)');

      expect(platformChip, findsOneWidget);
      expect(dateChip, findsOneWidget);

      await tester.tap(platformChip);
      await tester.pumpAndSettle();
      await tester.tap(dateChip);
      await tester.pumpAndSettle();

      expect(platformChip, findsOneWidget);
      expect(dateChip, findsOneWidget);
    });

    testWidgets('tap Filter Date → showDatePicker dialog muncul dan apply', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark).first);
      await tester.pumpAndSettle();

      final filterDateButton = find.text('Filter Date');
      expect(filterDateButton, findsOneWidget);

      await tester.tap(filterDateButton);
      await tester.pumpAndSettle();

      expect(find.text('Select Date Range'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);

      // Buka date picker untuk memicu showDatePicker()
      await tester.tap(find.text('Start Date'));
      await tester.pumpAndSettle();

      if (find.text('OK').evaluate().isNotEmpty) {
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Strategy'), findsOneWidget);
    });
  });

  group('Integration - Saved Content Card & Detail', () {
    testWidgets('tampilkan list card atau teks no strategy', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark).first);
      await tester.pumpAndSettle();

      final noStrategyText = find.text('No strategy found.');
      final gridView = find.byType(GridView);

      expect(
        noStrategyText.evaluate().isNotEmpty || gridView.evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('tap saved content card → navigasi ke detail jika ada data', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark).first);
      await tester.pumpAndSettle();

      final gridView = find.byType(GridView);
      if (gridView.evaluate().isEmpty) {
        return;
      }

      final cardItem = find.byWidgetPredicate((widget) {
        if (widget is GestureDetector && widget.child is Container) {
          final container = widget.child as Container;
          return container.child is Column;
        }
        return false;
      }, description: 'saved strategy card');

      expect(cardItem, findsWidgets);
      await tester.tap(cardItem.first);
      await tester.pumpAndSettle();

      expect(find.text('Saved Content Detail'), findsOneWidget);
    });
  });

  group('Integration - Bottom Navbar', () {
    testWidgets('bottom navbar tampil di Saved Content page', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark).first);
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
