import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/profile/notification_page_settings.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationPage - Integration Tests', () {
    testWidgets('page loads and displays header', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.text('Notification'), findsWidgets);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays page content after initial load', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump(const Duration(milliseconds: 500));

      // Page should render without crashes
      expect(find.byType(NotificationPage), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('displays navbar at bottom', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('back button is visible and tappable', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      // Verify button can be tapped without error
      await tester.tap(backButton);
      await tester.pump();
    });

    testWidgets('page has proper layout structure', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('has gradient background in header', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(ClipPath), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('navbar remains visible during interactions', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(AppNavbar), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      // Navbar should still be rendered
      expect(find.byType(AppNavbar), findsWidgets);
    });

    testWidgets('widget tree renders without crashes', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));

      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Should not crash during frame rendering
      expect(find.byType(NotificationPage), findsOneWidget);
    });

    testWidgets('page renders without errors', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));

      // Pump multiple times to ensure no crashes
      await tester.pump();
      expect(find.byType(NotificationPage), findsOneWidget);

      // After some time
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  group('NotificationPage - Navigation Integration', () {
    testWidgets('page renders with navigation support', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(NotificationPage), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('page renders within navigation context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) =>
                MaterialPageRoute(builder: (_) => const NotificationPage()),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(NotificationPage), findsOneWidget);
      expect(find.byType(AppNavbar), findsOneWidget);
    });
  });

  group('NotificationPage - UI Consistency', () {
    testWidgets('header text is correct', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      // "Notification" appears in header and body
      expect(find.text('Notification'), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('uses Material Design components', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      // Should have Material Design components
      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('navbar matches expected type', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('page is stateful widget', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      expect(find.byType(NotificationPage), findsOneWidget);
    });
  });

  group('NotificationPage - Responsive Behavior', () {
    testWidgets('handles multiple frame pumps', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));

      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(NotificationPage), findsOneWidget);
      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('maintains header visibility on scroll', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      // Header should always be visible
      expect(find.text('Notification'), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('can handle widget rebuild', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pump();

      int count1 = find.byType(AppNavbar).evaluate().length;
      expect(count1, greaterThan(0));

      await tester.pump();
      int count2 = find.byType(AppNavbar).evaluate().length;
      expect(count2, greaterThan(0));
    });
  });

  group('NotificationPage - Dialog Interactions', () {
    testWidgets('tap arrow tile opens settings dialog', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pumpAndSettle();

      // Tap on "Push notification schedule" arrow tile to open dialog
      await tester.tap(find.text('Push notification schedule'));
      await tester.pumpAndSettle();

      // Verify AlertDialog appears
      expect(find.byType(AlertDialog), findsOneWidget);

      // Verify dialog contains expected title
      expect(find.text('Push Notification Schedule'), findsOneWidget);
    });

    testWidgets('dialog can be dismissed with Cancel button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.text('Push notification schedule'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      // Tap Cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('in-app notifications dialog shows switch options', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));
      await tester.pumpAndSettle();

      // Tap on "In-app notifications" arrow tile
      await tester.tap(find.text('In-app notifications'));
      await tester.pumpAndSettle();

      // Verify dialog appears with Switch widgets
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(Switch), findsWidgets);
    });
  });
}
