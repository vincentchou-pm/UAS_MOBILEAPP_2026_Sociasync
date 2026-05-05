import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/content_generator/caption_result_page.dart';

/// ===========================================================
/// WIDGET TEST - Caption Hashtag Result (No. 18)
/// Tester : Gracello
/// File   : caption_result_widget_test.dart
/// Jalankan: flutter test test/widget/caption_result_widget_test.dart
/// ===========================================================

void main() {
  // Data dummy untuk testing
  final Map<String, String> dummyRequestData = {
    'platform': 'TikTok',
    'topic': 'Skincare Routine',
    'goal': 'Brand Awareness',
    'audience': 'Female',
    'tone': 'Friendly',
  };

  final Map<String, dynamic> dummySelectedIdea = {
    'title': 'Tutorial Skincare Pagi',
    'description': 'Panduan lengkap skincare routine',
    'type': 'Content Opportunity',
  };

  final Map<String, dynamic> dummyScriptData = {
    'hook': 'Hook yang menarik',
    'body': 'Isi konten',
    'cta': 'Ajakan bertindak',
  };

  const String dummyCaption = 'Caption test untuk skincare routine yang keren!';
  final List<String> dummyHashtags = ['#skincare', '#viral', '#fyp', '#beauty'];

  Widget buildTestApp() {
    return MaterialApp(
      home: CaptionResultPage(
        requestData: dummyRequestData,
        selectedIdea: dummySelectedIdea,
        scriptData: dummyScriptData,
        initialCaption: dummyCaption,
        initialHashtags: dummyHashtags,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GROUP 1: Render UI utama
  // ─────────────────────────────────────────────
  group('CaptionResultPage - Render UI', () {
    testWidgets('halaman berhasil di-render tanpa error', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byType(CaptionResultPage), findsOneWidget);
    });

    testWidgets('judul Caption & Hashtag tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Caption & Hashtag'), findsOneWidget);
    });

    testWidgets('back button tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('judul card Caption Ideas tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('✍️ Caption Ideas'), findsOneWidget);
    });

    testWidgets('judul card Smart Hashtag Mix tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('# Smart Hashtag Mix'), findsOneWidget);
    });

    testWidgets('tombol SAVE CONTENT tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('SAVE CONTENT'), findsOneWidget);
    });

    testWidgets('tombol Generate Other Captions tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Generate Other Captions'), findsOneWidget);
    });

    testWidgets('tombol Generate Other Hashtags tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Generate Other Hashtags'), findsOneWidget);
    });

    testWidgets('icon copy tampil di card', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byIcon(Icons.copy_rounded), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Konten caption dan hashtag
  // ─────────────────────────────────────────────
  group('CaptionResultPage - Konten', () {
    testWidgets('caption awal tampil di layar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text(dummyCaption), findsOneWidget);
    });

    testWidgets('hashtag pertama tampil dalam konten', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.textContaining('#skincare'), findsOneWidget);
    });

    testWidgets('teks Recommended set tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.textContaining('Recommended set:'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Copy to clipboard
  // ─────────────────────────────────────────────
  group('CaptionResultPage - Copy Clipboard', () {
    testWidgets('tap icon copy caption → snackbar Caption copied! muncul',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Tap icon copy pertama (caption)
      final copyIcons = find.byIcon(Icons.copy_rounded);
      await tester.tap(copyIcons.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Caption copied!'), findsOneWidget);
    });

    testWidgets('tap icon copy hashtag → snackbar Hashtags copied! muncul',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Tap icon copy kedua (hashtag)
      final copyIcons = find.byIcon(Icons.copy_rounded);
      if (copyIcons.evaluate().length >= 2) {
        await tester.tap(copyIcons.last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Hashtags copied!'), findsOneWidget);
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Back button navigasi
  // ─────────────────────────────────────────────
  group('CaptionResultPage - Navigasi Back', () {
    testWidgets('tap back button tidak crash', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      // Tidak crash = test pass
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Button state
  // ─────────────────────────────────────────────
  group('CaptionResultPage - Button State', () {
    testWidgets('tombol Generate Other Captions awalnya aktif', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final buttons = find.byType(ElevatedButton);
      // Button pertama = Generate Other Captions
      final firstButton = tester.widget<ElevatedButton>(buttons.first);
      expect(firstButton.onPressed, isNotNull);
    });

    testWidgets('tombol SAVE CONTENT awalnya aktif', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // SAVE CONTENT button
      final saveBtn = find.ancestor(
        of: find.text('SAVE CONTENT'),
        matching: find.byType(ElevatedButton),
      );
      final button = tester.widget<ElevatedButton>(saveBtn);
      expect(button.onPressed, isNotNull);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Scroll behavior
  // ─────────────────────────────────────────────
  group('CaptionResultPage - Scroll', () {
    testWidgets('halaman bisa di-scroll ke bawah', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pump();

      expect(find.byType(CaptionResultPage), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 7: Tap Generate Other Captions
  // ─────────────────────────────────────────────
  group('CaptionResultPage - Regenerate', () {
    testWidgets('tap Generate Other Captions tidak langsung crash',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Generate Other Captions'));
      await tester.pump();

      // Tidak crash (API akan fail karena tidak ada server, tapi tidak crash)
      expect(find.byType(CaptionResultPage), findsOneWidget);
    });

    testWidgets('tap Generate Other Hashtags tidak langsung crash',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      await tester.tap(find.text('Generate Other Hashtags'));
      await tester.pump();

      expect(find.byType(CaptionResultPage), findsOneWidget);
    });
  });
}