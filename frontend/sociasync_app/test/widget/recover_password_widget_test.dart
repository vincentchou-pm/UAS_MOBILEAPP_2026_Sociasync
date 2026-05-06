import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/auth/recover_password_page.dart';

void main() {
  group('RecoverPasswordPage - UI Rendering', () {
    testWidgets('page renders with all required elements', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      expect(find.text('Reset Password'), findsWidgets); // Title + Button
      expect(find.text('Email/username'), findsOneWidget);
      expect(find.text('Code'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm New Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Send Code'), findsOneWidget);
    });

    testWidgets('all text input fields are present', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      expect(find.byType(TextField), findsWidgets);
    });
  });

  group('RecoverPasswordPage - Text Input', () {
    testWidgets('can enter email/username', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      final emailFields = find.byType(TextField);
      await tester.enterText(emailFields.first, 'user@example.com');
      await tester.pumpAndSettle();

      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('can enter recovery code', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      final codeField = find.byType(TextField).at(1);
      await tester.enterText(codeField, '123456');
      await tester.pumpAndSettle();

      expect(find.text('123456'), findsOneWidget);
    });

    testWidgets('can enter new password', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      final newPasswordField = find.byType(TextField).at(2);
      await tester.enterText(newPasswordField, 'NewPassword123');
      await tester.pumpAndSettle();

      expect(find.text('NewPassword123'), findsOneWidget);
    });

    testWidgets('can enter confirm password', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -250),
      );
      await tester.pumpAndSettle();

      final confirmPasswordField = find.byType(TextField).at(3);
      await tester.enterText(confirmPasswordField, 'NewPassword123');
      await tester.pumpAndSettle();

      expect(find.text('NewPassword123'), findsWidgets);
    });

    testWidgets('can clear and re-enter field values', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'first@email.com');
      await tester.pumpAndSettle();

      await tester.enterText(emailField, 'second@email.com');
      await tester.pumpAndSettle();

      expect(find.text('second@email.com'), findsOneWidget);
    });
  });

  group('RecoverPasswordPage - Button Interactions', () {
    testWidgets('send code button is accessible', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      expect(find.text('Send Code'), findsOneWidget);
    });

    testWidgets('can scroll and tap reset button', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('RecoverPasswordPage - Complete Flow', () {
    testWidgets('can fill all fields and reach submit button', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      await tester.enterText(find.byType(TextField).first, 'user@example.com');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(1), '123456');
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(2), 'NewPassword123');
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(3), 'NewPassword123');
      await tester.pumpAndSettle();

      expect(find.text('user@example.com'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
      expect(find.text('NewPassword123'), findsWidgets);
    });
  });

  group('RecoverPasswordPage - Gesture Detector', () {
    testWidgets('gesture detectors are present', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      await tester.pumpWidget(const MaterialApp(home: RecoverPasswordPage()));

      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
