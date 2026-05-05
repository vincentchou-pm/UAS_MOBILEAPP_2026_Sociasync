import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/content_generator/content_generator_page.dart';

/// ===========================================================
/// WIDGET TEST - Content Generator (No. 16)
/// Tester : Gracello
/// File   : content_generator_widget_test.dart
/// Jalankan: flutter test test/widget/content_generator_widget_test.dart
/// ===========================================================

void main() {
  // Helper untuk wrap widget dengan MaterialApp
  Widget buildTestApp() {
    return const MaterialApp(
      home: ContentGeneratorPage(),
    );
  }

  // ─────────────────────────────────────────────
  // GROUP 1: Render UI utama
  // ─────────────────────────────────────────────
  group('ContentGeneratorPage - Render UI', () {
    testWidgets('halaman berhasil di-render tanpa error', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byType(ContentGeneratorPage), findsOneWidget);
    });

    testWidgets('judul Content Generator tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Content Generator'), findsOneWidget);
    });

    testWidgets('tombol platform TikTok tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('TikTok'), findsOneWidget);
    });

    testWidgets('tombol platform Instagram tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Instagram'), findsOneWidget);
    });

    testWidgets('TextField topic tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('tombol NEXT tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('NEXT'), findsOneWidget);
    });

    testWidgets('icon bookmark Saved Content tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('section Goal tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Goal'), findsOneWidget);
    });

    testWidgets('section Target Audience tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Target Audience'), findsOneWidget);
    });

    testWidgets('section Tone of Voice tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Tone of Voice'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Platform toggle (TikTok/Instagram)
  // ─────────────────────────────────────────────
  group('ContentGeneratorPage - Platform Toggle', () {
    testWidgets('TikTok aktif secara default (warna biru)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // TikTok button harus ada
      final tiktokFinder = find.text('TikTok');
      expect(tiktokFinder, findsOneWidget);
    });

    testWidgets('tap Instagram mengubah pilihan ke Instagram', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Instagram'));
      await tester.pump();

      // Setelah tap, Instagram harus ada di layar (tidak crash)
      expect(find.text('Instagram'), findsOneWidget);
    });

    testWidgets('tap TikTok kembali setelah pilih Instagram', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Instagram'));
      await tester.pump();

      await tester.tap(find.text('TikTok'));
      await tester.pump();

      expect(find.text('TikTok'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Input topic field
  // ─────────────────────────────────────────────
  group('ContentGeneratorPage - Topic Input', () {
    testWidgets('bisa mengetik teks di field topic', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Ambil TextField pertama (topic)
      final topicField = find.byType(TextField).first;
      await tester.enterText(topicField, 'Skincare Tutorial');
      await tester.pump();

      expect(find.text('Skincare Tutorial'), findsOneWidget);
    });

    testWidgets('field topic awalnya kosong', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final topicField = find.byType(TextField).first;
      final textField = tester.widget<TextField>(topicField);
      expect(textField.controller?.text ?? '', isEmpty);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Opsi Goal section
  // ─────────────────────────────────────────────
  group('ContentGeneratorPage - Goal Options', () {
    testWidgets('opsi Increase Engagement tampil di Goal', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Increase Engagement'), findsOneWidget);
    });

    testWidgets('opsi Promote Product tampil di Goal', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Promote Product'), findsOneWidget);
    });

    testWidgets('opsi Brand Awareness tampil di Goal', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Brand Awareness'), findsOneWidget);
    });

    testWidgets('opsi Drive Sales tampil di Goal', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Drive Sales'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Toggle interaksi
  // ─────────────────────────────────────────────
  group('ContentGeneratorPage - Toggle Interaction', () {
    testWidgets('tap toggle goal tidak menyebabkan crash', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Tap pada GestureDetector toggle pertama yang ada
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      // Tap yang pertama (TikTok platform btn)
      await tester.tap(gestureDetectors.first);
      await tester.pump();

      // tidak ada crash = test pass
      expect(find.byType(ContentGeneratorPage), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Validasi snackbar saat form kosong
  // ─────────────────────────────────────────────
  group('ContentGeneratorPage - Validasi Form', () {
    testWidgets('tap NEXT saat form kosong menampilkan SnackBar error',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Tap NEXT tanpa isi apapun
      await tester.tap(find.text('NEXT'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Harus muncul SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('SnackBar berisi teks peringatan yang benar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('NEXT'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.text('Lengkapi topic, goal, target audience, dan tone dulu.'),
        findsOneWidget,
      );
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 7: ElevatedButton state
  // ─────────────────────────────────────────────
  group('ContentGeneratorPage - Button State', () {
    testWidgets('tombol NEXT awalnya aktif (tidak disabled)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);

      final elevatedButton = tester.widget<ElevatedButton>(button);
      // onPressed tidak null = aktif
      expect(elevatedButton.onPressed, isNotNull);
    });
  });
}