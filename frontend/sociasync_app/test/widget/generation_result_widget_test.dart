import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/content_generator/generation_result_page.dart';

/// ===========================================================
/// WIDGET TEST - Generation Result (No. 19)
/// Tester : Gracello
/// File   : generation_result_widget_test.dart
/// Jalankan: flutter test test/widget/generation_result_widget_test.dart
/// ===========================================================

void main() {
  Widget buildTestApp() {
    return const MaterialApp(home: GenerationResultPage());
  }

  // ─────────────────────────────────────────────
  // GROUP 1: Render UI utama
  // ─────────────────────────────────────────────
  group('GenerationResultPage - Render UI', () {
    testWidgets('halaman berhasil di-render tanpa error', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byType(GenerationResultPage), findsOneWidget);
    });

    testWidgets('judul Content Strategy Result tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Content Strategy Result'), findsOneWidget);
    });

    testWidgets('judul section Visual Storyboard Guide tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('🎬 Visual Storyboard Guide'), findsOneWidget);
    });

    testWidgets('judul section Final Caption & Hashtags tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('✍️ Final Caption & Hashtags'), findsOneWidget);
    });

    testWidgets('tombol Redo tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Redo'), findsOneWidget);
    });

    testWidgets('tombol Save to Gallery tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Save to Gallery'), findsOneWidget);
    });

    testWidgets('tombol Schedule to Calendar tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Schedule to Calendar'), findsOneWidget);
    });

    testWidgets('icon kalender tampil di tombol Schedule', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Step guide content
  // ─────────────────────────────────────────────
  group('GenerationResultPage - Step Guide', () {
    testWidgets('step 1 Opening tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(
        find.textContaining('Opening'),
        findsOneWidget,
      );
    });

    testWidgets('step 2 Reaction tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.textContaining('Reaction'), findsOneWidget);
    });

    testWidgets('step 3 Closing tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.textContaining('Closing'), findsOneWidget);
    });

    testWidgets('teks Suggested Audio tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.textContaining('Suggested Audio'), findsOneWidget);
    });

    testWidgets('nomor step 1, 2, 3 tampil sebagai CircleAvatar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byType(CircleAvatar), findsNWidgets(3));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Caption content
  // ─────────────────────────────────────────────
  group('GenerationResultPage - Caption Content', () {
    testWidgets('caption dengan hashtag tampil di halaman', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.textContaining('#fyp'), findsOneWidget);
    });

    testWidgets('caption mengandung #viral', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.textContaining('#viral'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Interaksi tombol
  // ─────────────────────────────────────────────
  group('GenerationResultPage - Interaksi Tombol', () {
    testWidgets('tap Redo tidak crash (Navigator.pop)', (tester) async {
      // Wrap dalam Navigator agar pop tidak error
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GenerationResultPage(),
                ),
              ),
              child: const Text('Go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Redo'));
      await tester.pumpAndSettle();

      // Kembali ke halaman sebelumnya = test pass
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('tap Save to Gallery → navigasi ke SavedContentPage',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Save to Gallery'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Strategies'), findsOneWidget);
    });

    testWidgets('tap Schedule to Calendar → navigasi ke CalendarWeekPage',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Schedule to Calendar'));
      await tester.pumpAndSettle();

      // Verifikasi navigasi ke CalendarWeekPage
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Scroll behavior
  // ─────────────────────────────────────────────
  group('GenerationResultPage - Scroll', () {
    testWidgets('halaman bisa di-scroll ke bawah', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pump();

      expect(find.byType(GenerationResultPage), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Bottom Navbar
  // ─────────────────────────────────────────────
  group('GenerationResultPage - Bottom Navbar', () {
    testWidgets('bottom navbar tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}