import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/calendar/calendar_month_page.dart';

void main() {
  group('CalendarMonthPage - Unit Tests', () {
    test('uses 2026 as the displayed calendar year', () {
      expect(CalendarMonthConfig.currentYear, 2026);
    });

    test('uses March as the highlighted current month', () {
      expect(CalendarMonthConfig.currentMonth, 3);
      expect(CalendarMonthConfig.monthNames[3], 'MARCH');
    });

    test('contains all 12 mini month labels in display order', () {
      expect(CalendarMonthConfig.monthNames.skip(1).toList(), [
        'JANUARY',
        'FEBRUARY',
        'MARCH',
        'APRIL',
        'MAY',
        'JUNE',
        'JULY',
        'AUGUST',
        'SEPTEMBER',
        'OCTOBER',
        'NOVEMBER',
        'DECEMBER',
      ]);
    });

    test('calculates mini month day grid values for March 2026', () {
      expect(CalendarMonthConfig.daysInMonth(3), 31);
      expect(CalendarMonthConfig.startOffset(3), 0);
    });

    test('calculates mini month day grid values for February 2026', () {
      expect(CalendarMonthConfig.daysInMonth(2), 28);
      expect(CalendarMonthConfig.startOffset(2), 0);
    });

    test('calculates mini month day grid values for January 2026', () {
      expect(CalendarMonthConfig.daysInMonth(1), 31);
      expect(CalendarMonthConfig.startOffset(1), 4);
    });

    test('calculates leap year February correctly', () {
      expect(CalendarMonthConfig.daysInMonth(2, 2028), 29);
      expect(CalendarMonthConfig.startOffset(2, 2028), 2);
    });

    test('calculates mini month day grid offset when month starts midweek', () {
      expect(CalendarMonthConfig.daysInMonth(4), 30);
      expect(CalendarMonthConfig.startOffset(4), 3);
    });

    test('rejects invalid month values to catch accidental bad input', () {
      expect(() => CalendarMonthConfig.daysInMonth(0), throwsRangeError);
      expect(() => CalendarMonthConfig.daysInMonth(13), throwsRangeError);
      expect(() => CalendarMonthConfig.startOffset(0), throwsRangeError);
      expect(() => CalendarMonthConfig.startOffset(13), throwsRangeError);
    });
  });
}
