import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/services/dashboard_logic.dart';

void main() {
  group('Dashboard Utils Test', () {
    test('asInt works correctly', () {
      expect(asInt(10), 10);
      expect(asInt('20'), 20);
      expect(asInt(null), 0);
      expect(asInt('abc'), 0);
    });

    test('asDouble works correctly', () {
      expect(asDouble(10.5), 10.5);
      expect(asDouble('20.5'), 20.5);
      expect(asDouble(null), 0.0);
      expect(asDouble('abc'), 0.0);
    });

    test('formatCompact works correctly', () {
      expect(formatCompact(500), '500');
      expect(formatCompact(1500), '1.5K');
      expect(formatCompact(1500000), '1.5M');
    });

    test('shortDayLabel works correctly', () {
      expect(shortDayLabel(DateTime(2024, 1, 1)), 'Mo');
      expect(shortDayLabel(null), '-');
    });

    test('firstNotEmpty works correctly', () {
      expect(firstNotEmpty(['', null, 'hello']), 'hello');
      expect(firstNotEmpty([null, '', '']), '');
    });
  });
}
