import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/services/fake_chat_reminder_service.dart';

void main() {
  group('ReminderItem Unit Test', () {
    test('fromJson mapping normal', () {
      final json = {
        'id': 1,
        'to': 'John',
        'message': 'Meeting',
        'day': 'Monday',
        'time': '10:30:00',
      };

      final reminder = ReminderItem.fromJson(json);

      expect(reminder.id, 1);
      expect(reminder.to, 'John');
      expect(reminder.message, 'Meeting');
      expect(reminder.day, 'Monday');
      expect(reminder.time, '10:30');
    });

    test('normalize time trims seconds', () {
      final reminder = ReminderItem.fromJson({'time': '09:15:59'});

      expect(reminder.time, '09:15');
    });

    test('handle empty time', () {
      final reminder = ReminderItem.fromJson({'time': ''});

      expect(reminder.time, '');
    });

    test('handle null values safely', () {
      final reminder = ReminderItem.fromJson({});

      expect(reminder.id, 0);
      expect(reminder.to, '');
      expect(reminder.message, '');
      expect(reminder.day, '');
      expect(reminder.time, '');
    });

    test('invalid time format stays same', () {
      final reminder = ReminderItem.fromJson({'time': 'abc'});

      expect(reminder.time, 'abc');
    });
  });
}
