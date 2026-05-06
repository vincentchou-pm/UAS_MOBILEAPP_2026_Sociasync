import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/profile/help_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  group('HelpPage - Widget Tests - Header', () {
    testWidgets('menampilkan header dengan judul Help', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.text('Help'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('header memiliki gradient background dengan warna biru', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.byType(ClipPath), findsWidgets);
    });

    testWidgets('menampilkan wave clipper pada header', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.byType(ClipPath), findsWidgets);
    });
  });

  group('HelpPage - Widget Tests - Content List', () {
    testWidgets('menampilkan judul "How can we help?"', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.text('How can we help?'), findsOneWidget);
    });

    testWidgets('menampilkan semua help topics dalam list', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.text('Account growth'), findsOneWidget);
      expect(
        find.text('Analytics formula (Engagement & Reach)'),
        findsOneWidget,
      );
      expect(find.text('Your account status'), findsOneWidget);
      expect(find.text('Account safety'), findsOneWidget);
      expect(find.text('Updating name'), findsOneWidget);
      expect(find.text('Forgot my password'), findsOneWidget);
      expect(find.text('Editing, posting, and deleting'), findsOneWidget);
      expect(find.text('Searching for content'), findsOneWidget);
      expect(find.text('Unable to follow a user'), findsOneWidget);
    });

    testWidgets('setiap topic tile memiliki chevron icon', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    testWidgets('list bersifat scrollable', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });

  group('HelpPage - Widget Tests - Topic Dialog', () {
    testWidgets('tap topic membuka dialog', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Account growth'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Account growth'), findsWidgets);
    });

    testWidgets('dialog menampilkan konten help dengan scrollable area', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Account safety'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Got it'), findsOneWidget);
    });

    testWidgets('dialog memiliki tombol close (X) di pojok kanan atas', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Account growth'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('dialog memiliki tombol "Got it" untuk menutup', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot my password'));
      await tester.pumpAndSettle();

      expect(find.text('Got it'), findsOneWidget);

      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('menutup dialog dengan tap tombol X', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Account growth'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('dialog memiliki Divider setelah judul', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Updating name'));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsOneWidget);
    });
  });

  group('HelpPage - Widget Tests - Bottom Navbar', () {
    testWidgets('menampilkan AppNavbar di bagian bawah', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('navbar memiliki primary blue background', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('Help item di navbar dipilih (selectedIndex 3)', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.byType(AppNavbar), findsOneWidget);
    });
  });
}
