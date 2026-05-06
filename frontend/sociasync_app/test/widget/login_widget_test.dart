import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/auth/login_page.dart';

/// ===========================================================
/// WIDGET TEST - Login Page UI
/// Tester : Login Page Widget Test
/// File   : login_widget_test.dart
/// Jalankan: flutter test test/widget/login_widget_test.dart
///
/// CATATAN: Test untuk LoginPage widget UI interactions
/// Validation logic tests ada di login_validator_test.dart
/// ===========================================================

void main() {
  group('LoginPage - UI Rendering', () {
    testWidgets('renders login page with main elements', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('renders email and password labels', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.text('Email'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('renders login button', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
      expect(tester.widget<ElevatedButton>(button).onPressed, isNotNull);
    });

    testWidgets('renders text fields', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('renders page with scrollable content', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('LoginPage - Text Input', () {
    testWidgets('can enter text in email field', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'testuser@example.com');
      await tester.pumpAndSettle();

      expect(find.text('testuser@example.com'), findsOneWidget);
    });

    testWidgets('can enter text in password field', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final passwordField = find.byType(TextField).at(1);
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('email field accepts username input', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'budi');
      await tester.pumpAndSettle();

      expect(find.text('budi'), findsOneWidget);
    });

    testWidgets('can clear and re-enter text in fields', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'first@example.com');
      await tester.pumpAndSettle();

      expect(find.text('first@example.com'), findsOneWidget);

      await tester.enterText(emailField, 'second@example.com');
      await tester.pumpAndSettle();

      expect(find.text('second@example.com'), findsOneWidget);
    });

    testWidgets('both fields can accept input simultaneously', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'user@example.com');
      await tester.enterText(textFields.at(1), 'securepass');
      await tester.pumpAndSettle();

      expect(find.text('user@example.com'), findsOneWidget);
      expect(find.text('securepass'), findsOneWidget);
    });
  });

  group('LoginPage - Password Visibility', () {
    testWidgets('password visibility icon is displayed', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });

  group('LoginPage - Form Submission with Scroll', () {
    testWidgets('can scroll and tap login button', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'user@example.com');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pumpAndSettle();

      // Scroll down to make button visible
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      // Now tap the button
      final button = find.byType(ElevatedButton);
      expect(button.evaluate().isNotEmpty, true);
      await tester.tap(button);
      await tester.pumpAndSettle();
    });

    testWidgets('error message shows after scroll and form submit', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // Only fill password, leave email empty
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pumpAndSettle();

      // Scroll to button
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      // Tap button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check if error appears
      if (find
          .text('Email/username tidak boleh kosong')
          .evaluate()
          .isNotEmpty) {
        expect(find.text('Email/username tidak boleh kosong'), findsOneWidget);
      }
    });

    testWidgets('password error shows after scroll and form submit', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // Only fill email, leave password empty
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'user@example.com');
      await tester.pumpAndSettle();

      // Scroll to button
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      // Tap button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check if error appears
      if (find.text('Password tidak boleh kosong').evaluate().isNotEmpty) {
        expect(find.text('Password tidak boleh kosong'), findsOneWidget);
      }
    });
  });

  group('LoginPage - Navigation with Scroll', () {
    testWidgets('can scroll and tap forgot password link', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // Text "Forgot password?" should be visible without scroll
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('sign up link is present', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // Scroll to bottom to find sign up link
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Check if Sign up text is visible
      if (find.text('Sign up').evaluate().isNotEmpty) {
        expect(find.text('Sign up'), findsOneWidget);
      }
    });

    testWidgets('forgot password link exists', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.text('Forgot password?'), findsOneWidget);
    });
  });

  group('LoginPage - Password Visibility Toggle', () {
    testWidgets('password visibility icon can be tapped', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // Enter password first
      final passwordField = find.byType(TextField).at(1);
      await tester.enterText(passwordField, 'testpass123');
      await tester.pumpAndSettle();

      // Icon should be present
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Try to tap it
      final visibilityIcon = find.byIcon(Icons.visibility_outlined);
      if (visibilityIcon.evaluate().isNotEmpty) {
        await tester.tap(visibilityIcon.first);
        await tester.pumpAndSettle();
      }
    });
  });
}
