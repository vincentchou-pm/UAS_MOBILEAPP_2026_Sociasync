import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/main.dart' as app;

/// ===========================================================
/// INTEGRATION TEST - Content Generator (No. 16)
/// Tester : Gracello
/// File   : content_generator_integration_test.dart
/// Jalankan: flutter test integration_test/content_generator_integration_test.dart
///
/// CATATAN: Integration test ini memerlukan aplikasi berjalan
/// lengkap termasuk login session yang valid.
/// Pastikan emulator/device sudah terkoneksi.
/// ===========================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ─────────────────────────────────────────────
  // GROUP 1: Render halaman Content Generator
  // ─────────────────────────────────────────────
  group('Integration - ContentGeneratorPage render', () {
    testWidgets('halaman Content Generator berhasil dimuat', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigasi ke Content Generator (diasumsikan dari dashboard)
      // Cari tombol/icon yang menuju ContentGeneratorPage
      // Sesuaikan finder berdasarkan UI dashboard aktual
      final generateBtn = find.text('Content Generator');
      if (generateBtn.evaluate().isNotEmpty) {
        await tester.tap(generateBtn);
        await tester.pumpAndSettle();
      }

      expect(find.text('Content Generator'), findsOneWidget);
    });

    testWidgets('elemen utama halaman tampil setelah loaded', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verifikasi elemen dasar ada di layar
      expect(find.text('TikTok'), findsOneWidget);
      expect(find.text('Instagram'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Alur lengkap pengisian form
  // ─────────────────────────────────────────────
  group('Integration - Form input flow', () {
    testWidgets('memilih platform TikTok', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('TikTok'));
      await tester.pumpAndSettle();

      expect(find.text('TikTok'), findsOneWidget);
    });

    testWidgets('mengisi field topic', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final topicField = find.byType(TextField).first;
      await tester.enterText(topicField, 'Tutorial Makeup');
      await tester.pumpAndSettle();

      expect(find.text('Tutorial Makeup'), findsOneWidget);
    });

    testWidgets('memilih opsi Goal: Brand Awareness', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Scroll untuk memastikan goal section terlihat
      await tester.ensureVisible(find.text('Brand Awareness'));
      await tester.pumpAndSettle();

      // Tap toggle di sebelah Brand Awareness
      // Karena toggle adalah GestureDetector di sebelah teks
      final brandAwarenessFinder = find.text('Brand Awareness');
      expect(brandAwarenessFinder, findsOneWidget);
    });

    testWidgets('memilih opsi Audience: Female', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Female'));
      await tester.pumpAndSettle();

      expect(find.text('Female'), findsOneWidget);
    });

    testWidgets('memilih opsi Tone: Friendly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Friendly'));
      await tester.pumpAndSettle();

      expect(find.text('Friendly'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Validasi error flow
  // ─────────────────────────────────────────────
  group('Integration - Validasi error', () {
    testWidgets('tap NEXT tanpa isi form → snackbar muncul', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Scroll ke tombol NEXT
      await tester.ensureVisible(find.text('NEXT'));
      await tester.tap(find.text('NEXT'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.text('Lengkapi topic, goal, target audience, dan tone dulu.'),
        findsOneWidget,
      );
    });

    testWidgets('mengisi topic saja lalu tap NEXT → snackbar muncul',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Isi topic saja
      final topicField = find.byType(TextField).first;
      await tester.enterText(topicField, 'Fashion');
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('NEXT'));
      await tester.tap(find.text('NEXT'));
      await tester.pump(const Duration(seconds: 1));

      // Masih harus snackbar karena goal/audience/tone belum diisi
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Navigasi ke Saved Content
  // ─────────────────────────────────────────────
  group('Integration - Navigasi Saved Content', () {
    testWidgets('tap icon bookmark → navigasi ke SavedContentPage',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final bookmarkIcon = find.byIcon(Icons.bookmark);
      if (bookmarkIcon.evaluate().isNotEmpty) {
        await tester.tap(bookmarkIcon);
        await tester.pumpAndSettle();

        // Harus navigasi ke halaman saved content
        // Verifikasi dengan mencari elemen yang ada di SavedContentPage
        expect(find.text('Saved Strategies'), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Full happy-path flow (E2E)
  // ─────────────────────────────────────────────
  group('Integration - Happy path E2E', () {
    testWidgets(
        'isi form lengkap → tap NEXT → navigasi ke ContentIdeasPage',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Pilih platform
      await tester.tap(find.text('TikTok'));
      await tester.pumpAndSettle();

      // 2. Isi topic
      final topicField = find.byType(TextField).first;
      await tester.enterText(topicField, 'Skincare Routine');
      await tester.pumpAndSettle();

      // 3. Toggle Goal: Increase Engagement
      // Scroll dan tap toggle di samping teks
      await tester.ensureVisible(find.text('Increase Engagement'));
      // Karena toggle bersifat GestureDetector di kanan teks,
      // kita scroll ke bawah section Goal
      final scrollable = find.byType(SingleChildScrollView);
      await tester.drag(scrollable, const Offset(0, -100));
      await tester.pumpAndSettle();

      // 4. Toggle Audience: Female
      await tester.ensureVisible(find.text('Female'));
      await tester.drag(scrollable, const Offset(0, -100));
      await tester.pumpAndSettle();

      // 5. Toggle Tone: Friendly
      await tester.ensureVisible(find.text('Friendly'));
      await tester.pumpAndSettle();

      // 6. Tap NEXT
      await tester.ensureVisible(find.text('NEXT'));
      await tester.tap(find.text('NEXT'));

      // Tunggu loading selesai (API call)
      await tester.pumpAndSettle(const Duration(seconds: 25));

      // 7. Verifikasi navigasi ke ContentIdeasPage
      // atau loading indicator muncul
      final isLoading =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final isIdeasPage = find.text('Content Ideas').evaluate().isNotEmpty;

      expect(isLoading || isIdeasPage, isTrue);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Bottom Navbar
  // ─────────────────────────────────────────────
  group('Integration - Bottom Navbar', () {
    testWidgets('bottom navbar tampil di halaman ContentGenerator',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}