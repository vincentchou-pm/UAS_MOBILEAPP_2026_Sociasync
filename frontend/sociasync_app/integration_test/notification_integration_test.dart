import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/test_main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Notification Integration Test', () {
    testWidgets(
      'Splashscreen -> Login -> Open Notification -> Back to Dashboard',
      (WidgetTester tester) async {
        // =========================================================
        // 1. START APP (TEST MODE)
        // =========================================================
        app.main();

        await tester.pumpAndSettle(const Duration(seconds: 5));

        // =========================================================
        // 2. LOGIN
        // =========================================================

        final textFields = find.byType(TextField);

        expect(textFields, findsAtLeastNWidgets(2));

        await tester.enterText(textFields.at(0), 'vincentzero24@gmail.com');

        await tester.enterText(textFields.at(1), 'U12345678');

        await tester.pumpAndSettle(const Duration(seconds: 1));

        final loginButton = find.widgetWithText(ElevatedButton, 'Login');

        expect(loginButton, findsOneWidget);

        await tester.ensureVisible(loginButton);

        await tester.tap(loginButton);

        // wait dashboard
        await tester.pumpAndSettle(const Duration(seconds: 15));

        // =========================================================
        // 3. VERIFY DASHBOARD
        // =========================================================

        expect(find.byType(Scaffold), findsWidgets);

        // DashboardHeader exists
        expect(find.byTooltip('Notifications'), findsOneWidget);

        // =========================================================
        // 4. OPEN NOTIFICATION PAGE
        // =========================================================

        final notificationButton = find.byTooltip('Notifications');

        await tester.tap(notificationButton);

        await tester.pumpAndSettle(const Duration(seconds: 5));

        // =========================================================
        // 5. VERIFY NOTIFICATION PAGE
        // =========================================================

        expect(find.text('Notification'), findsOneWidget);

        expect(find.byType(ListView), findsWidgets);

        // =========================================================
        // 6. HANDLE LOADING
        // =========================================================

        if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
          await tester.pumpAndSettle(const Duration(seconds: 5));
        }

        // =========================================================
        // 7. VERIFY NOTIFICATION CONTENT
        // =========================================================

        final emptyText = find.text('Belum ada notifikasi.');

        final listView = find.byType(ListView);

        expect(
          emptyText.evaluate().isNotEmpty || listView.evaluate().isNotEmpty,
          isTrue,
        );

        // =========================================================
        // 8. SCROLL NOTIFICATION LIST
        // =========================================================

        if (listView.evaluate().isNotEmpty) {
          await tester.drag(listView.first, const Offset(0, -300));

          await tester.pumpAndSettle();

          await tester.drag(listView.first, const Offset(0, 300));

          await tester.pumpAndSettle();
        }

        // =========================================================
        // 9. PRESS HOME BUTTON IN NAVBAR
        // =========================================================

        final homeButton = find.byTooltip('Menu 1');

        expect(homeButton, findsOneWidget);

        await tester.tap(homeButton);

        await tester.pumpAndSettle(const Duration(seconds: 5));

        // =========================================================
        // 10. VERIFY BACK TO DASHBOARD
        // =========================================================

        expect(find.byKey(const Key('notification_button')), findsOneWidget);
      },
    );
  });
}
