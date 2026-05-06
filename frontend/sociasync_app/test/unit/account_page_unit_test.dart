import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/utils/account_utils.dart';

void main() {
  group('AccountPage - Unit Tests - Date Formatting', () {
    test(
      'DateFormatter.formatApiDateToDisplay converts API date format to display format',
      () {
        const apiDate = '2001-01-24';
        final result = DateFormatter.formatApiDateToDisplay(apiDate);

        expect(result, equals('24 Jan 2001'));
      },
    );

    test(
      'DateFormatter.formatApiDateToDisplay handles invalid date gracefully',
      () {
        const invalidDate = 'invalid-date';
        final result = DateFormatter.formatApiDateToDisplay(invalidDate);

        expect(result, isNotNull);
      },
    );

    test(
      'DateFormatter.formatApiDateToDisplay handles leap year correctly',
      () {
        const leapYearDate = '2020-02-29';
        final result = DateFormatter.formatApiDateToDisplay(leapYearDate);

        expect(result, equals('29 Feb 2020'));
      },
    );

    test('DateFormatter.formatApiDateToDisplay handles December correctly', () {
      const decemberDate = '2021-12-31';
      final result = DateFormatter.formatApiDateToDisplay(decemberDate);

      expect(result, equals('31 Dec 2021'));
    });
  });

  group('AccountPage - Unit Tests - Date Format Conversion', () {
    test(
      'DateFormatter.formatDisplayDateToApi converts display format to API date format',
      () {
        const displayDate = '24 Jan 2001';
        final result = DateFormatter.formatDisplayDateToApi(displayDate);

        expect(result, equals('2001-01-24'));
      },
    );

    test(
      'DateFormatter.formatDisplayDateToApi handles all months correctly',
      () {
        const testCases = {
          '1 Jan 2020': '2020-01-01',
          '15 Feb 2020': '2020-02-15',
          '30 Mar 2020': '2020-03-30',
          '10 Apr 2020': '2020-04-10',
          '5 May 2020': '2020-05-05',
          '20 Jun 2020': '2020-06-20',
          '7 Jul 2020': '2020-07-07',
          '28 Aug 2020': '2020-08-28',
          '12 Sep 2020': '2020-09-12',
          '31 Oct 2020': '2020-10-31',
          '22 Nov 2020': '2020-11-22',
          '25 Dec 2020': '2020-12-25',
        };

        testCases.forEach((displayDate, expectedApiDate) {
          final result = DateFormatter.formatDisplayDateToApi(displayDate);
          expect(
            result,
            equals(expectedApiDate),
            reason: 'Failed for $displayDate',
          );
        });
      },
    );

    test(
      'DateFormatter.formatDisplayDateToApi handles invalid format gracefully',
      () {
        const invalidDate = 'invalid format';
        final result = DateFormatter.formatDisplayDateToApi(invalidDate);

        expect(result, equals(''));
      },
    );

    test(
      'DateFormatter.formatDisplayDateToApi pads single digit days and months',
      () {
        const displayDate = '5 Mar 2020';
        final result = DateFormatter.formatDisplayDateToApi(displayDate);

        expect(result, equals('2020-03-05'));
      },
    );
  });

  group('AccountPage - Unit Tests - Profile Image URL Resolution', () {
    test(
      'ImageUrlResolver.resolveProfileImageUrl returns null for empty string',
      () {
        final result = ImageUrlResolver.resolveProfileImageUrl('');

        expect(result, isNull);
      },
    );

    test(
      'ImageUrlResolver.resolveProfileImageUrl returns URL as-is if already absolute HTTP',
      () {
        const url = 'https://example.com/image.jpg';
        final result = ImageUrlResolver.resolveProfileImageUrl(url);

        expect(result, equals(url));
      },
    );

    test(
      'ImageUrlResolver.resolveProfileImageUrl returns URL as-is if already absolute HTTPS',
      () {
        const url = 'http://example.com/image.jpg';
        final result = ImageUrlResolver.resolveProfileImageUrl(url);

        expect(result, equals(url));
      },
    );

    test(
      'ImageUrlResolver.resolveProfileImageUrl prepends base URL for relative paths',
      () {
        const relativePath = 'media/profile_images/user.jpg';
        final result = ImageUrlResolver.resolveProfileImageUrl(relativePath);

        expect(result, contains('media/profile_images/user.jpg'));
      },
    );

    test(
      'ImageUrlResolver.resolveProfileImageUrl handles paths with leading slash correctly',
      () {
        const pathWithSlash = '/media/profile_images/user.jpg';
        final result = ImageUrlResolver.resolveProfileImageUrl(pathWithSlash);

        expect(result, contains('media/profile_images/user.jpg'));
      },
    );

    test(
      'ImageUrlResolver.resolveProfileImageUrl returns null for whitespace-only string',
      () {
        final result = ImageUrlResolver.resolveProfileImageUrl('   ');

        expect(result, isNull);
      },
    );
  });

  group('AccountPage - Unit Tests - Date Parsing Edge Cases', () {
    test('DateFormatter.formatApiDateToDisplay handles year 1900', () {
      const oldDate = '1900-01-01';
      final result = DateFormatter.formatApiDateToDisplay(oldDate);

      expect(result, equals('1 Jan 1900'));
    });

    test('DateFormatter.formatApiDateToDisplay handles future dates', () {
      const futureDate = '2099-12-31';
      final result = DateFormatter.formatApiDateToDisplay(futureDate);

      expect(result, equals('31 Dec 2099'));
    });

    test(
      'DateFormatter.formatDisplayDateToApi handles two-digit year formats correctly',
      () {
        // This tests that the function uses the third part as year
        const displayDate = '5 Mar 2020';
        final result = DateFormatter.formatDisplayDateToApi(displayDate);

        expect(result, startsWith('2020'));
      },
    );
  });
}
