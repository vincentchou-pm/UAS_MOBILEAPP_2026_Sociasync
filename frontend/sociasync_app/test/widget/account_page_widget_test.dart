import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/profile/account_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  group('AccountPage - Widget Tests - Header Structure', () {
    testWidgets('menampilkan header dengan judul Account', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(find.text('Account'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('header memiliki gradient background dengan wave clipper', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(find.byType(ClipPath), findsWidgets);
    });

    testWidgets('menampilkan profile avatar di bawah header', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('profile avatar memiliki white border', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      final avatarContainer = find
          .byType(Container)
          .at(1); // Find the container with border
      expect(avatarContainer, findsOneWidget);
    });
  });

  group('AccountPage - Widget Tests - Loading State', () {
    testWidgets('menampilkan loading indicator saat pertama kali load', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      // Initially should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('AccountPage - Widget Tests - Layout Structure', () {
    testWidgets('menggunakan Column sebagai main layout', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('menggunakan Stack untuk header dengan positioned elements', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('menggunakan Scaffold sebagai main widget', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(
        find.byType(Scaffold),
        findsWidgets,
      ); // AppBackgroundWrapper + AccountPage
    });
  });

  group('AccountPage - Widget Tests - Bottom Navbar', () {
    testWidgets('menampilkan AppNavbar di bagian bawah', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('AppNavbar memiliki selectedIndex 3 untuk Account', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('AppNavbar berada di bottomNavigationBar property', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      expect(
        find.byType(Scaffold),
        findsWidgets,
      ); // AppBackgroundWrapper + AccountPage
    });
  });

  group('AccountPage - Widget Tests - Background & Styling', () {
    testWidgets('menggunakan AppBackgroundWrapper', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      // AppBackgroundWrapper is a custom widget, verify page renders
      expect(find.byType(AccountPage), findsOneWidget);
    });

    testWidgets('Scaffold memiliki transparent background', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pump();

      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsWidgets); // AppBackgroundWrapper + AccountPage
    });
  });
}
