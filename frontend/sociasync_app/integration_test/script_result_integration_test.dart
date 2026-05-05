import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/content_generator/script_result_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration - Script Result Page', () {
    const requestData = {
      'platform': 'TikTok',
      'topic': 'Winter Skincare',
      'tone': 'Friendly',
    };

    const selectedIdea = {
      'title': 'Skincare Routine',
      'description': 'Simple steps to glow in winter',
    };

    const scriptData = {
      'hook': 'Start with a quick skin check.',
      'body': 'Show your cleanser, toner, and moisturizer in action.',
      'cta': 'Ask viewers to save this routine for later.',
    };

    Future<void> pumpPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScriptResultPage(
            requestData: requestData,
            selectedIdea: selectedIdea,
            scriptData: scriptData,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('menampilkan header Video Content Script dan judul ide', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.text('Video Content Script'), findsOneWidget);
      expect(find.text('Skincare Routine'), findsOneWidget);
    });

    testWidgets('menampilkan timeline HOOK, BODY, CTA beserta waktu', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.text('HOOK'), findsOneWidget);
      expect(find.text('BODY'), findsOneWidget);
      expect(find.text('CTA'), findsOneWidget);
      expect(find.text('00:00 - 00:03'), findsOneWidget);
      expect(find.text('00:03 - 00:08'), findsOneWidget);
      expect(find.text('00:08 - 00:12'), findsOneWidget);
      expect(
        find.textContaining('Start with a quick skin check.'),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Show your cleanser, toner, and moisturizer in action.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Ask viewers to save this routine for later.'),
        findsOneWidget,
      );
    });

    testWidgets('Copy Full Script button tampil dan menampilkan snackbar', (
      tester,
    ) async {
      await pumpPage(tester);

      final copyFullButton = find.text('Copy Full Script');
      expect(copyFullButton, findsOneWidget);

      await tester.tap(copyFullButton);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Full script copied!'), findsOneWidget);
    });

    testWidgets(
      'tombol Generate Other Script dan Generate Caption + Hashtag ada',
      (tester) async {
        await pumpPage(tester);

        expect(find.text('Generate Other Script'), findsOneWidget);
        expect(find.text('Generate Caption + Hashtag'), findsOneWidget);
      },
    );

    testWidgets('tombol copy timeline HOOK menampilkan snackbar', (
      tester,
    ) async {
      await pumpPage(tester);

      final firstCopyIcon = find.byIcon(Icons.copy_outlined).first;
      expect(firstCopyIcon, findsOneWidget);

      await tester.tap(firstCopyIcon);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Copied!'), findsOneWidget);
    });

    testWidgets('menampilkan AppNavbar di bagian bawah', (tester) async {
      await pumpPage(tester);

      expect(find.byType(AppNavbar), findsOneWidget);
    });
  });
}
