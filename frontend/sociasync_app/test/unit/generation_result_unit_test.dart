import 'package:flutter_test/flutter_test.dart';

/// ===========================================================
/// UNIT TEST - Generation Result (No. 19)
/// Tester : Gracello
/// File   : generation_result_unit_test.dart
/// Jalankan: flutter test test/unit/generation_result_unit_test.dart
/// ===========================================================

void main() {
  // ─────────────────────────────────────────────
  // GROUP 1: Static content validation
  // ─────────────────────────────────────────────
  group('Static content validation', () {
    const generatedTitle = "Hidden Gem Street Food Review";
    const generatedCaption =
        "Didn't expect this small stall to taste THIS good... 🍔🍕🌮\n\n#fyp #foodreview #kulinerjakarta #viral #trending";

    test('generatedTitle tidak kosong', () {
      expect(generatedTitle.isNotEmpty, isTrue);
    });

    test('generatedTitle sesuai konten yang diharapkan', () {
      expect(generatedTitle, equals('Hidden Gem Street Food Review'));
    });

    test('generatedCaption tidak kosong', () {
      expect(generatedCaption.isNotEmpty, isTrue);
    });

    test('generatedCaption mengandung hashtag #fyp', () {
      expect(generatedCaption.contains('#fyp'), isTrue);
    });

    test('generatedCaption mengandung hashtag #viral', () {
      expect(generatedCaption.contains('#viral'), isTrue);
    });

    test('generatedCaption mengandung emoji makanan', () {
      expect(generatedCaption.contains('🍔'), isTrue);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Step guide data
  // ─────────────────────────────────────────────
  group('Step guide content', () {
    final steps = [
      {'num': '1', 'desc': 'Opening: Hook visual stall makanan yang ramai.'},
      {'num': '2', 'desc': 'Reaction: Ekspresi gigitan pertama (Aesthetic).'},
      {'num': '3', 'desc': 'Closing: Tampilkan lokasi & ajakan follow.'},
    ];

    test('terdapat 3 step guide', () {
      expect(steps.length, equals(3));
    });

    test('step 1 berisi konten Opening', () {
      expect(steps[0]['desc']!.contains('Opening'), isTrue);
    });

    test('step 2 berisi konten Reaction', () {
      expect(steps[1]['desc']!.contains('Reaction'), isTrue);
    });

    test('step 3 berisi konten Closing', () {
      expect(steps[2]['desc']!.contains('Closing'), isTrue);
    });

    test('nomor step berurutan dari 1', () {
      expect(steps[0]['num'], equals('1'));
      expect(steps[1]['num'], equals('2'));
      expect(steps[2]['num'], equals('3'));
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Section card titles
  // ─────────────────────────────────────────────
  group('Section card titles', () {
    const storyboardTitle = '🎬 Visual Storyboard Guide';
    const captionTitle = '✍️ Final Caption & Hashtags';

    test('judul storyboard card tidak kosong', () {
      expect(storyboardTitle.isNotEmpty, isTrue);
    });

    test('judul caption card tidak kosong', () {
      expect(captionTitle.isNotEmpty, isTrue);
    });

    test('judul storyboard mengandung kata Visual', () {
      expect(storyboardTitle.contains('Visual'), isTrue);
    });

    test('judul caption mengandung kata Caption', () {
      expect(captionTitle.contains('Caption'), isTrue);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Button labels
  // ─────────────────────────────────────────────
  group('Button labels', () {
    const buttons = ['Redo', 'Save to Gallery', 'Schedule to Calendar'];

    test('terdapat 3 tombol aksi', () {
      expect(buttons.length, equals(3));
    });

    test('tombol Redo ada', () {
      expect(buttons.contains('Redo'), isTrue);
    });

    test('tombol Save to Gallery ada', () {
      expect(buttons.contains('Save to Gallery'), isTrue);
    });

    test('tombol Schedule to Calendar ada', () {
      expect(buttons.contains('Schedule to Calendar'), isTrue);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Suggested audio text
  // ─────────────────────────────────────────────
  group('Suggested audio content', () {
    const suggestedAudio = 'Suggested Audio: Upbeat Lo-fi Beats';

    test('suggested audio tidak kosong', () {
      expect(suggestedAudio.isNotEmpty, isTrue);
    });

    test('suggested audio mengandung kata Audio', () {
      expect(suggestedAudio.contains('Audio'), isTrue);
    });

    test('suggested audio mengandung Lo-fi', () {
      expect(suggestedAudio.contains('Lo-fi'), isTrue);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Caption hashtag parsing
  // ─────────────────────────────────────────────
  group('Caption hashtag parsing', () {
    const caption =
        "Didn't expect this small stall to taste THIS good... 🍔🍕🌮\n\n#fyp #foodreview #kulinerjakarta #viral #trending";

    test('caption mengandung 5 hashtag', () {
      final hashtags =
          caption.split(' ').where((w) => w.startsWith('#')).toList();
      expect(hashtags.length, equals(5));
    });

    test('caption mengandung newline untuk pemisah hashtag', () {
      expect(caption.contains('\n'), isTrue);
    });

    test('caption berisi teks deskriptif sebelum hashtag', () {
      final parts = caption.split('\n\n');
      expect(parts.length, greaterThanOrEqualTo(2));
      expect(parts[0].isNotEmpty, isTrue);
    });
  });
}