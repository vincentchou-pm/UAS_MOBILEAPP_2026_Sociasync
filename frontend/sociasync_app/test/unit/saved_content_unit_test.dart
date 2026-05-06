import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/content_generator/saved_content_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  group('SavedContentPage - Render UI', () {
    testWidgets('menampilkan header Saved Strategy dan search field', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      expect(find.text('Saved Strategy'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Filter Date'), findsOneWidget);
    });

    testWidgets('menampilkan sort chips Platform dan Latest (Date)', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      expect(find.text('Platform'), findsOneWidget);
      expect(find.text('Latest (Date)'), findsOneWidget);
    });

    testWidgets('menampilkan bottom navbar di Saved Content page', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      expect(find.byType(AppNavbar), findsOneWidget);
    });
  });

  group('SavedContentPage - Search and filter interactions', () {
    testWidgets('search input menerima teks', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'strategy');
      await tester.pumpAndSettle();

      expect(find.text('strategy'), findsOneWidget);
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
  });

  group('SavedContentPage - Content card and detail navigation', () {
    testWidgets('menampilkan pesan kosong saat tidak ada data', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

      await tester.pumpAndSettle();

      expect(find.text('No strategy found.'), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets(
      'tap content card membuka Saved Content Detail ketika data ada',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: SavedContentPage()));

        await tester.pumpAndSettle();

        expect(find.byType(GridView), findsOneWidget);
        expect(find.text('Test Topic'), findsOneWidget);

        final cardTapTarget = find.ancestor(
          of: find.text('Test Topic'),
          matching: find.byType(GestureDetector),
        );
        expect(cardTapTarget, findsWidgets);

        await tester.ensureVisible(cardTapTarget.first);
        await tester.tap(cardTapTarget.first);
        await tester.pumpAndSettle();

        expect(find.text('Saved Content Detail'), findsOneWidget);
        expect(find.text('Topic'), findsOneWidget);
        expect(find.text('Test Topic'), findsOneWidget);
      },
    );
  });
}
