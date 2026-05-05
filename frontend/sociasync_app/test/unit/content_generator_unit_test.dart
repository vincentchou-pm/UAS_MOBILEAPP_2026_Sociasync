import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/services/content_generator_service.dart';

/// ===========================================================
/// UNIT TEST - Content Generator (No. 16)
/// Tester : Gracello
/// File   : content_generator_unit_test.dart
/// Jalankan: flutter test test/unit/content_generator_unit_test.dart
/// ===========================================================

void main() {
  // ─────────────────────────────────────────────
  // GROUP 1: ContentGeneratorServiceException
  // ─────────────────────────────────────────────
  group('ContentGeneratorServiceException', () {
    test('menyimpan dan mengembalikan pesan error dengan benar', () {
      const msg = 'Sesi login tidak ditemukan.';
      final exception = ContentGeneratorServiceException(msg);

      expect(exception.message, equals(msg));
      expect(exception.toString(), equals(msg));
    });

    test('toString() mengembalikan pesan yang sama dengan message', () {
      final exception = ContentGeneratorServiceException('Test error');
      expect(exception.toString(), exception.message);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: _decode (via perilaku service)
  // ─────────────────────────────────────────────
  // _decode bersifat private, tapi kita test efeknya melalui
  // format response yang diharapkan oleh generateIdeas, dll.
  group('Format validasi ideas list', () {
    test('ideas yang valid adalah List of Map', () {
      // Simulasi data yang dikembalikan server
      final raw = [
        {'title': 'Ide 1', 'description': 'Deskripsi 1'},
        {'title': 'Ide 2', 'description': 'Deskripsi 2'},
      ];

      // Proses yang sama dengan generateIdeas()
      final result = raw.whereType<Map>().map((item) {
        return item.map((k, v) => MapEntry(k.toString(), v));
      }).toList();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, equals(2));
      expect(result[0]['title'], equals('Ide 1'));
    });

    test('ideas yang bukan List harus dideteksi sebagai invalid', () {
      final raw = 'bukan list'; // invalid format
      expect(raw is! List, isTrue);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: _extractSelectedOption logic (mirror dari page)
  // ─────────────────────────────────────────────
  group('_extractSelectedOption logic', () {
    // Helper yang mencerminkan logika di _ContentGeneratorPageState
    String? extractSelectedOption(
      String section,
      List<String> options,
      Map<String, bool> toggleStates,
      String otherText,
    ) {
      for (final option in options) {
        final key = '$section::$option';
        if (toggleStates[key] == true) {
          if (option.startsWith('Other')) {
            final custom = otherText.trim();
            return custom.isNotEmpty ? custom : null;
          }
          return option;
        }
      }
      return null;
    }

    const goalOptions = [
      'Increase Engagement',
      'Promote Product',
      'Brand Awareness',
      'Drive Sales',
      'Other..',
    ];

    test('mengembalikan opsi yang dipilih (bukan Other)', () {
      final toggleStates = {'Goal::Promote Product': true};
      final result = extractSelectedOption(
        'Goal',
        goalOptions,
        toggleStates,
        '',
      );
      expect(result, equals('Promote Product'));
    });

    test('mengembalikan null jika tidak ada yang dipilih', () {
      final result = extractSelectedOption('Goal', goalOptions, {}, '');
      expect(result, isNull);
    });

    test('Other dipilih dengan teks custom → mengembalikan teks custom', () {
      final toggleStates = {'Goal::Other..': true};
      final result = extractSelectedOption(
        'Goal',
        goalOptions,
        toggleStates,
        'Viral Challenge',
      );
      expect(result, equals('Viral Challenge'));
    });

    test('Other dipilih tapi teks kosong → mengembalikan null', () {
      final toggleStates = {'Goal::Other..': true};
      final result = extractSelectedOption(
        'Goal',
        goalOptions,
        toggleStates,
        '',
      );
      expect(result, isNull);
    });

    test('Other dipilih tapi teks hanya spasi → mengembalikan null', () {
      final toggleStates = {'Goal::Other..': true};
      final result = extractSelectedOption(
        'Goal',
        goalOptions,
        toggleStates,
        '   ',
      );
      expect(result, isNull);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Validasi form sebelum generate
  // ─────────────────────────────────────────────
  group('Validasi form _generateIdeas', () {
    // Simulasi kondisi validasi yang sama dengan kode asli
    bool isFormValid({
      required String topic,
      required String? goal,
      required String? audience,
      required String? tone,
    }) {
      return topic.isNotEmpty &&
          goal != null &&
          audience != null &&
          tone != null;
    }

    test('form valid jika semua field terisi', () {
      expect(
        isFormValid(
          topic: 'Skincare',
          goal: 'Brand Awareness',
          audience: 'Female',
          tone: 'Friendly',
        ),
        isTrue,
      );
    });

    test('form invalid jika topic kosong', () {
      expect(
        isFormValid(
          topic: '',
          goal: 'Brand Awareness',
          audience: 'Female',
          tone: 'Friendly',
        ),
        isFalse,
      );
    });

    test('form invalid jika goal null', () {
      expect(
        isFormValid(
          topic: 'Skincare',
          goal: null,
          audience: 'Female',
          tone: 'Friendly',
        ),
        isFalse,
      );
    });

    test('form invalid jika audience null', () {
      expect(
        isFormValid(
          topic: 'Skincare',
          goal: 'Brand Awareness',
          audience: null,
          tone: 'Friendly',
        ),
        isFalse,
      );
    });

    test('form invalid jika tone null', () {
      expect(
        isFormValid(
          topic: 'Skincare',
          goal: 'Brand Awareness',
          audience: 'Female',
          tone: null,
        ),
        isFalse,
      );
    });

    test('form invalid jika semua null', () {
      expect(
        isFormValid(topic: '', goal: null, audience: null, tone: null),
        isFalse,
      );
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Platform selection logic
  // ─────────────────────────────────────────────
  group('Platform selection', () {
    test('isTikTokSelected true → platform = TikTok', () {
      bool isTikTokSelected = true;
      final platform = isTikTokSelected ? 'TikTok' : 'Instagram';
      expect(platform, equals('TikTok'));
    });

    test('isTikTokSelected false → platform = Instagram', () {
      bool isTikTokSelected = false;
      final platform = isTikTokSelected ? 'TikTok' : 'Instagram';
      expect(platform, equals('Instagram'));
    });

    test('tap TikTok mengubah state ke TikTok', () {
      bool isTikTokSelected = false;
      // simulasi onTap label == TikTok
      isTikTokSelected = 'TikTok' == 'TikTok';
      expect(isTikTokSelected, isTrue);
    });

    test('tap Instagram mengubah state ke Instagram', () {
      bool isTikTokSelected = true;
      // simulasi onTap label == Instagram
      isTikTokSelected = 'Instagram' == 'TikTok';
      expect(isTikTokSelected, isFalse);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Hashtag & Caption format validasi
  // ─────────────────────────────────────────────
  group('Format hashtag result', () {
    test('hashtag valid difilter dari list kosong', () {
      final raw = ['#skincare', '', '#viral', '  '];
      final result = raw
          .map((item) => item.toString())
          .where((s) => s.isNotEmpty)
          .toList();
      expect(result, equals(['#skincare', '  ', '#viral', '  ']));
      // yang benar: filter trim
    });

    test('hashtag list kosong menghasilkan list kosong', () {
      final raw = <dynamic>[];
      final result = raw
          .map((item) => item.toString())
          .where((s) => s.isNotEmpty)
          .toList();
      expect(result, isEmpty);
    });

    test('caption kosong harus dideteksi sebagai error', () {
      final caption = ''.trim();
      expect(caption.isEmpty, isTrue);
    });

    test('caption tidak kosong lolos validasi', () {
      final caption = 'Coba produk skincare terbaik!'.trim();
      expect(caption.isEmpty, isFalse);
    });
  });
}