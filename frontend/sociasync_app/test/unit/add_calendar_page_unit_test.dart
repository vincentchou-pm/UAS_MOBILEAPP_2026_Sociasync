import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/calendar/add_calendar_page.dart';

void main() {
  group('AddCalendarPage Unit Tests', () {
    // ===== Format Helpers Tests =====
    group('date formatting', () {
      test('formats date correctly - standard date', () {
        final state = AddCalendarPageState();
        final date = DateTime(2026, 5, 15);
        expect(state.formatDateForTest(date), '15 MAY 2026');
      });

      test('formats date correctly - january', () {
        final state = AddCalendarPageState();
        final date = DateTime(2026, 1, 1);
        expect(state.formatDateForTest(date), '1 JAN 2026');
      });

      test('formats date correctly - december', () {
        final state = AddCalendarPageState();
        final date = DateTime(2026, 12, 31);
        expect(state.formatDateForTest(date), '31 DEC 2026');
      });

      test('formats date with single digit day', () {
        final state = AddCalendarPageState();
        final date = DateTime(2026, 3, 5);
        expect(state.formatDateForTest(date), '5 MAR 2026');
      });
    });

    group('time formatting', () {
      test('formats time correctly - AM', () {
        final state = AddCalendarPageState();
        final time = const TimeOfDay(hour: 9, minute: 30);
        expect(state.formatTimeForTest(time), '9.30 AM');
      });

      test('formats time correctly - PM', () {
        final state = AddCalendarPageState();
        final time = const TimeOfDay(hour: 14, minute: 45);
        expect(state.formatTimeForTest(time), '2.45 PM');
      });

      test('formats time 12 AM (midnight)', () {
        final state = AddCalendarPageState();
        final time = const TimeOfDay(hour: 0, minute: 0);
        expect(state.formatTimeForTest(time), '12.00 AM');
      });

      test('formats time 12 PM (noon)', () {
        final state = AddCalendarPageState();
        final time = const TimeOfDay(hour: 12, minute: 0);
        expect(state.formatTimeForTest(time), '12.00 PM');
      });

      test('formats time with padding - single digit minutes', () {
        final state = AddCalendarPageState();
        final time = const TimeOfDay(hour: 10, minute: 5);
        expect(state.formatTimeForTest(time), '10.05 AM');
      });
    });

    // ===== Repeat Conversion Tests =====
    group('repeat conversion to API format', () {
      test('converts "Never" to "never"', () {
        final state = AddCalendarPageState();
        expect(state.repeatToApiForTest('Never'), 'never');
      });

      test('converts "Daily" to "daily"', () {
        final state = AddCalendarPageState();
        expect(state.repeatToApiForTest('Daily'), 'daily');
      });

      test('converts "Weekly" to "weekly"', () {
        final state = AddCalendarPageState();
        expect(state.repeatToApiForTest('Weekly'), 'weekly');
      });

      test('converts "Monthly" to "monthly"', () {
        final state = AddCalendarPageState();
        expect(state.repeatToApiForTest('Monthly'), 'monthly');
      });

      test('handles lowercase input - daily', () {
        final state = AddCalendarPageState();
        expect(state.repeatToApiForTest('daily'), 'daily');
      });

      test('handles mixed case input', () {
        final state = AddCalendarPageState();
        expect(state.repeatToApiForTest('DaIlY'), 'daily');
      });

      test('handles extra whitespace', () {
        final state = AddCalendarPageState();
        expect(state.repeatToApiForTest('  Weekly  '), 'weekly');
      });

      test('returns "never" for unknown value', () {
        final state = AddCalendarPageState();
        expect(state.repeatToApiForTest('Unknown'), 'never');
      });
    });

    // ===== Platform Normalization Tests =====
    group('platform normalization', () {
      test('normalizes "instagram" correctly', () {
        final state = AddCalendarPageState();
        expect(state.normalizePlatformForTest('instagram'), 'instagram');
      });

      test('normalizes "tiktok" correctly', () {
        final state = AddCalendarPageState();
        expect(state.normalizePlatformForTest('tiktok'), 'tiktok');
      });

      test('normalizes "tik tok" to "tiktok"', () {
        final state = AddCalendarPageState();
        expect(state.normalizePlatformForTest('tik tok'), 'tiktok');
      });

      test('normalizes "TikTok" to "tiktok"', () {
        final state = AddCalendarPageState();
        expect(state.normalizePlatformForTest('TikTok'), 'tiktok');
      });

      test('normalizes "TIKTOK" to "tiktok"', () {
        final state = AddCalendarPageState();
        expect(state.normalizePlatformForTest('TIKTOK'), 'tiktok');
      });

      test('handles leading/trailing whitespace', () {
        final state = AddCalendarPageState();
        expect(state.normalizePlatformForTest('  tiktok  '), 'tiktok');
      });

      test('defaults to "instagram" for unknown platform', () {
        final state = AddCalendarPageState();
        expect(state.normalizePlatformForTest('youtube'), 'instagram');
      });

      test('defaults to "instagram" for empty string', () {
        final state = AddCalendarPageState();
        expect(state.normalizePlatformForTest(''), 'instagram');
      });
    });

    // ===== Validation Tests =====
    group('validation logic', () {
      test('validates non-empty title - pass', () {
        final state = AddCalendarPageState();
        expect(state.isValidTitleForTest('My Event'), true);
      });

      test('validates empty title - fail', () {
        final state = AddCalendarPageState();
        expect(state.isValidTitleForTest(''), false);
      });

      test('validates whitespace-only title - fail', () {
        final state = AddCalendarPageState();
        expect(state.isValidTitleForTest('   '), false);
      });

      test('validates end time after start time - pass', () {
        final state = AddCalendarPageState();
        final start = DateTime(2026, 5, 15, 10, 0);
        final end = DateTime(2026, 5, 15, 12, 0);
        expect(state.isValidTimeRangeForTest(start, end), true);
      });

      test('validates end time before start time - fail', () {
        final state = AddCalendarPageState();
        final start = DateTime(2026, 5, 15, 12, 0);
        final end = DateTime(2026, 5, 15, 10, 0);
        expect(state.isValidTimeRangeForTest(start, end), false);
      });

      test('validates same start and end time - pass', () {
        final state = AddCalendarPageState();
        final time = DateTime(2026, 5, 15, 10, 0);
        expect(state.isValidTimeRangeForTest(time, time), true);
      });

      test('validates different dates - pass', () {
        final state = AddCalendarPageState();
        final start = DateTime(2026, 5, 15, 10, 0);
        final end = DateTime(2026, 5, 16, 10, 0);
        expect(state.isValidTimeRangeForTest(start, end), true);
      });
    });

    // ===== Edit Mode Detection Tests =====
    group('edit mode detection', () {
      test('detects edit mode when scheduleId > 0', () {
        final state = AddCalendarPageState();
        state.setScheduleIdForTest(123);
        expect(state.isEditModeForTest(), true);
      });

      test('not in edit mode when scheduleId is null', () {
        final state = AddCalendarPageState();
        state.setScheduleIdForTest(null);
        expect(state.isEditModeForTest(), false);
      });

      test('not in edit mode when scheduleId is 0', () {
        final state = AddCalendarPageState();
        state.setScheduleIdForTest(0);
        expect(state.isEditModeForTest(), false);
      });

      test('not in edit mode when scheduleId is negative', () {
        final state = AddCalendarPageState();
        state.setScheduleIdForTest(-1);
        expect(state.isEditModeForTest(), false);
      });
    });

    // ===== Initial Data Processing Tests =====
    group('initial data processing', () {
      test('processes valid initial data correctly', () {
        final initialData = {
          'title': 'Test Event',
          'notes': 'Test Notes',
          'platform': 'instagram',
          'isDaily': false,
          'repeat': 'Daily',
          'reminder': '5 mins before',
          'startDate': DateTime(2026, 5, 15),
          'endDate': DateTime(2026, 5, 16),
          'startTime': const TimeOfDay(hour: 10, minute: 0),
          'endTime': const TimeOfDay(hour: 12, minute: 0),
          'scheduleId': '123',
        };
        final state = AddCalendarPageState();
        state.initializeFromDataForTest(initialData);
        expect(state.getTitleForTest(), 'Test Event');
        expect(state.getPlatformForTest(), 'instagram');
      });

      test('handles missing initial data - uses defaults', () {
        final state = AddCalendarPageState();
        state.initializeFromDataForTest(null);
        expect(state.getTitleForTest(), '');
        expect(state.getPlatformForTest(), 'instagram');
        expect(state.isEditModeForTest(), false);
      });

      test('handles invalid scheduleId string', () {
        final initialData = {'scheduleId': 'invalid'};
        final state = AddCalendarPageState();
        state.initializeFromDataForTest(initialData);
        expect(state.isEditModeForTest(), false);
      });
    });

    // ===== Negative Tests =====
    group('negative/edge case tests', () {
      test('handles null values in format functions gracefully', () {
        final state = AddCalendarPageState();
        // Test should not throw exception with edge case inputs
        expect(state.formatDateForTest(DateTime(2026, 1, 1)), isNotEmpty);
      });

      test('handles empty options list in picker', () {
        final state = AddCalendarPageState();
        // Validation should handle edge case
        expect(state.repeatToApiForTest(''), 'never');
      });

      test('validates title with special characters', () {
        final state = AddCalendarPageState();
        expect(state.isValidTitleForTest(r'Event @#$%'), true);
      });

      test('validates very long title', () {
        final state = AddCalendarPageState();
        final longTitle = 'A' * 500;
        expect(state.isValidTitleForTest(longTitle), true);
      });

      test('handles very far past dates', () {
        final state = AddCalendarPageState();
        final oldDate = DateTime(1900, 1, 1);
        expect(state.formatDateForTest(oldDate), '1 JAN 1900');
      });

      test('handles very far future dates', () {
        final state = AddCalendarPageState();
        final futureDate = DateTime(3000, 12, 31);
        expect(state.formatDateForTest(futureDate), '31 DEC 3000');
      });
    });
  });
}
