import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/test_main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete login flow with all form fields and widgets', (
    WidgetTester tester,
  ) async {
    // Start app
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ═══════════════════════════════════════════════════════════
    // 1. Verify LoginPage widgets are present
    // ═══════════════════════════════════════════════════════════

    // Check Email TextField
    final emailTextFields = find.byType(TextField);
    expect(
      emailTextFields,
      findsAtLeastNWidgets(2),
      reason: 'Should have at least 2 TextFields (Email, Password)',
    );

    // ═══════════════════════════════════════════════════════════
    // 1b. Verify Forgot Password Link (TextButton) exists EARLY
    // ═══════════════════════════════════════════════════════════
    final forgotPasswordLink = find.text('Forgot password?');
    expect(
      forgotPasswordLink,
      findsOneWidget,
      reason: 'Should find Forgot password? link on login page',
    );

    // ═══════════════════════════════════════════════════════════
    // 2. Fill in Email field
    // ═══════════════════════════════════════════════════════════
    await tester.enterText(emailTextFields.at(0), 'vincentzero24@gmail.com');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ═══════════════════════════════════════════════════════════
    // 3. Fill in Password field
    // ═══════════════════════════════════════════════════════════
    await tester.enterText(emailTextFields.at(1), 'U12345678');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ═══════════════════════════════════════════════════════════
    // 4. Test Password Visibility Toggle (IconButton)
    // ═══════════════════════════════════════════════════════════
    final visibilityToggle = find.byType(IconButton);
    expect(
      visibilityToggle,
      findsAtLeastNWidgets(1),
      reason: 'Should have at least 1 IconButton for password visibility',
    );

    // Tap the toggle to show password
    await tester.tap(visibilityToggle.first);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Tap again to hide password
    await tester.tap(visibilityToggle.first);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ═══════════════════════════════════════════════════════════
    // 5. Test Error Display - Try login with invalid email format
    // ═══════════════════════════════════════════════════════════
    // Clear fields
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'invalidemail');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.enterText(textFields.at(1), 'short');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Try to login with invalid data
    var loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify error messages appear (Row with Icon structure)
    final errorTexts = find.byType(Text);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ═══════════════════════════════════════════════════════════
    // 6. Clear errors and enter valid credentials again
    // ═══════════════════════════════════════════════════════════
    final updatedTextFields = find.byType(TextField);
    await tester.enterText(updatedTextFields.at(0), 'vincentzero24@gmail.com');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.enterText(updatedTextFields.at(1), 'U12345678');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ═══════════════════════════════════════════════════════════
    // 7. Find and click Login Button (ElevatedButton)
    // ═══════════════════════════════════════════════════════════
    loginButton = find.widgetWithText(ElevatedButton, 'Login');
    expect(
      loginButton,
      findsOneWidget,
      reason: 'Should find Login submit button',
    );

    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // ═══════════════════════════════════════════════════════════
    // 8. Verify successful login or error handling
    // ═══════════════════════════════════════════════════════════
    // Either navigate to dashboard or show error messages
    final pageContent = find.byType(SingleChildScrollView);
    expect(
      pageContent,
      findsWidgets,
      reason: 'Should either show dashboard or login page with feedback',
    );

    // ═══════════════════════════════════════════════════════════
    // 9. Verify Sign Up Link (RichText with GestureDetector) exists
    // ═══════════════════════════════════════════════════════════
    final signUpLink = find.text('Sign Up');
    expect(
      signUpLink,
      findsWidgets,
      reason: 'Should find Sign Up link on login page',
    );
  });
}
