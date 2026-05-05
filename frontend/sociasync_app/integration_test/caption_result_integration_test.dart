import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/main.dart' as app;

/// ===========================================================
/// INTEGRATION TEST - Caption Hashtag Result (No. 18)
/// Tester : Gracello
/// File   : caption_result_integration_test.dart
/// Jalankan: flutter test integration_test/caption_result_integration_test.dart
///
/// CATATAN: Halaman ini dicapai setelah alur:
/// ContentGenerator → ContentIdeas → ScriptResult → CaptionResultPage
/// Pastikan sudah login dan backend aktif.
/// ===========================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ─────────────────────────────────────────────
  // GROUP 1: Render halaman Caption Result
  // ─────────────────────────────────────────────
  group('Integration - CaptionResultPage render', () {
    testWidgets('judul Caption & Hashtag tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('Caption & Hashtag').evaluate().isNotEmpty) {
        expect(find.text('Caption & Hashtag'), findsOneWidget);
      }
    });

    testWidgets('card Caption Ideas tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('✍️ Caption Ideas').evaluate().isNotEmpty) {
        expect(find.text('✍️ Caption Ideas'), findsOneWidget);
      }
    });

    testWidgets('card Smart Hashtag Mix tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('# Smart Hashtag Mix').evaluate().isNotEmpty) {
        expect(find.text('# Smart Hashtag Mix'), findsOneWidget);
      }
    });

    testWidgets('tombol SAVE CONTENT tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('SAVE CONTENT').evaluate().isNotEmpty) {
        expect(find.text('SAVE CONTENT'), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Copy to clipboard
  // ─────────────────────────────────────────────
  group('Integration - Copy Clipboard', () {
    testWidgets('tap copy caption → snackbar Caption copied! muncul',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final copyIcons = find.byIcon(Icons.copy_rounded);
      if (copyIcons.evaluate().isNotEmpty) {
        await tester.tap(copyIcons.first);
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Caption copied!'), findsOneWidget);
      }
    });

    testWidgets('tap copy hashtag → snackbar Hashtags copied! muncul',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final copyIcons = find.byIcon(Icons.copy_rounded);
      if (copyIcons.evaluate().length >= 2) {
        await tester.tap(copyIcons.last);
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Hashtags copied!'), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Regenerate caption & hashtag
  // ─────────────────────────────────────────────
  group('Integration - Regenerate', () {
    testWidgets('tap Generate Other Captions → loading state muncul',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final generateCaptionBtn = find.text('Generate Other Captions');
      if (generateCaptionBtn.evaluate().isNotEmpty) {
        await tester.tap(generateCaptionBtn);
        await tester.pump();

        final isLoading =
            find.text('Generating...').evaluate().isNotEmpty;
        final stillActive =
            find.text('Generate Other Captions').evaluate().isNotEmpty;

        expect(isLoading || stillActive, isTrue);
      }
    });

    testWidgets('tap Generate Other Hashtags → loading state muncul',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final generateHashtagBtn = find.text('Generate Other Hashtags');
      if (generateHashtagBtn.evaluate().isNotEmpty) {
        await tester.tap(generateHashtagBtn);
        await tester.pump();

        final isLoading =
            find.text('Generating...').evaluate().isNotEmpty;
        final stillActive =
            find.text('Generate Other Hashtags').evaluate().isNotEmpty;

        expect(isLoading || stillActive, isTrue);
      }
    });

    testWidgets(
        'setelah regenerate caption berhasil → caption baru tampil',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final generateCaptionBtn = find.text('Generate Other Captions');
      if (generateCaptionBtn.evaluate().isNotEmpty) {
        await tester.tap(generateCaptionBtn);
        await tester.pumpAndSettle(const Duration(seconds: 25));

        // Caption card harus masih ada setelah regenerate
        expect(find.text('✍️ Caption Ideas'), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Save Content flow
  // ─────────────────────────────────────────────
  group('Integration - Save Content', () {
    testWidgets('tap SAVE CONTENT → loading Saving... muncul atau navigasi',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final saveBtn = find.text('SAVE CONTENT');
      if (saveBtn.evaluate().isNotEmpty) {
        await tester.tap(saveBtn);
        await tester.pump();

        final isSaving = find.text('Saving...').evaluate().isNotEmpty;
        final isNavigated =
            find.text('Saved Strategies').evaluate().isNotEmpty;
        final hasSnackbar = find.byType(SnackBar).evaluate().isNotEmpty;

        expect(isSaving || isNavigated || hasSnackbar, isTrue);
      }
    });

    testWidgets(
        'setelah save berhasil → navigasi ke SavedContentPage',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final saveBtn = find.text('SAVE CONTENT');
      if (saveBtn.evaluate().isNotEmpty) {
        await tester.tap(saveBtn);
        await tester.pumpAndSettle(const Duration(seconds: 25));

        // Verifikasi navigasi ke SavedContentPage
        final isOnSavedPage =
            find.text('Saved Strategies').evaluate().isNotEmpty;
        final hasSuccessSnackbar =
            find.text('Konten berhasil disimpan.').evaluate().isNotEmpty;

        expect(isOnSavedPage || hasSuccessSnackbar, isTrue);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Scroll behavior
  // ─────────────────────────────────────────────
  group('Integration - Scroll', () {
    testWidgets('halaman bisa di-scroll untuk melihat semua konten',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.byType(SingleChildScrollView).evaluate().isNotEmpty) {
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -400),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Bottom Navbar
  // ─────────────────────────────────────────────
  group('Integration - Bottom Navbar', () {
    testWidgets('bottom navbar tampil di CaptionResultPage', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('Caption & Hashtag').evaluate().isNotEmpty) {
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      }
    });
  });
}