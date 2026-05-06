import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/main.dart' as app;

/// ===========================================================
/// INTEGRATION TEST - Sign Up Flow (Simplified)
/// Tester : SignUp Integration
/// File   : sign_up_integration_test.dart
/// Jalankan: flutter drive --driver=test_driver/integration_test.dart --target=integration_test/sign_up_integration_test.dart -d emulator-5554
///
/// CATATAN: Smoke tests untuk verify basic signup flow
/// ===========================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ─────────────────────────────────────────────
  // Single test - Complete signup flow
  // ─────────────────────────────────────────────
  testWidgets('Complete signup flow smoke test', (WidgetTester tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 1. Navigate dari LoginPage ke SignUpPage
    final signUpLink = find.text('Sign Up');
    expect(
      signUpLink,
      findsOneWidget,
      reason: 'Should find Sign Up link on login page',
    );

    await tester.tap(signUpLink);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 2. Verify SignUpPage loaded - check for form fields
    final textFields = find.byType(TextField);
    expect(
      textFields,
      findsAtLeastNWidgets(1),
      reason: 'SignUpPage should have at least 1 TextField',
    );

    // 3. Fill in form fields
    if (textFields.evaluate().length >= 2) {
      // Input name
      await tester.enterText(textFields.at(0), 'Integration Test');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Input email
      await tester.enterText(
        textFields.at(1),
        'inttest${DateTime.now().millisecondsSinceEpoch}@test.com',
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    // 4. Select gender
    final maleButton = find.text('Male');
    if (maleButton.evaluate().isNotEmpty) {
      await tester.tap(maleButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    // 5. Select region
    final regionButton = find.text('Select region');
    if (regionButton.evaluate().isNotEmpty) {
      await tester.tap(regionButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final indonesia = find.text('Indonesia');
      if (indonesia.evaluate().isNotEmpty) {
        await tester.tap(indonesia);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
    }

    // 6. Input password fields
    if (textFields.evaluate().length >= 4) {
      await tester.enterText(textFields.at(2), 'Test123!@#');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(textFields.at(3), 'Test123!@#');
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    // 7. Verify page still renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
