import 'package:sociasync_app/config/api_config.dart';

/// Utility class for date formatting operations
class DateFormatter {
  /// Converts API date format (YYYY-MM-DD) to display format (D Mon YYYY)
  /// Example: '2001-01-24' -> '24 Jan 2001'
  static String formatApiDateToDisplay(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value; // Return original if can't parse
    }
    const monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${parsed.day} ${monthNames[parsed.month]} ${parsed.year}';
  }

  /// Converts display format (D Mon YYYY) to API format (YYYY-MM-DD)
  /// Example: '24 Jan 2001' -> '2001-01-24'
  static String formatDisplayDateToApi(String value) {
    try {
      final parts = value.split(' ');
      final months = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };
      final yyyy = int.parse(parts[2]);
      final mm = (months[parts[1]] ?? 1).toString().padLeft(2, '0');
      final dd = int.parse(parts[0]).toString().padLeft(2, '0');
      return '$yyyy-$mm-$dd';
    } catch (_) {
      return '';
    }
  }
}

/// Utility class for image URL operations
class ImageUrlResolver {
  /// Resolves profile image URL, handling relative and absolute paths
  /// - Returns null for empty or whitespace-only strings
  /// - Returns absolute URLs unchanged
  /// - Prepends base URL for relative paths
  static String? resolveProfileImageUrl(String raw) {
    if (raw.trim().isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    return '${ApiConfig.baseUrl}${raw.startsWith('/') ? raw : '/$raw'}';
  }
}
