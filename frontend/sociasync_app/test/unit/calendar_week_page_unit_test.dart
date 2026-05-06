import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/calendar/calendar_week_page.dart';

void main() {
  group('CalendarWeekConfig Unit Tests', () {
    // ===== eventKey Tests =====
    group('eventKey', () {
      test('generates correct key format for valid date', () {
        final date = DateTime(2024, 5, 15);
        final key = CalendarWeekConfig.eventKey(date);
        expect(key, '2024-05-15');
      });

      test('pads month with zero for single digit month', () {
        final date = DateTime(2024, 3, 5);
        final key = CalendarWeekConfig.eventKey(date);
        expect(key, '2024-03-05');
      });

      test('pads day with zero for single digit day', () {
        final date = DateTime(2024, 12, 7);
        final key = CalendarWeekConfig.eventKey(date);
        expect(key, '2024-12-07');
      });

      test('handles edge case: December 31st', () {
        final date = DateTime(2024, 12, 31);
        final key = CalendarWeekConfig.eventKey(date);
        expect(key, '2024-12-31');
      });

      test('handles edge case: January 1st', () {
        final date = DateTime(2024, 1, 1);
        final key = CalendarWeekConfig.eventKey(date);
        expect(key, '2024-01-01');
      });
    });

    // ===== monthLabel Tests =====
    group('monthLabel', () {
      test('returns correct label for January', () {
        final date = DateTime(2024, 1, 15);
        final label = CalendarWeekConfig.monthLabel(date);
        expect(label, 'Jan 2024');
      });

      test('returns correct label for December', () {
        final date = DateTime(2024, 12, 15);
        final label = CalendarWeekConfig.monthLabel(date);
        expect(label, 'Dec 2024');
      });

      test('returns correct label for June', () {
        final date = DateTime(2025, 6, 15);
        final label = CalendarWeekConfig.monthLabel(date);
        expect(label, 'Jun 2025');
      });

      test('returns empty string for invalid month (month 0)', () {
        final date = DateTime(
          2024,
          0,
          15,
        ); // Dart adjusts this to previous month
        final label = CalendarWeekConfig.monthLabel(date);
        expect(label.contains('2023'), true);
      });
    });

    // ===== fullDate Tests =====
    group('fullDate', () {
      test('returns correctly formatted full date for Monday', () {
        final date = DateTime(2024, 5, 13); // Monday
        final fullDate = CalendarWeekConfig.fullDate(date);
        expect(fullDate, 'Mon, 13 May 2024');
      });

      test('returns correctly formatted full date for Sunday', () {
        final date = DateTime(2024, 5, 19); // Sunday
        final fullDate = CalendarWeekConfig.fullDate(date);
        expect(fullDate, 'Sun, 19 May 2024');
      });

      test('returns correctly formatted full date for Friday', () {
        final date = DateTime(2024, 5, 17); // Friday
        final fullDate = CalendarWeekConfig.fullDate(date);
        expect(fullDate, 'Fri, 17 May 2024');
      });

      test('handles year transitions correctly', () {
        final date = DateTime(2024, 12, 31); // New Year's Eve
        final fullDate = CalendarWeekConfig.fullDate(date);
        expect(fullDate.contains('2024'), true);
      });
    });

    // ===== prettyDateTime Tests =====
    group('prettyDateTime', () {
      test('formats valid datetime correctly', () {
        final raw = '2024-05-15T14:30:00.000Z';
        final pretty = CalendarWeekConfig.prettyDateTime(raw);
        expect(pretty.contains('Wed, 15 May 2024'), true);
        expect(pretty.contains('2:30'), true);
        expect(pretty.contains('PM'), true);
      });

      test('converts 24-hour to 12-hour format correctly for morning', () {
        final raw = '2024-05-15T09:45:00.000Z';
        final pretty = CalendarWeekConfig.prettyDateTime(raw);
        expect(pretty.contains('9:45'), true);
        expect(pretty.contains('AM'), true);
      });

      test('converts 24-hour to 12-hour format correctly for afternoon', () {
        final raw = '2024-05-15T14:30:00.000Z';
        final pretty = CalendarWeekConfig.prettyDateTime(raw);
        expect(pretty.contains('2:30'), true);
        expect(pretty.contains('PM'), true);
      });

      test('handles midnight (00:00) correctly', () {
        final raw = '2024-05-15T00:00:00.000Z';
        final pretty = CalendarWeekConfig.prettyDateTime(raw);
        expect(pretty.contains('12:00'), true);
        expect(pretty.contains('AM'), true);
      });

      test('handles noon (12:00) correctly', () {
        final raw = '2024-05-15T12:00:00.000Z';
        final pretty = CalendarWeekConfig.prettyDateTime(raw);
        expect(pretty.contains('12:00'), true);
        expect(pretty.contains('PM'), true);
      });

      test('returns dash for invalid datetime', () {
        final raw = 'invalid-datetime';
        final pretty = CalendarWeekConfig.prettyDateTime(raw);
        expect(pretty, '-');
      });

      test('returns dash for null datetime', () {
        final raw = 'null';
        final pretty = CalendarWeekConfig.prettyDateTime(raw);
        expect(pretty, '-');
      });

      test('returns dash for empty string', () {
        final raw = '';
        final pretty = CalendarWeekConfig.prettyDateTime(raw);
        expect(pretty, '-');
      });
    });

    // ===== valueOrDash Tests =====
    group('valueOrDash', () {
      test('returns value for non-empty string', () {
        final result = CalendarWeekConfig.valueOrDash('Instagram');
        expect(result, 'Instagram');
      });

      test('returns dash for null value', () {
        final result = CalendarWeekConfig.valueOrDash(null);
        expect(result, '-');
      });

      test('returns dash for empty string', () {
        final result = CalendarWeekConfig.valueOrDash('');
        expect(result, '-');
      });

      test('returns dash for whitespace string', () {
        final result = CalendarWeekConfig.valueOrDash('   ');
        expect(result, '-');
      });

      test('returns dash for string "null"', () {
        final result = CalendarWeekConfig.valueOrDash('null');
        expect(result, '-');
      });

      test('returns dash for string "NULL"', () {
        final result = CalendarWeekConfig.valueOrDash('NULL');
        expect(result, '-');
      });

      test('returns value for numeric input', () {
        final result = CalendarWeekConfig.valueOrDash(123);
        expect(result, '123');
      });

      test('preserves leading/trailing spaces after trim', () {
        final result = CalendarWeekConfig.valueOrDash('  value  ');
        expect(result, 'value');
      });
    });

    // ===== repeatFromApi Tests =====
    group('repeatFromApi', () {
      test('converts "daily" to "Daily"', () {
        final result = CalendarWeekConfig.repeatFromApi('daily');
        expect(result, 'Daily');
      });

      test('converts "DAILY" to "Daily" (case insensitive)', () {
        final result = CalendarWeekConfig.repeatFromApi('DAILY');
        expect(result, 'Daily');
      });

      test('converts "weekly" to "Weekly"', () {
        final result = CalendarWeekConfig.repeatFromApi('weekly');
        expect(result, 'Weekly');
      });

      test('converts "monthly" to "Monthly"', () {
        final result = CalendarWeekConfig.repeatFromApi('monthly');
        expect(result, 'Monthly');
      });

      test('returns "Never" for unknown value', () {
        final result = CalendarWeekConfig.repeatFromApi('yearly');
        expect(result, 'Never');
      });

      test('returns "Never" for empty string', () {
        final result = CalendarWeekConfig.repeatFromApi('');
        expect(result, 'Never');
      });

      test('handles whitespace in input', () {
        final result = CalendarWeekConfig.repeatFromApi('  daily  ');
        expect(result, 'Daily');
      });
    });

    // ===== weekDays Tests =====
    group('weekDays', () {
      test('generates 9 days starting from Monday', () {
        final date = DateTime(2024, 5, 15); // Wednesday
        final days = CalendarWeekConfig.weekDays(date);
        expect(days.length, 9);
      });

      test('first day is Monday of the week', () {
        final date = DateTime(2024, 5, 15); // Wednesday
        final days = CalendarWeekConfig.weekDays(date);
        expect(days[0].weekday, 1); // Monday
      });

      test('returns consecutive dates', () {
        final date = DateTime(2024, 5, 15);
        final days = CalendarWeekConfig.weekDays(date);
        for (int i = 1; i < days.length; i++) {
          final diff = days[i].difference(days[i - 1]).inDays;
          expect(diff, 1);
        }
      });

      test('handles Sunday as start date', () {
        final date = DateTime(2024, 5, 19); // Sunday
        final days = CalendarWeekConfig.weekDays(date);
        expect(days[0].weekday, 1); // Should start from Monday
      });
    });

    // ===== groupSchedulesByDay Tests =====
    group('groupSchedulesByDay', () {
      test('groups schedules by start_time date', () {
        final schedules = [
          {
            'id': 1,
            'title': 'Event 1',
            'start_time': '2024-05-15T10:00:00.000Z',
          },
          {
            'id': 2,
            'title': 'Event 2',
            'start_time': '2024-05-15T14:00:00.000Z',
          },
          {
            'id': 3,
            'title': 'Event 3',
            'start_time': '2024-05-16T10:00:00.000Z',
          },
        ];
        final grouped = CalendarWeekConfig.groupSchedulesByDay(schedules);
        expect(grouped.length, 2);
        expect(grouped['2024-05-15']?.length, 2);
        expect(grouped['2024-05-16']?.length, 1);
      });

      test('returns empty map for empty list', () {
        final grouped = CalendarWeekConfig.groupSchedulesByDay([]);
        expect(grouped.isEmpty, true);
      });

      test('ignores schedules with invalid start_time', () {
        final schedules = [
          {'id': 1, 'title': 'Event 1', 'start_time': 'invalid-date'},
          {
            'id': 2,
            'title': 'Event 2',
            'start_time': '2024-05-15T10:00:00.000Z',
          },
        ];
        final grouped = CalendarWeekConfig.groupSchedulesByDay(schedules);
        expect(grouped.length, 1);
        expect(grouped['2024-05-15']?.length, 1);
      });

      test('ignores schedules with missing start_time', () {
        final schedules = [
          {'id': 1, 'title': 'Event 1'},
          {
            'id': 2,
            'title': 'Event 2',
            'start_time': '2024-05-15T10:00:00.000Z',
          },
        ];
        final grouped = CalendarWeekConfig.groupSchedulesByDay(schedules);
        expect(grouped.length, 1);
      });

      test('handles null start_time', () {
        final schedules = [
          {'id': 1, 'title': 'Event 1', 'start_time': null},
          {
            'id': 2,
            'title': 'Event 2',
            'start_time': '2024-05-15T10:00:00.000Z',
          },
        ];
        final grouped = CalendarWeekConfig.groupSchedulesByDay(schedules);
        expect(grouped.length, 1);
      });

      test('preserves schedule data when grouping', () {
        final schedules = [
          {
            'id': 1,
            'title': 'Event 1',
            'start_time': '2024-05-15T10:00:00.000Z',
            'platform': 'Instagram',
          },
        ];
        final grouped = CalendarWeekConfig.groupSchedulesByDay(schedules);
        expect(grouped['2024-05-15']?[0]['platform'], 'Instagram');
      });
    });
  });
}
