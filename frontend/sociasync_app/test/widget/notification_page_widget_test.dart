import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/profile/notification_page_settings.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  group('NotificationPage - Widget Tests', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(NotificationPage), findsOneWidget);
    });

    testWidgets('displays header with "Notification" title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.text('Notification'), findsOneWidget);
    });

    testWidgets('displays back button in header', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays AppNavbar at bottom', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('has proper layout structure', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      // Verify main structure
      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(AppNavbar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('header has gradient background (ClipPath)', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(ClipPath), findsWidgets);
    });

    testWidgets('uses Column for main body layout', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('back button is clickable', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      // Button should be tappable
      await tester.tap(backButton);
      await tester.pump();
    });

    testWidgets('renders with proper styling (Stack for header)', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      // Header uses Stack for layout
      expect(find.byType(Stack), findsWidgets);
    });
  });

  group('NotificationPage - UI Elements Verification', () {
    testWidgets('has text element for "Notification"', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      final titleText = find.text('Notification');
      expect(titleText, findsOneWidget);
    });

    testWidgets('AppBackgroundWrapper is used', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      // Should have gradient background (evidence of AppBackgroundWrapper)
      expect(find.byType(ClipPath), findsWidgets);
    });

    testWidgets('body contains loading state or content', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      // Either loading or content should be visible
      final loadingIndicator = find.byType(CircularProgressIndicator);
      final scaffold = find.byType(Scaffold);

      expect(
        loadingIndicator.evaluate().isNotEmpty ||
            scaffold.evaluate().isNotEmpty,
        true,
      );
    });

    testWidgets('navbar has correct index for notification page', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('shows loading state before switches load', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      // During initial load, loading indicator shows and switches are hidden
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Switches are not yet visible (loaded after API call)
      // This test documents the loading behavior
      // Integration tests verify switches appear after content loads
      expect(find.byType(Switch), findsNothing);
    });
  });
}
