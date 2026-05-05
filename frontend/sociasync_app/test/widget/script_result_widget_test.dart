import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/content_generator/script_result_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
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

  setUp(() {
    SystemChannels.platform.setMockMethodCallHandler((call) async {
      if (call.method == 'Clipboard.setData') {
        return null;
      }
      return null;
    });
  });

  tearDown(() {
    SystemChannels.platform.setMockMethodCallHandler(null);
  });

  Future<void> pumpScriptResultPage(WidgetTester tester) async {
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

  group('ScriptResultPage Widget Tests', () {
    testWidgets('menampilkan header dan judul ide', (tester) async {
      await pumpScriptResultPage(tester);

      expect(find.text('Video Content Script'), findsOneWidget);
      expect(find.text('Skincare Routine'), findsOneWidget);
      expect(find.text('Start with a quick skin check.'), findsOneWidget);
    });

    testWidgets('menampilkan timeline HOOK, BODY, CTA dan waktu', (
      tester,
    ) async {
      await pumpScriptResultPage(tester);

      expect(find.text('HOOK'), findsOneWidget);
      expect(find.text('BODY'), findsOneWidget);
      expect(find.text('CTA'), findsOneWidget);
      expect(find.text('00:00 - 00:03'), findsOneWidget);
      expect(find.text('00:03 - 00:08'), findsOneWidget);
      expect(find.text('00:08 - 00:12'), findsOneWidget);
    });

    testWidgets('menampilkan tombol method pada halaman script result', (
      tester,
    ) async {
      await pumpScriptResultPage(tester);

      expect(find.text('Copy Full Script'), findsOneWidget);
      expect(find.text('Generate Other Script'), findsOneWidget);
      expect(find.text('Generate Caption + Hashtag'), findsOneWidget);
    });

    testWidgets('copyFullScript menampilkan snackbar', (tester) async {
      await pumpScriptResultPage(tester);

      final copyFullButton = find.text('Copy Full Script');
      expect(copyFullButton, findsOneWidget);

      await tester.ensureVisible(copyFullButton);
      await tester.tap(copyFullButton);
      await tester.pumpAndSettle();

      expect(find.text('Full script copied!'), findsOneWidget);
    });

    testWidgets('copySingle menampilkan snackbar untuk HOOK', (tester) async {
      await pumpScriptResultPage(tester);

      final copyIcon = find.byIcon(Icons.copy_outlined).first;
      expect(copyIcon, findsOneWidget);

      await tester.ensureVisible(copyIcon);
      await tester.tap(copyIcon);
      await tester.pumpAndSettle();

      expect(find.text('Copied!'), findsOneWidget);
    });

    testWidgets('menampilkan AppNavbar di halaman', (tester) async {
      await pumpScriptResultPage(tester);

      expect(find.byType(AppNavbar), findsOneWidget);
    });
  });
}
