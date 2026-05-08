import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/test_main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Reminder Integration Test', () {
    testWidgets('Login -> Open Chatbot -> Add Reminder -> Edit -> Complete', (
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
      // OPEN CHATBOT PAGE
      // =========================================================
      final chatbotButton = find.byTooltip('Menu 3');

      expect(chatbotButton, findsOneWidget);

      await tester.tap(chatbotButton);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // =========================================================
      // VERIFY CHATBOT PAGE
      // =========================================================
      expect(find.text('Messages'), findsOneWidget);

      expect(find.text('Sociasync Reminders'), findsOneWidget);

      expect(find.text('Sociasync AI'), findsWidgets);

      // =========================================================
      // OPEN REMINDER TAB
      // =========================================================
      final reminderTab = find.text('Sociasync Reminders');

      expect(reminderTab, findsOneWidget);

      await tester.tap(reminderTab);

      await tester.pumpAndSettle();

      // =========================================================
      // VERIFY REMINDER CONTENT
      // =========================================================
      final addReminderButton = find.text('Tambah');

      if (addReminderButton.evaluate().isEmpty) {
        expect(find.text('Tambah Reminder'), findsOneWidget);

        await tester.tap(find.text('Tambah Reminder'));
      } else {
        expect(addReminderButton, findsOneWidget);

        await tester.tap(addReminderButton);
      }

      await tester.pumpAndSettle();

      // =========================================================
      // VERIFY DIALOG
      // =========================================================
      expect(find.text('Tambah Sociasync Reminder'), findsOneWidget);

      // =========================================================
      // FILL FORM
      // =========================================================
      final formFields = find.byType(TextField);

      expect(formFields, findsAtLeastNWidgets(5));

      // =========================================================
      // 10. FILL REMINDER FORM
      // =========================================================

      final toField = find.widgetWithText(TextField, 'To');
      final messageField = find.widgetWithText(TextField, 'Message');
      final dayField = find.widgetWithText(TextField, 'Day (Contoh: Monday)');

      expect(toField, findsOneWidget);
      expect(messageField, findsOneWidget);
      expect(dayField, findsOneWidget);

      await tester.enterText(toField, 'Mom');
      await tester.pumpAndSettle();

      await tester.enterText(messageField, 'Call mom about the weekend plans');
      await tester.pumpAndSettle();

      await tester.enterText(dayField, 'Friday');
      await tester.pumpAndSettle();

      // =========================================================
      // PICK DATE
      // =========================================================

      final calendarButton = find.byIcon(Icons.calendar_today);

      expect(calendarButton, findsAtLeastNWidgets(1));

      await tester.tap(calendarButton.first);
      await tester.pumpAndSettle();

      final okDate = find.text('OK');

      if (okDate.evaluate().isNotEmpty) {
        await tester.tap(okDate.first);
        await tester.pumpAndSettle();
      }

      // =========================================================
      // PICK TIME
      // =========================================================

      final timeButton = find.byIcon(Icons.access_time);

      expect(timeButton, findsAtLeastNWidgets(1));

      await tester.tap(timeButton.first);
      await tester.pumpAndSettle();

      final okTime = find.text('OK');

      if (okTime.evaluate().isNotEmpty) {
        await tester.tap(okTime.first);
        await tester.pumpAndSettle();
      }

      // =========================================================
      // SAVE REMINDER
      // =========================================================
      final saveButton = find.text('Save');

      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // HANDLE POPUP NOTIFICATION
      final okPopupButton = find.text('OK');

      if (okPopupButton.evaluate().isNotEmpty) {
        await tester.tap(okPopupButton.first);
        await tester.pumpAndSettle();
      }

      // =========================================================
      // VERIFY REMINDER CREATED
      // =========================================================
      expect(find.textContaining('Mom'), findsAtLeastNWidgets(1));

      expect(
        find.textContaining('Call mom about the weekend plans'),
        findsAtLeastNWidgets(1),
      );

      // =========================================================
      // VERIFY BUTTONS EXIST
      // =========================================================

      final editButton = find.text('Edit');
      final completeButton = find.text('Complete');

      expect(editButton, findsAtLeastNWidgets(1));
      expect(completeButton, findsAtLeastNWidgets(1));

      // =========================================================
      // EDIT REMINDER
      // =========================================================

      await tester.tap(editButton.first);
      await tester.pumpAndSettle();

      expect(find.text('Edit Sociasync Reminder'), findsOneWidget);

      final editFields = find.byType(TextField);

      expect(editFields, findsAtLeastNWidgets(5));

      final editMessageField = find.widgetWithText(TextField, 'Message');

      expect(editMessageField, findsOneWidget);

      await tester.enterText(editMessageField, 'UPDATED REMINDER MESSAGE');

      await tester.pumpAndSettle();

      await tester.pumpAndSettle();

      final editSaveButton = find.widgetWithText(TextButton, 'Save');

      expect(editSaveButton, findsOneWidget);

      await tester.tap(editSaveButton);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // =========================================================
      // VERIFY UPDATED TEXT
      // =========================================================
      expect(find.text('UPDATED REMINDER MESSAGE'), findsOneWidget);

      // =========================================================
      // COMPLETE REMINDER
      // =========================================================
      await tester.tap(completeButton.first);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // =========================================================
      // FINAL VERIFY
      // =========================================================
      expect(find.text('Sociasync Reminders'), findsOneWidget);
    });
  });
}
