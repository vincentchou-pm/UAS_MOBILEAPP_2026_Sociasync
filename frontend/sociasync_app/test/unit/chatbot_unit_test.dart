import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/services/fake_chatbot_service.dart';

void main() {
  group('Chatbot Unit Test', () {
    /// ==============================
    /// 1. TEST NORMALIZE TIME
    /// ==============================
    test('normalizeTime format benar (HH:mm)', () {
      final result = normalizeTime("10:30:45");
      expect(result, "10:30");
    });

    test('normalizeTime kosong', () {
      final result = normalizeTime("");
      expect(result, "");
    });

    test('normalizeTime tanpa format', () {
      final result = normalizeTime("1030");
      expect(result, "1030");
    });

    /// ==============================
    /// 2. TEST FROM JSON
    /// ==============================
    test('fromJson mapping benar', () {
      final json = {
        'id': 1,
        'to': 'John',
        'message': 'Meeting',
        'day': 'Monday',
        'time': '09:00:00',
      };

      final reminder = ReminderItem.fromJson(json);

      expect(reminder.id, 1);
      expect(reminder.to, 'John');
      expect(reminder.message, 'Meeting');
      expect(reminder.day, 'Monday');
      expect(reminder.time, '09:00'); // normalized
    });

    test('fromJson handle null / kosong', () {
      final Map<String, dynamic> json = {
        'id': null,
        'to': null,
        'message': null,
        'day': null,
        'time': null,
      };

      final reminder = ReminderItem.fromJson(json);

      expect(reminder.id, 0);
      expect(reminder.to, '');
      expect(reminder.message, '');
      expect(reminder.day, '');
      expect(reminder.time, '');
    });

    /// ==============================
    /// 3. CHAT HISTORY PAYLOAD LOGIC
    /// ==============================
    test('chat history payload mapping', () {
      final messages = [
        {'role': 'user', 'content': 'Hello'},
        {'role': 'assistant', 'content': 'Hi'},
      ];

      final payload = messages.map((m) {
        return {'role': m['role']!, 'content': m['content']!};
      }).toList();

      expect(payload.length, 2);
      expect(payload[0]['role'], 'user');
      expect(payload[1]['content'], 'Hi');
    });
  });
}
