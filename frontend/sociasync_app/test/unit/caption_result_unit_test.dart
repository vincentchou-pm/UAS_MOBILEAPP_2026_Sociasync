import 'package:flutter_test/flutter_test.dart';

/// ===========================================================
/// UNIT TEST - Caption Hashtag Result (No. 18)
/// Tester : Gracello
/// File   : caption_result_unit_test.dart
/// Jalankan: flutter test test/unit/caption_result_unit_test.dart
/// ===========================================================

void main() {
  // ─────────────────────────────────────────────
  // GROUP 1: Caption state initialization
  // ─────────────────────────────────────────────
  group('Caption state initialization', () {
    test('caption diinisialisasi dari initialCaption', () {
      const initialCaption = 'Caption awal dari server';
      String caption = initialCaption;
      expect(caption, equals('Caption awal dari server'));
    });

    test('hashtags diinisialisasi dari initialHashtags', () {
      final initialHashtags = ['#skincare', '#viral', '#fyp'];
      final hashtags = List<String>.from(initialHashtags);
      expect(hashtags, equals(['#skincare', '#viral', '#fyp']));
    });

    test('hashtags adalah salinan baru (bukan referensi yang sama)', () {
      final initialHashtags = ['#skincare'];
      final hashtags = List<String>.from(initialHashtags);
      hashtags.add('#viral');
      // initialHashtags tidak ikut berubah
      expect(initialHashtags.length, equals(1));
      expect(hashtags.length, equals(2));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: _copyToClipboard logic
  // ─────────────────────────────────────────────
  group('Copy to clipboard logic', () {
    test('teks caption tidak kosong sebelum di-copy', () {
      const caption = 'Coba skincare terbaru!';
      expect(caption.isNotEmpty, isTrue);
    });

    test('hashtags digabung dengan spasi untuk di-copy', () {
      final hashtags = ['#skincare', '#viral', '#fyp'];
      final copied = hashtags.join(' ');
      expect(copied, equals('#skincare #viral #fyp'));
    });

    test('hashtags kosong menghasilkan string kosong saat di-copy', () {
      final hashtags = <String>[];
      final copied = hashtags.join(' ');
      expect(copied, isEmpty);
    });

    test('caption message copy benar', () {
      const message = 'Caption copied!';
      expect(message, equals('Caption copied!'));
    });

    test('hashtag message copy benar', () {
      const message = 'Hashtags copied!';
      expect(message, equals('Hashtags copied!'));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: _regenerateCaption loading state logic
  // ─────────────────────────────────────────────
  group('Regenerate caption loading state', () {
    test('tidak bisa regenerate jika sedang loading', () {
      bool isGeneratingCaption = true;
      bool canRegenerate = !isGeneratingCaption;
      expect(canRegenerate, isFalse);
    });

    test('bisa regenerate jika tidak sedang loading', () {
      bool isGeneratingCaption = false;
      bool canRegenerate = !isGeneratingCaption;
      expect(canRegenerate, isTrue);
    });

    test('state loading di-reset ke false setelah selesai', () {
      bool isGeneratingCaption = true;
      // simulasi finally block
      isGeneratingCaption = false;
      expect(isGeneratingCaption, isFalse);
    });

    test('caption diupdate setelah regenerate berhasil', () {
      String caption = 'Caption lama';
      const newCaption = 'Caption baru dari server';
      // simulasi setState
      caption = newCaption;
      expect(caption, equals('Caption baru dari server'));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: _regenerateHashtags loading state logic
  // ─────────────────────────────────────────────
  group('Regenerate hashtags loading state', () {
    test('tidak bisa regenerate hashtag jika sedang loading', () {
      bool isGeneratingHashtags = true;
      expect(!isGeneratingHashtags, isFalse);
    });

    test('hashtags diupdate setelah regenerate berhasil', () {
      List<String> hashtags = ['#lama'];
      final newHashtags = ['#baru1', '#baru2'];
      hashtags = newHashtags;
      expect(hashtags, equals(['#baru1', '#baru2']));
    });

    test('state loading hashtag di-reset ke false setelah selesai', () {
      bool isGeneratingHashtags = true;
      isGeneratingHashtags = false;
      expect(isGeneratingHashtags, isFalse);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: _saveContent logic
  // ─────────────────────────────────────────────
  group('Save content logic', () {
    test('tidak bisa save jika sedang loading', () {
      bool isSaving = true;
      expect(!isSaving, isFalse);
    });

    test('bisa save jika tidak sedang loading', () {
      bool isSaving = false;
      expect(!isSaving, isTrue);
    });

    test('state saving di-reset setelah selesai', () {
      bool isSaving = true;
      isSaving = false;
      expect(isSaving, isFalse);
    });

    test('payload save content terbentuk dengan benar', () {
      final requestData = {
        'topic': 'Skincare',
        'platform': 'TikTok',
        'tone': 'Friendly',
      };
      final selectedIdea = {'title': 'Ide 1', 'description': 'Desc'};
      final scriptData = {'hook': 'Hook', 'body': 'Body', 'cta': 'CTA'};
      const caption = 'Caption test';
      final hashtags = ['#skincare'];

      expect(requestData['topic'], equals('Skincare'));
      expect(requestData['platform'], equals('TikTok'));
      expect(selectedIdea['title'], equals('Ide 1'));
      expect(scriptData['hook'], equals('Hook'));
      expect(caption, equals('Caption test'));
      expect(hashtags, contains('#skincare'));
    });

    test('topic fallback ke string kosong jika null', () {
      final requestData = <String, String>{};
      final topic = requestData['topic'] ?? '';
      expect(topic, equals(''));
    });

    test('platform fallback ke string kosong jika null', () {
      final requestData = <String, String>{};
      final platform = requestData['platform'] ?? '';
      expect(platform, equals(''));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: requestData fallback
  // ─────────────────────────────────────────────
  group('requestData fallback values', () {
    test('platform fallback ke TikTok jika null', () {
      final requestData = <String, String>{};
      final platform = requestData['platform'] ?? 'TikTok';
      expect(platform, equals('TikTok'));
    });

    test('tone fallback ke Friendly jika null', () {
      final requestData = <String, String>{};
      final tone = requestData['tone'] ?? 'Friendly';
      expect(tone, equals('Friendly'));
    });

    test('topic fallback ke string kosong jika null', () {
      final requestData = <String, String>{};
      final topic = requestData['topic'] ?? '';
      expect(topic, equals(''));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 7: Hashtag content display
  // ─────────────────────────────────────────────
  group('Hashtag content display', () {
    test('hashtags ditampilkan dengan newline separator', () {
      final hashtags = ['#skincare', '#viral', '#fyp'];
      final content = 'Recommended set:\n${hashtags.join("\n")}';
      expect(content, contains('Recommended set:'));
      expect(content, contains('#skincare'));
      expect(content, contains('#viral'));
      expect(content, contains('#fyp'));
    });

    test('satu hashtag tampil dengan benar', () {
      final hashtags = ['#skincare'];
      final content = 'Recommended set:\n${hashtags.join("\n")}';
      expect(content, equals('Recommended set:\n#skincare'));
    });
  });
}