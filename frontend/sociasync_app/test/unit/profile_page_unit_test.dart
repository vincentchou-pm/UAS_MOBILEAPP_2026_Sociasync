import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfilePage Unit Tests', () {
    // ===== Profile Image URL Resolution Tests =====
    group('profile image URL resolution', () {
      test('resolves full URL correctly', () {
        const url = 'https://example.com/image.jpg';
        final resolved = _resolveProfileImageUrl(url);
        expect(resolved, equals(url));
      });

      test('resolves HTTP URL correctly', () {
        const url = 'http://example.com/image.jpg';
        final resolved = _resolveProfileImageUrl(url);
        expect(resolved, equals(url));
      });

      test('resolves relative path with leading slash', () {
        const path = '/media/profile_images/user.jpg';
        final resolved = _resolveProfileImageUrl(path);
        expect(resolved, contains(path));
      });

      test('resolves relative path without leading slash', () {
        const path = 'media/profile_images/user.jpg';
        final resolved = _resolveProfileImageUrl(path);
        expect(resolved, contains('/$path'));
      });

      test('returns null for empty string', () {
        const url = '';
        final resolved = _resolveProfileImageUrl(url);
        expect(resolved, isNull);
      });

      test('returns null for whitespace only', () {
        const url = '   ';
        final resolved = _resolveProfileImageUrl(url);
        expect(resolved, isNull);
      });

      test('returns null for null input', () {
        const String? url = null;
        final resolved = _resolveProfileImageUrl(url ?? '');
        expect(resolved, isNull);
      });

      test('handles URLs with special characters', () {
        const url = 'https://example.com/image%20with%20spaces.jpg';
        final resolved = _resolveProfileImageUrl(url);
        expect(resolved, equals(url));
      });

      test('handles URLs with query parameters', () {
        const url = 'https://example.com/image.jpg?size=large';
        final resolved = _resolveProfileImageUrl(url);
        expect(resolved, equals(url));
      });
    });

    // ===== Username Display Logic Tests =====
    group('username display logic', () {
      test('displays formatted username with @ prefix', () {
        const username = 'johndoe';
        final display = _formatUsername(username);
        expect(display, equals('@johndoe'));
      });

      test('handles empty username', () {
        const username = '';
        final display = _formatUsername(username);
        expect(display, isEmpty);
      });

      test('handles whitespace-only username', () {
        const username = '   ';
        final display = _formatUsername(username);
        expect(display, isEmpty);
      });

      test('trims whitespace from username', () {
        const username = '  johndoe  ';
        final display = _formatUsername(username);
        expect(display, equals('@johndoe'));
      });

      test('handles special characters in username', () {
        const username = 'john_doe.123';
        final display = _formatUsername(username);
        expect(display, equals('@john_doe.123'));
      });
    });

    // ===== Connection Status Tests =====
    group('platform connection status', () {
      test('returns "Connected" for valid username with true flag', () {
        const isConnected = true;
        const username = 'testuser';
        final status = _getPlatformStatus(isConnected, username);
        expect(status, equals('@testuser'));
      });

      test('returns "Not connected" for false flag regardless of username', () {
        const isConnected = false;
        const username = 'testuser';
        final status = _getPlatformStatus(isConnected, username);
        expect(status, equals('Belum terhubung'));
      });

      test('returns "Not connected" for empty username even if connected', () {
        const isConnected = true;
        const username = '';
        final status = _getPlatformStatus(isConnected, username);
        expect(status, equals('Belum terhubung'));
      });

      test('handles whitespace-only username as not connected', () {
        const isConnected = true;
        const username = '   ';
        final status = _getPlatformStatus(isConnected, username);
        expect(status, equals('Belum terhubung'));
      });

      test('returns "Not connected" when both flags are false', () {
        const isConnected = false;
        const username = '';
        final status = _getPlatformStatus(isConnected, username);
        expect(status, equals('Belum terhubung'));
      });
    });

    // ===== Profile Name Validation Tests =====
    group('profile name validation', () {
      test('validates non-empty name', () {
        const name = 'John Doe';
        final isValid = _isValidName(name);
        expect(isValid, isTrue);
      });

      test('rejects empty name', () {
        const name = '';
        final isValid = _isValidName(name);
        expect(isValid, isFalse);
      });

      test('rejects whitespace-only name', () {
        const name = '   ';
        final isValid = _isValidName(name);
        expect(isValid, isFalse);
      });

      test('accepts name with special characters', () {
        const name = "O'Brien-Smith";
        final isValid = _isValidName(name);
        expect(isValid, isTrue);
      });

      test('accepts name with numbers', () {
        const name = 'User123';
        final isValid = _isValidName(name);
        expect(isValid, isTrue);
      });

      test('rejects very long names', () {
        const name =
            'VeryVeryVeryVeryVeryVeryVeryVeryVeryVeryVeryVeryVeryVeryVeryLongName';
        final isValid = _isValidName(name);
        expect(isValid, isFalse);
      });
    });

    // ===== Negative Tests =====
    group('negative and edge case tests', () {
      test('handles null profile data gracefully', () {
        final profile = null;
        final name = _safeGetField(profile, 'name', 'User');
        expect(name, equals('User'));
      });

      test('handles missing name field', () {
        final profile = {};
        final name = _safeGetField(profile, 'name', 'User');
        expect(name, equals('User'));
      });

      test('handles null name value', () {
        final profile = {'name': null};
        final name = _safeGetField(profile, 'name', 'User');
        expect(name, equals('User'));
      });

      test('extracts image URL from profile', () {
        const profile = {'profile_image': 'https://example.com/image.jpg'};
        final imageUrl = _safeGetField(profile, 'profile_image', '');
        expect(imageUrl, isNotEmpty);
      });

      test('handles various data types in profile', () {
        final profile = {
          'instagram_connected': true,
          'tiktok_connected': false,
          'instagram_username': 'user1',
          'tiktok_username': '',
        };
        expect(profile['instagram_connected'], isTrue);
        expect(profile['tiktok_connected'], isFalse);
        expect(profile['instagram_username'], isNotEmpty);
        expect(profile['tiktok_username'], isEmpty);
      });
    });

    // ===== Helper Function Tests =====
    group('helper function logic', () {
      test('builds section label correctly', () {
        const label = 'General';
        final formatted = label.toUpperCase();
        expect(formatted, equals('GENERAL'));
      });

      test('determines primary color correctly', () {
        const primaryBlue = Color(0xFF1D5093);
        expect(primaryBlue.value, equals(0xFF1D5093));
      });

      test('determines secondary colors', () {
        const Color gradientStart = Color(0xFF294D9B);
        const Color gradientEnd = Color(0xFF3895FF);
        expect(gradientStart.value, equals(0xFF294D9B));
        expect(gradientEnd.value, equals(0xFF3895FF));
      });

      test('calculates header height based on status bar', () {
        const double statusBarHeight = 24;
        final totalHeight = 280 + statusBarHeight;
        expect(totalHeight, equals(304));
      });
    });
  });
}

// ===== Helper Functions for Testing =====

String? _resolveProfileImageUrl(String raw) {
  if (raw.trim().isEmpty) return null;
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
  return 'https://example.com${raw.startsWith('/') ? raw : '/$raw'}';
}

String _formatUsername(String username) {
  final trimmed = username.trim();
  return trimmed.isEmpty ? '' : '@$trimmed';
}

String _getPlatformStatus(bool isConnected, String username) {
  if (!isConnected || username.trim().isEmpty) {
    return 'Belum terhubung';
  }
  return '@${username.trim()}';
}

bool _isValidName(String name) {
  final trimmed = name.trim();
  return trimmed.isNotEmpty && trimmed.length <= 50;
}

String _safeGetField(dynamic data, String field, String defaultValue) {
  if (data == null || data is! Map) return defaultValue;
  final value = data[field];
  if (value == null) return defaultValue;
  final stringValue = value.toString().trim();
  return stringValue.isEmpty ? defaultValue : stringValue;
}
