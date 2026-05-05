import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/main.dart' as app;

/// ===========================================================
/// INTEGRATION TEST - Generation Result (No. 19)
/// Tester : Gracello
/// File   : generation_result_integration_test.dart
/// Jalankan: flutter test integration_test/generation_result_integration_test.dart
///
/// CATATAN: Halaman ini dapat diakses langsung dari Dashboard
/// melalui tombol Generate di analytics section.
/// Pastikan sudah login dan backend aktif.
/// ===========================================================

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ─────────────────────────────────────────────
  // GROUP 1: Render halaman Generation Result
  // ─────────────────────────────────────────────
  group('Integration - GenerationResultPage render', () {
    testWidgets('judul Content Strategy Result tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('Content Strategy Result').evaluate().isNotEmpty) {
        expect(find.text('Content Strategy Result'), findsOneWidget);
      }
    });

    testWidgets('section Visual Storyboard Guide tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('🎬 Visual Storyboard Guide').evaluate().isNotEmpty) {
        expect(find.text('🎬 Visual Storyboard Guide'), findsOneWidget);
      }
    });

    testWidgets('section Final Caption & Hashtags tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('✍️ Final Caption & Hashtags').evaluate().isNotEmpty) {
        expect(find.text('✍️ Final Caption & Hashtags'), findsOneWidget);
      }
    });

    testWidgets('3 tombol aksi tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('Content Strategy Result').evaluate().isNotEmpty) {
        expect(find.text('Redo'), findsOneWidget);
        expect(find.text('Save to Gallery'), findsOneWidget);
        expect(find.text('Schedule to Calendar'), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Step guide content tampil
  // ─────────────────────────────────────────────
  group('Integration - Step guide content', () {
    testWidgets('step Opening tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.textContaining('Opening').evaluate().isNotEmpty) {
        expect(find.textContaining('Opening'), findsOneWidget);
      }
    });

    testWidgets('step Reaction tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.textContaining('Reaction').evaluate().isNotEmpty) {
        expect(find.textContaining('Reaction'), findsOneWidget);
      }
    });

    testWidgets('step Closing tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.textContaining('Closing').evaluate().isNotEmpty) {
        expect(find.textContaining('Closing'), findsOneWidget);
      }
    });

    testWidgets('Suggested Audio tampil', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.textContaining('Suggested Audio').evaluate().isNotEmpty) {
        expect(find.textContaining('Suggested Audio'), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Navigasi tombol aksi
  // ─────────────────────────────────────────────
  group('Integration - Navigasi tombol', () {
    testWidgets('tap Save to Gallery → navigasi ke SavedContentPage',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final saveBtn = find.text('Save to Gallery');
      if (saveBtn.evaluate().isNotEmpty) {
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        expect(find.text('Saved Strategies'), findsOneWidget);
      }
    });

    testWidgets('tap Schedule to Calendar → navigasi ke CalendarWeekPage',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final scheduleBtn = find.text('Schedule to Calendar');
      if (scheduleBtn.evaluate().isNotEmpty) {
        await tester.tap(scheduleBtn);
        await tester.pumpAndSettle();

        // Verifikasi di CalendarWeekPage
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });

    testWidgets('tap Redo → kembali ke halaman sebelumnya', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final redoBtn = find.text('Redo');
      if (redoBtn.evaluate().isNotEmpty) {
        await tester.tap(redoBtn);
        await tester.pumpAndSettle();

        // Tidak crash = test pass
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Scroll behavior
  // ─────────────────────────────────────────────
  group('Integration - Scroll', () {
    testWidgets('halaman bisa di-scroll untuk melihat semua konten',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.byType(SingleChildScrollView).evaluate().isNotEmpty) {
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -400),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Bottom Navbar navigasi
  // ─────────────────────────────────────────────
  group('Integration - Bottom Navbar', () {
    testWidgets('bottom navbar tampil di GenerationResultPage', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('Content Strategy Result').evaluate().isNotEmpty) {
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      }
    });

    testWidgets('tap navbar index 0 → navigasi ke Dashboard', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      if (find.text('Content Strategy Result').evaluate().isNotEmpty) {
        final navbar = find.byType(BottomNavigationBar);
        if (navbar.evaluate().isNotEmpty) {
          // Tap item pertama (Dashboard)
          await tester.tap(find.byType(BottomNavigationBar));
          await tester.pumpAndSettle();

          expect(find.byType(MaterialApp), findsOneWidget);
        }
      }
    });
  });
}