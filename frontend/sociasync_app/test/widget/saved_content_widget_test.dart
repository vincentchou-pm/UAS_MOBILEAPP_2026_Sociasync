import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/content_generator/saved_content_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  group('SavedContentPage Widget Tests', () {
    testWidgets(
      'menampilkan header, search field, filter date dan sort chips',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const SavedContentPage(),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Saved Strategy'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Filter Date'), findsOneWidget);
        expect(find.text('Platform'), findsOneWidget);
        expect(find.text('Latest (Date)'), findsOneWidget);
      },
    );

    testWidgets('tap sort chips tidak menyebabkan error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: const SavedContentPage()),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Platform'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Latest (Date)'));
      await tester.pumpAndSettle();

      expect(find.text('Platform'), findsOneWidget);
      expect(find.text('Latest (Date)'), findsOneWidget);
    });

    testWidgets('tap Filter Date membuka dialog dan Apply', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Filter Date'));
      await tester.pumpAndSettle();

      expect(find.text('Select Date Range'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);

      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Strategy'), findsOneWidget);
    });

    testWidgets('menampilkan pesan no strategy saat data kosong', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      expect(find.text('No strategy found.'), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('menampilkan saved content card dan navigasi detail', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('Test Topic'), findsOneWidget);

      final cardGesture = find.ancestor(
        of: find.text('Test Topic'),
        matching: find.byType(GestureDetector),
      );
      expect(cardGesture, findsWidgets);

      await tester.ensureVisible(cardGesture.first);
      await tester.tap(cardGesture.first);
      await tester.pumpAndSettle();

      expect(find.text('Saved Content Detail'), findsOneWidget);
      expect(find.text('Topic'), findsOneWidget);
      expect(find.text('Test Topic'), findsOneWidget);
    });

    testWidgets('menampilkan AppNavbar di halaman Saved Content', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      expect(find.byType(AppNavbar), findsOneWidget);
    });
  });
}
