import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/chatbot_Ai/chatbot.dart';

void main() {
  group('Reminder Unit Test (_ReminderItem)', () {

    /// ==============================
    /// 1. fromJson normal
    /// ==============================
    test('fromJson mapping normal', () {
      final json = {
        'id': 1,
        'to': 'John',
        'message': 'Meeting',
        'day': 'Monday',
        'time': '10:30:00',
      };

      final reminder = _ReminderItem.fromJson(json);

      expect(reminder.id, 1);
      expect(reminder.to, 'John');
      expect(reminder.message, 'Meeting');
      expect(reminder.day, 'Monday');
      expect(reminder.time, '10:30'); // harus normalize
    });

    /// ==============================
    /// 2. time normalization
    /// ==============================
    test('normalize time trims seconds', () {
      final json = {
        'id': 2,
        'to': 'Alice',
        'message': 'Call',
        'day': 'Tuesday',
        'time': '09:15:59',
      };

      final reminder = _ReminderItem.fromJson(json);

      expect(reminder.time, '09:15');
    });

    /// ==============================
    /// 3. empty time
    /// ==============================
    test('handle empty time', () {
      final json = {
        'id': 3,
        'to': 'Bob',
        'message': 'Workout',
        'day': 'Wednesday',
        'time': '',
      };

      final reminder = _ReminderItem.fromJson(json);

      expect(reminder.time, '');
    });

    /// ==============================
    /// 4. null values
    /// ==============================
    test('handle null values safely', () {
      final json = {};

      final reminder = _ReminderItem.fromJson(json);

      expect(reminder.id, 0);
      expect(reminder.to, '');
      expect(reminder.message, '');
      expect(reminder.day, '');
      expect(reminder.time, '');
    });

    /// ==============================
    /// 5. invalid time format
    /// ==============================
    test('invalid time format stays same', () {
      final json = {
        'time': 'abc',
      };

      final reminder = _ReminderItem.fromJson(json);

      expect(reminder.time, 'abc');
    });

  });
}