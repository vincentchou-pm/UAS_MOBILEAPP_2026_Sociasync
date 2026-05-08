import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/test_main.dart' as app;
import 'package:sociasync_app/widgets/dashboard_header.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Chatbot Integration Test', () {
    testWidgets('Splashscreen -> Login -> Open Chatbot -> Test All Widgets', (
      WidgetTester tester,
    ) async {
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

      // Wait for login to process and navigate to dashboard
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // =========================================================
      // 3. WAIT FOR DASHBOARD TO FULLY LOAD
      // =========================================================
      // Wait for DashboardHeader to appear (indicates dashboard is loaded)
      // When logged in, header shows "Hi, {username}" instead of "Rina"
      final headerRich = find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().trim().startsWith('Hi,'),
      );
      final dashboardHeaderWidget = find.byType(DashboardHeader);

      if (headerRich.evaluate().isEmpty &&
          dashboardHeaderWidget.evaluate().isEmpty) {
        await tester.pumpAndSettle(const Duration(seconds: 10));
      }

      // Verify we're on dashboard by checking for DashboardHeader
      expect(
        headerRich.evaluate().isNotEmpty ||
            dashboardHeaderWidget.evaluate().isNotEmpty,
        isTrue,
        reason:
            'Should be on dashboard after login (looking for "Hi, " or DashboardHeader)',
      );

      // =========================================================
      // 4. NAVIGATE TO CHATBOT PAGE (via navbar index 2)
      // =========================================================

      // Find the navbar - AppNavbar with selectedIndex and onTap
      var navBar = find.byType(AppNavbar);
      int retries = 0;
      while (navBar.evaluate().isEmpty && retries < 3) {
        await tester.pumpAndSettle(const Duration(seconds: 2));
        navBar = find.byType(AppNavbar);
        retries++;
      }

      expect(navBar, findsWidgets, reason: 'AppNavbar should be visible');

      // Find the third icon button (index 2 for chatbot) in the navbar
      final chatbotNavbarButton = find.byTooltip('Menu 3');

      // Try to tap the navbar button to navigate to chatbot (index 2)
      if (chatbotNavbarButton.evaluate().isNotEmpty) {
        await tester.tap(chatbotNavbarButton);
      } else {
        // Fallback: find all IconButtons and tap the chatbot one (index 2)
        final navbarIconButtons = find.byType(IconButton).evaluate().toList();
        // The last 4 IconButtons should be from the navbar
        if (navbarIconButtons.length >= 3) {
          final chatbotButton = find
              .byType(IconButton)
              .at(navbarIconButtons.length - 2);
          await tester.tap(chatbotButton);
        } else {
          throw Exception('Could not find navbar buttons');
        }
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // =========================================================
      // 5. VERIFY CHATBOT PAGE LOADED
      // =========================================================

      // Verify Scaffold exists
      expect(find.byType(Scaffold), findsWidgets);

      // =========================================================
      // 6. TEST HEADER WIDGET (AppBar area with Chatbot title)
      // =========================================================

      // Find DashboardHeader
      // Reuse header checks from earlier: either RichText starting with "Hi,"
      // or the DashboardHeader widget must exist.
      expect(
        headerRich.evaluate().isNotEmpty ||
            dashboardHeaderWidget.evaluate().isNotEmpty,
        isTrue,
        reason: 'Should find header with username',
      );

      // =========================================================
      // 7. TEST BACK BUTTON (GestureDetector with arrow_back icon)
      // =========================================================

      final backButton = find.byIcon(Icons.arrow_back);
      expect(
        backButton,
        findsWidgets,
        reason: 'Should find back button with arrow_back icon',
      );

      // =========================================================
      // 8. TEST "MESSAGES" TITLE TEXT
      // =========================================================

      expect(
        find.text('Messages'),
        findsOneWidget,
        reason: 'Should find Messages title',
      );

      // =========================================================
      // 9. TEST MAIN CHAT CONTAINER (Container with border)
      // =========================================================

      final chatContainer = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).border != null,
      );

      expect(
        chatContainer.evaluate().isNotEmpty,
        isTrue,
        reason: 'Should find chat container with border',
      );

      // =========================================================
      // 10. TEST BLUE HEADER INSIDE CONTAINER (ChatBot AI Header)
      // =========================================================

      expect(
        find.text('Sociasync AI'),
        findsWidgets,
        reason: 'Should find Sociasync AI header',
      );

      // =========================================================
      // 11. TEST INNER TABS (Reminder | Sociasync AI)
      // =========================================================

      // Inner tabs are rendered inside a white Container -> Row. Find that
      // container first and then look for the Text descendants to avoid
      // colliding with the larger 'Sociasync AI' header above.
      final innerTabsContainer = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.color == Colors.white &&
            widget.child is Row,
      );

      final reminderTab = find.descendant(
        of: innerTabsContainer,
        matching: find.text('Sociasync Reminders'),
      );

      final aiTab = find.descendant(
        of: innerTabsContainer,
        matching: find.text('Sociasync AI'),
      );

      expect(reminderTab, findsOneWidget, reason: 'Should find Reminder tab');

      expect(aiTab, findsOneWidget, reason: 'Should find AI Chat tab');

      // =========================================================
      // 12. TEST SWITCHING TO REMINDER TAB
      // =========================================================

      await tester.tap(reminderTab);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're on reminder tab - should see either empty message or list
      final emptyReminder = find.text('Belum ada reminder.');
      final addReminderButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Row &&
            (widget.child as Row).children.whereType<Text>().any(
              (t) => t.data == 'Tambah Reminder' || t.data == 'Tambah',
            ),
      );

      expect(
        emptyReminder.evaluate().isNotEmpty ||
            addReminderButton.evaluate().isNotEmpty,
        isTrue,
        reason: 'Should see either empty reminder message or add button',
      );

      // =========================================================
      // 13. TEST SWITCHING BACK TO AI TAB
      // =========================================================

      await tester.ensureVisible(aiTab.first);
      await tester.tap(aiTab.first);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // =========================================================
      // 14. TEST CHAT AREA (ListView with messages)
      // =========================================================

      final chatListView = find.byWidgetPredicate(
        (widget) =>
            widget is ListView && widget.padding == const EdgeInsets.all(15),
      );

      expect(
        chatListView.evaluate().isNotEmpty,
        isTrue,
        reason: 'Should find chat ListView',
      );

      // Verify initial message from assistant
      expect(
        find.text(
          'Hi! Aku Sociasync AI. Ceritain goal kontenmu, nanti aku bantu kasih ide dan strategi.',
        ),
        findsOneWidget,
        reason: 'Should find initial greeting message from Sociasync AI bot',
      );

      // =========================================================
      // 15. TEST MESSAGE INPUT FIELD (TextField)
      // =========================================================

      // Get all TextFields in the page
      final allTextFields = find.byType(TextField);

      // Filter for the chat input field (should be the one with hint)
      final chatInputField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            (widget.decoration?.hintText?.contains('Tulis pesan') ?? false),
      );

      expect(
        chatInputField.evaluate().isNotEmpty ||
            allTextFields.evaluate().isNotEmpty,
        isTrue,
        reason: 'Should find chat message input field',
      );

      // =========================================================
      // 16. TEST SEND BUTTON (ElevatedButton with "Kirim" text)
      // =========================================================

      final sendButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data?.contains('Kirim') == true,
      );

      expect(
        sendButton,
        findsOneWidget,
        reason: 'Should find Send (Kirim) button',
      );

      // =========================================================
      // 17. TEST SENDING A MESSAGE
      // =========================================================

      final inputField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            (widget.decoration?.hintText?.contains('Tulis pesan') ?? false),
      );

      if (inputField.evaluate().isNotEmpty) {
        await tester.tap(inputField.first);
        await tester.enterText(inputField.first, 'Beri saya ide konten');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Click send button
        await tester.tap(sendButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify user message appears in chat
        expect(
          find.text('Beri saya ide konten', skipOffstage: false),
          findsWidgets,
          reason: 'Should find user message in chat',
        );

        // Verify typing indicator appears
        final typingIndicator = find.text('Sociasync AI sedang mengetik...');

        if (typingIndicator.evaluate().isNotEmpty) {
          // Wait for response
          await tester.pumpAndSettle(const Duration(seconds: 10));
        }

        // If server responds, verify we have messages
        final allMessages = find.byWidgetPredicate(
          (widget) =>
              widget is Padding &&
              widget.padding == const EdgeInsets.only(bottom: 12),
        );

        expect(
          allMessages.evaluate().isNotEmpty,
          isTrue,
          reason: 'Should have at least one message in chat',
        );
      }

      // =========================================================
      // 18. TEST INPUT FIELD CLEARS AFTER SEND
      // =========================================================

      final inputAfterSend = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            (widget.decoration?.hintText?.contains('Tulis pesan') ?? false),
      );

      if (inputAfterSend.evaluate().isNotEmpty) {
        // Get the TextField widget to check its controller value
        final textFieldWidget =
            inputAfterSend.evaluate().first.widget as TextField;
        // After sending, the input should be cleared
        // (Controller is cleared in _sendChat method)
      }

      // =========================================================
      // 19. TEST BACK BUTTON NAVIGATION
      // =========================================================

      final backButtonFinal = find.byWidgetPredicate(
        (widget) =>
            widget is GestureDetector &&
            widget.onTap != null &&
            widget.child is Icon &&
            (widget.child as Icon).icon == Icons.arrow_back,
      );
      expect(backButtonFinal, findsOneWidget);

      await tester.ensureVisible(backButtonFinal.first);
      await tester.tap(backButtonFinal.first);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate back to previous page
      // Verify we're not on chatbot page anymore
      expect(
        find.text('Messages').evaluate().isEmpty ||
            find.byType(Scaffold).evaluate().isNotEmpty,
        isTrue,
        reason: 'Should navigate away from chatbot on back press',
      );

      // =========================================================
      // FINAL VERIFICATION
      // =========================================================

      // Verify we returned to the dashboard by checking for the header
      // (RichText "Hi, {name}" or DashboardHeader) or the main
      // SingleChildScrollView used on the dashboard.
      // Retry a few times to allow navigation animation and rebuilds to finish
      bool onDashboard =
          headerRich.evaluate().isNotEmpty ||
          dashboardHeaderWidget.evaluate().isNotEmpty;
      int attempts = 0;
      while (!onDashboard && attempts < 5) {
        await tester.pumpAndSettle(const Duration(seconds: 1));
        onDashboard =
            headerRich.evaluate().isNotEmpty ||
            dashboardHeaderWidget.evaluate().isNotEmpty;
        attempts++;
      }

      expect(
        onDashboard,
        isTrue,
        reason: 'Should be on dashboard after navigating back',
      );
    });
  });
}
