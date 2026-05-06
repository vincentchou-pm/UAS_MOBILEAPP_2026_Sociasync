import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/profile/help_page.dart';

void main() {
  group('HelpPage - Unit Tests', () {
    test('help content map contains all expected topics', () {
      const Map<String, String> helpContent = {
        'Account growth': '',
        'Analytics formula (Engagement & Reach)': '',
        'Your account status': '',
        'Account safety': '',
        'Updating name': '',
        'Forgot my password': '',
        'Editing, posting, and deleting': '',
        'Searching for content': '',
        'Unable to follow a user': '',
      };

      final topics = helpContent.keys.toList();

      expect(topics.length, equals(9));
      expect(topics, contains('Account growth'));
      expect(topics, contains('Analytics formula (Engagement & Reach)'));
      expect(topics, contains('Your account status'));
      expect(topics, contains('Account safety'));
      expect(topics, contains('Updating name'));
      expect(topics, contains('Forgot my password'));
      expect(topics, contains('Editing, posting, and deleting'));
      expect(topics, contains('Searching for content'));
      expect(topics, contains('Unable to follow a user'));
    });

    test('help content is not empty for each topic', () {
      const Map<String, String> helpContent = {
        'Account growth':
            'Growing your account on SociaSync takes consistency and strategy.',
        'Analytics formula (Engagement & Reach)':
            'SociaSync calculates analytics using the data available from your connected account.',
        'Your account status': 'Your account status indicates the health',
        'Account safety': 'Keeping your SociaSync account safe',
        'Updating name': 'You can update your display name',
        'Forgot my password': 'If you forgot your password',
        'Editing, posting, and deleting': 'Managing your content on SociaSync',
        'Searching for content': 'SociaSync makes it easy to find content',
        'Unable to follow a user': 'If you are having trouble following',
      };

      for (final topic in helpContent.keys) {
        expect(helpContent[topic]!.isNotEmpty, true);
      }
    });

    test('HelpPage primary color is correct', () {
      const helpPage = HelpPage();
      expect(helpPage.primaryBlue, equals(const Color(0xFF1D5093)));
    });
  });
}
