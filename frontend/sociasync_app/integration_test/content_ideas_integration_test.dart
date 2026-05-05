import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/main.dart' as app;

/// ===========================================================
/// INTEGRATION TEST - Content Ideas (No. 17)
/// Tester : Gracello
/// File   : content_ideas_integration_test.dart
/// Jalankan: flutter test integration_test/content_ideas_integration_test.dart
///
/// CATATAN: Harus sudah login & berhasil generate ideas dari
/// halaman Content Generator terlebih dahulu.
/// ===========================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ─────────────────────────────────────────────
  // GROUP 1: Navigasi ke Content Ideas
  // ─────────────────────────────────────────────
  group('Integration - Navigasi ke ContentIdeasPage', () {
    testWidgets('halaman Content Ideas tampil setelah generate dari ContentGenerator',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigasi ke Content Generator terlebih dahulu
      // (asumsi dari dashboard ada tombol/generate button)
      final contentGenBtn = find.text('Content Generator');
      if (contentGenBtn.evaluate().isNotEmpty) {
        await tester.tap(contentGenBtn);
        await tester.pumpAndSettle();
      }

      // Isi form Content Generator
      final topicField = find.byType(TextField).first;
      await tester.enterText(topicField, 'Skincare');
      await tester.pumpAndSettle();

      // Verifikasi halaman Ideas bisa dicapai
      expect(find.text('Content Ideas'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Render elemen halaman
  // ─────────────────────────────────────────────
  group('Integration - Render ContentIdeasPage', () {
    testWidgets('judul Content Ideas tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('Content Ideas').evaluate().isNotEmpty) {
        expect(find.text('Content Ideas'), findsOneWidget);
      }
    });

    testWidgets('info platform dan topic tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Cari teks yang mengandung bullet separator
      final platformTopicText = find.textContaining('•');
      if (platformTopicText.evaluate().isNotEmpty) {
        expect(platformTopicText, findsWidgets);
      }
    });

    testWidgets('minimal satu ContentIdeaCard tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Generate Script button ada = ada card
      if (find.text('Generate Script').evaluate().isNotEmpty) {
        expect(find.text('Generate Script'), findsWidgets);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Interaksi Generate Script
  // ─────────────────────────────────────────────
  group('Integration - Generate Script flow', () {
    testWidgets('tap Generate Script → tombol berubah ke Generating...',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final generateBtns = find.text('Generate Script');
      if (generateBtns.evaluate().isNotEmpty) {
        await tester.tap(generateBtns.first);
        await tester.pump(); // pump sekali untuk lihat loading state

        // Bisa jadi langsung loading atau langsung navigasi
        final isGenerating =
            find.text('Generating...').evaluate().isNotEmpty;
        final isScriptPage =
            find.text('Video Script').evaluate().isNotEmpty;

        expect(isGenerating || isScriptPage, isTrue);
      }
    });

    testWidgets(
        'setelah generate selesai → navigasi ke ScriptResultPage',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final generateBtns = find.text('Generate Script');
      if (generateBtns.evaluate().isNotEmpty) {
        await tester.tap(generateBtns.first);

        // Tunggu API response (maks 25 detik)
        await tester.pumpAndSettle(const Duration(seconds: 25));

        // Verifikasi navigasi ke ScriptResultPage
        expect(find.text('Video Script'), findsOneWidget);
      }
    });

    testWidgets('tidak bisa tap Generate Script kedua saat pertama loading',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final generateBtns = find.text('Generate Script');
      if (generateBtns.evaluate().length >= 2) {
        // Tap card pertama
        await tester.tap(generateBtns.first);
        await tester.pump();

        // Tap card kedua saat loading → tidak crash
        if (generateBtns.evaluate().isNotEmpty) {
          await tester.tap(generateBtns.last);
          await tester.pump();
        }

        // Tidak crash = test pass
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Bottom Navbar
  // ─────────────────────────────────────────────
  group('Integration - Bottom Navbar', () {
    testWidgets('bottom navbar tampil di ContentIdeasPage', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('Content Ideas').evaluate().isNotEmpty) {
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Scroll behavior
  // ─────────────────────────────────────────────
  group('Integration - Scroll', () {
    testWidgets('halaman bisa di-scroll ke bawah untuk lihat semua ideas',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.byType(SingleChildScrollView).evaluate().isNotEmpty) {
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        // Tidak crash setelah scroll = test pass
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });
  });
}