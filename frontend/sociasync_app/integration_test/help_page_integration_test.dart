import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/profile/help_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HelpPage - Integration Tests - Navigation', () {
    testWidgets('klik back button kembali ke halaman sebelumnya', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.text('Help'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should navigate back
      expect(find.byType(HelpPage), findsNothing);
    });
  });

  group('HelpPage - Integration Tests - User Interactions', () {
    testWidgets('tap topic, baca konten, kemudian tutup dialog', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      // Tap Account Growth topic
      await tester.tap(find.text('Account growth'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(
        find.text(
          'Growing your account on SociaSync takes consistency and strategy',
        ),
        findsOneWidget,
      );

      // Close dialog dengan Got it button
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('buka dialog dan tutup dengan X button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      // Tap Forgot my password topic
      await tester.tap(find.text('Forgot my password'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      // Close dialog dengan X button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('scroll melalui multiple topics dan buka beberapa dialog', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      // Open Account Growth
      await tester.tap(find.text('Account growth'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      // Open Analytics Formula
      await tester.tap(find.text('Analytics formula (Engagement & Reach)'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      // Open Account Safety
      await tester.tap(find.text('Account safety'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('scroll konten dialog yang panjang', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      // Open a topic with long content
      await tester.tap(find.text('Account safety'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      // Try to scroll the dialog content
      final scrollableContent = find.descendant(
        of: find.byType(Dialog),
        matching: find.byType(SingleChildScrollView),
      );

      if (scrollableContent.evaluate().isNotEmpty) {
        await tester.drag(scrollableContent.first, const Offset(0, -500));
        await tester.pumpAndSettle();
      }

      expect(find.byType(Dialog), findsOneWidget);
    });
  });

  group('HelpPage - Integration Tests - Search and Filter', () {
    testWidgets('scroll list melihat semua topics', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      // Scroll down to see all topics
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unable to follow a user'), findsOneWidget);
    });

    testWidgets('semua topics dapat diklik dan menampilkan dialog', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      final topics = [
        'Account growth',
        'Analytics formula (Engagement & Reach)',
        'Your account status',
        'Account safety',
        'Updating name',
        'Forgot my password',
        'Editing, posting, and deleting',
        'Searching for content',
        'Unable to follow a user',
      ];

      for (final topic in topics) {
        // Scroll to ensure the topic is visible and centered in view
        final finder = find.text(topic);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();

        // For the last few items, add extra scroll to avoid navbar overlap
        if (topics.indexOf(topic) >= topics.length - 2) {
          await tester.drag(
            find.byType(SingleChildScrollView).first,
            const Offset(0, -50),
          );
          await tester.pumpAndSettle();
        }

        // Tap the topic
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Verify dialog appears with topic title
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text(topic), findsWidgets);

        // Close dialog
        await tester.tap(find.text('Got it'));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsNothing);
      }
    });
  });

  group('HelpPage - Integration Tests - UI Consistency', () {
    testWidgets('header selalu visible saat scroll', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      expect(find.text('Help'), findsOneWidget);

      // Scroll down
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Header should still be visible
      expect(find.text('Help'), findsOneWidget);
    });

    testWidgets('navbar selalu visible di bottom', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpPage()));

      await tester.pumpAndSettle();

      // Find navbar at the bottom
      final navbar = find.byType(AppNavbar);
      expect(navbar, findsOneWidget);

      // Scroll down
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Navbar should still be visible
      expect(navbar, findsOneWidget);
    });
  });
}
