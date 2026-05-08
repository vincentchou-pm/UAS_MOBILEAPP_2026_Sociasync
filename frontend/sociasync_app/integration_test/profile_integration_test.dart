import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/test_main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Integration Test', () {
    testWidgets('Login -> Open Profile -> Verify Components -> Logout Dialog', (
      WidgetTester tester,
    ) async {
      // =========================================================
      // START APP
      // =========================================================
      app.main();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // =========================================================
      // LOGIN
      // =========================================================
      final loginFields = find.byType(TextField);

      expect(loginFields, findsAtLeastNWidgets(2));

      await tester.enterText(loginFields.at(0), 'vincentzero24@gmail.com');

      await tester.enterText(loginFields.at(1), 'U12345678');

      await tester.pumpAndSettle();

      final loginButton = find.widgetWithText(ElevatedButton, 'Login');

      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // =========================================================
      // VERIFY DASHBOARD
      // =========================================================
      final dashboardGreeting = find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText().contains('Hi,'),
      );

      expect(dashboardGreeting, findsOneWidget);

      // =========================================================
      // OPEN PROFILE PAGE
      // =========================================================
      final profileButton = find.byTooltip('Menu 4');

      expect(profileButton, findsOneWidget);

      await tester.tap(profileButton);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // =========================================================
      // VERIFY PROFILE PAGE
      // =========================================================
      expect(find.text('Profile'), findsAtLeastNWidgets(1));

      // =========================================================
      // VERIFY PROFILE HEADER
      // =========================================================
      expect(find.byType(CircleAvatar), findsAtLeastNWidgets(1));

      // =========================================================
      // VERIFY USERNAME
      // =========================================================
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data != null &&
              widget.data!.isNotEmpty &&
              widget.style?.fontSize == 22,
        ),
        findsAtLeastNWidgets(1),
      );

      // =========================================================
      // VERIFY GENERAL SECTION
      // =========================================================
      expect(find.text('GENERAL'), findsOneWidget);

      expect(find.text('Account'), findsOneWidget);

      expect(find.text('Notification'), findsOneWidget);

      // =========================================================
      // VERIFY HELPDESK SECTION
      // =========================================================
      expect(find.text('HELPDESK'), findsOneWidget);

      expect(find.text('Help'), findsOneWidget);

      // =========================================================
      // VERIFY CONNECT SECTION
      // =========================================================
      expect(find.text('CONNECT'), findsOneWidget);

      expect(find.text('TikTok'), findsOneWidget);

      expect(find.text('Instagram'), findsOneWidget);

      // =========================================================
      // VERIFY DANGER ZONE
      // =========================================================
      expect(find.text('DANGER ZONE'), findsOneWidget);

      expect(find.text('Log Out'), findsOneWidget);

      // =========================================================
      // OPEN LOGOUT DIALOG
      // =========================================================
      await tester.scrollUntilVisible(
        find.byKey(const Key('logout_tile')),
        300,
      );

      await tester.tap(find.byKey(const Key('logout_tile')));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to log out?'), findsOneWidget);

      await tester.pumpAndSettle();

      // =========================================================
      // VERIFY LOGOUT DIALOG
      // =========================================================
      expect(find.text('Are you sure you want to log out?'), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);

      expect(find.text('Log Out'), findsAtLeastNWidgets(2));

      // =========================================================
      // CLOSE DIALOG
      // =========================================================
      await tester.tap(find.text('Cancel'));

      await tester.pumpAndSettle();

      // =========================================================
      // FINAL VERIFY
      // =========================================================
      expect(find.text('Profile'), findsAtLeastNWidgets(1));
    });
  });
}
