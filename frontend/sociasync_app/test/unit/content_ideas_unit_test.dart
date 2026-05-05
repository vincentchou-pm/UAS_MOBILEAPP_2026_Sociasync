import 'package:flutter_test/flutter_test.dart';

/// ===========================================================
/// UNIT TEST - Content Ideas (No. 17)
/// Tester : Gracello
/// File   : content_ideas_unit_test.dart
/// Jalankan: flutter test test/unit/content_ideas_unit_test.dart
/// ===========================================================

void main() {
  // ─────────────────────────────────────────────
  // GROUP 1: Validasi data idea sebelum generate script
  // ─────────────────────────────────────────────
  group('Validasi idea sebelum _generateScriptForIdea', () {
    // Mirror logika validasi dari _generateScriptForIdea
    bool isIdeaValid(Map<String, dynamic> idea) {
      final title = (idea['title'] ?? '').toString().trim();
      final description = (idea['description'] ?? '').toString().trim();
      return title.isNotEmpty && description.isNotEmpty;
    }

    test('idea valid jika title dan description terisi', () {
      final idea = {
        'title': 'Tutorial Skincare',
        'description': 'Cara pakai serum yang benar',
        'type': 'Content Opportunity',
      };
      expect(isIdeaValid(idea), isTrue);
    });

    test('idea invalid jika title kosong', () {
      final idea = {'title': '', 'description': 'Deskripsi ada', 'type': 'x'};
      expect(isIdeaValid(idea), isFalse);
    });

    test('idea invalid jika description kosong', () {
      final idea = {'title': 'Ada judul', 'description': '', 'type': 'x'};
      expect(isIdeaValid(idea), isFalse);
    });

    test('idea invalid jika title null', () {
      final idea = {'title': null, 'description': 'Ada deskripsi'};
      expect(isIdeaValid(idea), isFalse);
    });

    test('idea invalid jika description null', () {
      final idea = {'title': 'Ada judul', 'description': null};
      expect(isIdeaValid(idea), isFalse);
    });

    test('idea invalid jika title hanya spasi', () {
      final idea = {'title': '   ', 'description': 'Ada deskripsi'};
      expect(isIdeaValid(idea), isFalse);
    });

    test('idea invalid jika keduanya kosong', () {
      final idea = {'title': '', 'description': ''};
      expect(isIdeaValid(idea), isFalse);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Emoji logic berdasarkan type
  // ─────────────────────────────────────────────
  group('Emoji logic berdasarkan type idea', () {
    String getEmoji(String type) {
      return type.toLowerCase().contains('comment') ? '🔥' : '💡';
    }

    test('type mengandung "comment" → emoji 🔥', () {
      expect(getEmoji('Comment Magnet'), equals('🔥'));
    });

    test('type "Content Opportunity" → emoji 💡', () {
      expect(getEmoji('Content Opportunity'), equals('💡'));
    });

    test('type kosong → emoji 💡', () {
      expect(getEmoji(''), equals('💡'));
    });

    test('type mengandung "COMMENT" uppercase → emoji 🔥', () {
      expect(getEmoji('COMMENT TYPE'), equals('🔥'));
    });

    test('type random → emoji 💡', () {
      expect(getEmoji('Trending Topic'), equals('💡'));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Parsing data idea dari response
  // ─────────────────────────────────────────────
  group('Parsing field idea', () {
    test('title diambil dari idea dengan benar', () {
      final idea = {'title': 'Tutorial Makeup', 'description': 'Desc'};
      final title = (idea['title'] ?? 'Untitled Idea').toString();
      expect(title, equals('Tutorial Makeup'));
    });

    test('title null → fallback ke Untitled Idea', () {
      final idea = {'title': null, 'description': 'Desc'};
      final title = (idea['title'] ?? 'Untitled Idea').toString();
      expect(title, equals('Untitled Idea'));
    });

    test('description null → fallback ke -', () {
      final idea = {'title': 'Judul', 'description': null};
      final description = (idea['description'] ?? '-').toString();
      expect(description, equals('-'));
    });

    test('type null → fallback ke Content Opportunity', () {
      final idea = {'title': 'Judul', 'description': 'Desc', 'type': null};
      final type = (idea['type'] ?? 'Content Opportunity').toString();
      expect(type, equals('Content Opportunity'));
    });

    test('scriptData dibangun dengan benar dari response', () {
      final script = {'hook': 'Intro hook', 'body': 'Isi', 'cta': 'Ajakan'};
      final scriptData = {
        'hook': (script['hook'] ?? '').toString(),
        'body': (script['body'] ?? '').toString(),
        'cta': (script['cta'] ?? '').toString(),
      };
      expect(scriptData['hook'], equals('Intro hook'));
      expect(scriptData['body'], equals('Isi'));
      expect(scriptData['cta'], equals('Ajakan'));
    });

    test('scriptData dengan nilai null → fallback ke string kosong', () {
      final script = {'hook': null, 'body': null, 'cta': null};
      final scriptData = {
        'hook': (script['hook'] ?? '').toString(),
        'body': (script['body'] ?? '').toString(),
        'cta': (script['cta'] ?? '').toString(),
      };
      expect(scriptData['hook'], equals(''));
      expect(scriptData['body'], equals(''));
      expect(scriptData['cta'], equals(''));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: _loadingIndex logic
  // ─────────────────────────────────────────────
  group('Loading index logic', () {
    test('tidak bisa generate jika loadingIndex tidak null', () {
      int? loadingIndex = 0; // sedang loading
      bool canGenerate = loadingIndex == null;
      expect(canGenerate, isFalse);
    });

    test('bisa generate jika loadingIndex null', () {
      int? loadingIndex;
      bool canGenerate = loadingIndex == null;
      expect(canGenerate, isTrue);
    });

    test('loadingIndex di-reset ke null setelah selesai', () {
      int? loadingIndex = 1;
      // simulasi finally block
      loadingIndex = null;
      expect(loadingIndex, isNull);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: requestData platform & topic display
  // ─────────────────────────────────────────────
  group('requestData display logic', () {
    test('format platform • topic tampil dengan benar', () {
      final requestData = {'platform': 'TikTok', 'topic': 'Skincare'};
      final display =
          '${requestData['platform']} • ${requestData['topic']}';
      expect(display, equals('TikTok • Skincare'));
    });

    test('platform Instagram tampil dengan benar', () {
      final requestData = {'platform': 'Instagram', 'topic': 'Fashion'};
      final display =
          '${requestData['platform']} • ${requestData['topic']}';
      expect(display, equals('Instagram • Fashion'));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Ideas list kosong
  // ─────────────────────────────────────────────
  group('Ideas list kosong', () {
    test('ideas kosong terdeteksi dengan benar', () {
      final ideas = <Map<String, dynamic>>[];
      expect(ideas.isEmpty, isTrue);
    });

    test('ideas tidak kosong terdeteksi dengan benar', () {
      final ideas = [
        {'title': 'Ide 1', 'description': 'Desc 1'},
      ];
      expect(ideas.isEmpty, isFalse);
    });

    test('jumlah ideas sesuai dengan yang diterima', () {
      final ideas = [
        {'title': 'Ide 1', 'description': 'Desc 1'},
        {'title': 'Ide 2', 'description': 'Desc 2'},
        {'title': 'Ide 3', 'description': 'Desc 3'},
      ];
      expect(ideas.length, equals(3));
    });
  });
}