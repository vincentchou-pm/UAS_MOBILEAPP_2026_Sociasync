import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/services/notification_mapper.dart';

void main() {
  group('NotificationMapper', () {
    test('Mapping normal data', () {
      final input = {
        'title': 'Hello',
        'message': 'World',
        'created_at': '2024-01-01T10:30:00Z',
        'is_read': false,
      };

      final result = NotificationMapper.map(input);

      expect(result.title, 'Hello');
      expect(result.message, 'World');
      expect(result.isHighlighted, true);
      expect(result.time.length, 5); // format HH:mm
    });

    test('Fallback title & message', () {
      final input = {
        'title': '',
        'message': '',
        'created_at': '',
        'is_read': true,
      };

      final result = NotificationMapper.map(input);

      expect(result.title, 'Notification');
      expect(result.message, '-');
      expect(result.isHighlighted, false);
      expect(result.time, '--:--');
    });

    test('isHighlighted false jika sudah dibaca', () {
      final input = {
        'title': 'Read',
        'message': 'Done',
        'created_at': '2024-01-01T10:00:00Z',
        'is_read': true,
      };

      final result = NotificationMapper.map(input);

      expect(result.isHighlighted, false);
    });

    test('isHighlighted true jika belum dibaca', () {
      final input = {
        'title': 'Unread',
        'message': 'New',
        'created_at': '2024-01-01T10:00:00Z',
        'is_read': false,
      };

      final result = NotificationMapper.map(input);

      expect(result.isHighlighted, true);
    });

    test('Handle invalid date', () {
      final input = {
        'title': 'Test',
        'message': 'Test',
        'created_at': 'invalid-date',
        'is_read': false,
      };

      final result = NotificationMapper.map(input);

      expect(result.time, '--:--');
    });
  });
}