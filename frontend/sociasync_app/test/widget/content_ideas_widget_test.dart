import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/content_generator/content_ideas_page.dart';

/// ===========================================================
/// WIDGET TEST - Content Ideas (No. 17)
/// Tester : Gracello
/// File   : content_ideas_widget_test.dart
/// Jalankan: flutter test test/widget/content_ideas_widget_test.dart
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

  final List<Map<String, dynamic>> dummyIdeas = [
    {
      'title': 'Tutorial Skincare Pagi',
      'description': 'Panduan lengkap skincare routine di pagi hari',
      'type': 'Content Opportunity',
    },
    {
      'title': 'Review Serum Viral',
      'description': 'Ulasan jujur serum yang sedang viral di TikTok',
      'type': 'Comment Magnet',
    },
  ];

  Widget buildTestApp({List<Map<String, dynamic>>? ideas}) {
    return MaterialApp(
      home: ContentIdeasPage(
        requestData: dummyRequestData,
        ideas: ideas ?? dummyIdeas,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GROUP 1: Render UI utama
  // ─────────────────────────────────────────────
  group('ContentIdeasPage - Render UI', () {
    testWidgets('halaman berhasil di-render tanpa error', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.byType(ContentIdeasPage), findsOneWidget);
    });

    testWidgets('judul Content Generator tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Content Generator'), findsOneWidget);
    });

    testWidgets('judul Content Ideas tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Content Ideas'), findsOneWidget);
    });

    testWidgets('platform dan topic tampil dalam format yang benar',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('TikTok • Skincare Routine'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: ContentIdeaCard render
  // ─────────────────────────────────────────────
  group('ContentIdeasPage - ContentIdeaCard', () {
    testWidgets('card idea pertama tampil dengan judul benar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Tutorial Skincare Pagi'), findsOneWidget);
    });

    testWidgets('card idea kedua tampil dengan judul benar', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Review Serum Viral'), findsOneWidget);
    });

    testWidgets('deskripsi idea pertama tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(
        find.text('Panduan lengkap skincare routine di pagi hari'),
        findsOneWidget,
      );
    });

    testWidgets('badge type Content Opportunity tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Content Opportunity'), findsOneWidget);
    });

    testWidgets('badge type Comment Magnet tampil', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Comment Magnet'), findsOneWidget);
    });

    testWidgets('emoji 💡 tampil untuk type Content Opportunity',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('💡'), findsWidgets);
    });

    testWidgets('emoji 🔥 tampil untuk type Comment Magnet', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('🔥'), findsOneWidget);
    });

    testWidgets('tombol Generate Script tampil di setiap card', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      expect(find.text('Generate Script'), findsNWidgets(2));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Ideas kosong
  // ─────────────────────────────────────────────
  group('ContentIdeasPage - Ideas Kosong', () {
    testWidgets('tampil pesan kosong jika ideas list kosong', (tester) async {
      await tester.pumpWidget(buildTestApp(ideas: []));
      await tester.pump();
      expect(
        find.text('Belum ada ide yang bisa ditampilkan.'),
        findsOneWidget,
      );
    });

    testWidgets('tidak ada ContentIdeaCard jika ideas kosong', (tester) async {
      await tester.pumpWidget(buildTestApp(ideas: []));
      await tester.pump();
      expect(find.byType(ContentIdeaCard), findsNothing);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Validasi snackbar idea tidak lengkap
  // ─────────────────────────────────────────────
  group('ContentIdeasPage - Validasi Generate Script', () {
    testWidgets(
        'tap Generate Script pada idea valid tidak langsung error',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      // Tap tombol Generate Script pertama
      final generateBtns = find.text('Generate Script');
      await tester.tap(generateBtns.first);
      await tester.pump();

      // Tidak crash = test pass (API call akan timeout/error karena tidak ada server)
      expect(find.byType(ContentIdeasPage), findsOneWidget);
    });

    testWidgets('tap Generate Script pada idea kosong → snackbar muncul',
        (tester) async {
      final ideasDenganDataKosong = [
        {'title': '', 'description': '', 'type': 'Content Opportunity'},
      ];

      await tester.pumpWidget(buildTestApp(ideas: ideasDenganDataKosong));
      await tester.pump();

      await tester.tap(find.text('Generate Script'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Data ide belum lengkap.'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Loading state pada card
  // ─────────────────────────────────────────────
  group('ContentIdeasPage - Loading State', () {
    testWidgets('tombol Generate Script awalnya aktif', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsWidgets);

      // Semua button awalnya tidak loading
      expect(find.text('Generating...'), findsNothing);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: ContentIdeaCard widget standalone
  // ─────────────────────────────────────────────
  group('ContentIdeaCard - Widget standalone', () {
    testWidgets('ContentIdeaCard render dengan benar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContentIdeaCard(
              title: 'Test Idea',
              badgeText: 'Content Opportunity',
              emoji: '💡',
              description: 'Deskripsi test idea',
              primaryColor: const Color(0xFF1D5093),
              onGenerateScript: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Test Idea'), findsOneWidget);
      expect(find.text('Content Opportunity'), findsOneWidget);
      expect(find.text('💡'), findsOneWidget);
      expect(find.text('Deskripsi test idea'), findsOneWidget);
      expect(find.text('Generate Script'), findsOneWidget);
    });

    testWidgets('ContentIdeaCard loading=true → tombol disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContentIdeaCard(
              title: 'Test',
              badgeText: 'Type',
              emoji: '💡',
              description: 'Desc',
              primaryColor: const Color(0xFF1D5093),
              onGenerateScript: () {},
              loading: true,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Generating...'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull); // disabled
    });

    testWidgets('ContentIdeaCard loading=false → tombol aktif', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContentIdeaCard(
              title: 'Test',
              badgeText: 'Type',
              emoji: '💡',
              description: 'Desc',
              primaryColor: const Color(0xFF1D5093),
              onGenerateScript: () {},
              loading: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Generate Script'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull); // aktif
    });
  });
}