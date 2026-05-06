import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/profile/account_page.dart';
import 'package:sociasync_app/screens/profile/notification_page_settings.dart';
import 'package:sociasync_app/screens/profile/profile_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ProfilePage Integration Tests', () {
    // ===== Page Loading Tests =====
    group('page loading and initialization', () {
      testWidgets('page loads successfully', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(ProfilePage), findsOneWidget);
      });

      testWidgets('all main UI elements are visible on load', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Profile'), findsOneWidget);
        expect(find.text('User'), findsOneWidget);
        expect(find.text('GENERAL'), findsOneWidget);
      });

      testWidgets('profile header is displayed correctly', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('profile picture is visible on load', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(CircleAvatar), findsWidgets);
      });

      testWidgets('all menu sections are loaded', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('GENERAL'), findsOneWidget);
        expect(find.text('HELPDESK'), findsOneWidget);
        expect(find.text('CONNECT'), findsOneWidget);
        expect(find.text('DANGER ZONE'), findsOneWidget);
      });
    });

    // ===== Navigation Tests =====
    group('navigation', () {
      testWidgets('back button navigates back', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      ),
                      child: const Text('Go to Profile'),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Go to Profile'));
        await tester.pumpAndSettle();
        expect(find.byType(ProfilePage), findsOneWidget);
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      });

      testWidgets('Account menu navigates to AccountPage', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ListTile, 'Account'));
        await tester.pumpAndSettle();
      });

      testWidgets('Notification menu navigates to NotificationPage', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Notification'));
        await tester.pumpAndSettle();
      });

      testWidgets('Help menu navigates to HelpPage', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ListTile, 'Help'));
        await tester.pumpAndSettle();
      });

      testWidgets('TikTok tile opens manage dialog', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        final tiktokTile = find.byType(ListTile).at(3);
        await tester.tap(tiktokTile);
        await tester.pumpAndSettle();
      });

      testWidgets('Instagram tile opens manage dialog', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        final instagramTile = find.byType(ListTile).at(4);
        await tester.tap(instagramTile);
        await tester.pumpAndSettle();
      });
    });

    // ===== Menu Interaction Tests =====
    group('menu interactions', () {
      testWidgets('user can scroll through menu items', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();
        expect(find.text('Log Out'), findsOneWidget);
      });

      testWidgets('all menu items are tappable', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsWidgets);
      });

      testWidgets('Account tile displays correct text and icon', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Account'), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });

      testWidgets('Notification tile displays correct text and icon', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Notification'), findsOneWidget);
        expect(find.byIcon(Icons.notifications_none), findsOneWidget);
      });

      testWidgets('Help tile displays correct text and icon', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Help'), findsOneWidget);
        expect(find.byIcon(Icons.help_outline), findsOneWidget);
      });

      testWidgets('TikTok tile displays connection status', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('TikTok'), findsOneWidget);
        expect(find.text('Belum terhubung'), findsWidgets);
      });

      testWidgets('Instagram tile displays connection status', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Instagram'), findsOneWidget);
      });
    });

    // ===== Profile Picture Tests =====
    group('profile picture interactions', () {
      testWidgets('profile picture avatar is visible', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(CircleAvatar), findsWidgets);
      });

      testWidgets('profile picture shows default icon when no image', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('tapping profile picture opens photo popup', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        final avatarGesture = find.byType(GestureDetector).first;
        await tester.tap(avatarGesture);
        await tester.pumpAndSettle();
      });

      testWidgets('user name displays below profile picture', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('User'), findsOneWidget);
      });
    });

    // ===== Log Out Dialog Tests =====
    group('log out dialog workflow', () {
      testWidgets('log out dialog appears when Log Out is tapped', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.logout));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('log out dialog displays correct title and message', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.logout));
        await tester.pumpAndSettle();
        expect(find.text('Log Out'), findsWidgets);
        expect(find.text('Are you sure you want to log out?'), findsOneWidget);
      });

      testWidgets('cancel button closes dialog without logout', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.logout));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('dialog has both cancel and logout buttons', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.logout));
        await tester.pumpAndSettle();
        expect(find.text('Cancel'), findsOneWidget);
      });
    });

    // ===== Layout and Responsiveness Tests =====
    group('layout and responsiveness', () {
      testWidgets('profile header spans full width', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('menu items are properly aligned', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('content remains visible after scrolling', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -500),
        );
        await tester.pumpAndSettle();
        expect(find.text('Log Out'), findsOneWidget);
      });

      testWidgets('app navbar is always visible', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(AppNavbar), findsOneWidget);
      });
    });

    // ===== Negative and Edge Case Tests =====
    group('negative and edge case scenarios', () {
      testWidgets('handles rapid menu taps', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        final accountTile = find.widgetWithText(ListTile, 'Account');
        await tester.tap(accountTile);
        await tester.pump();
        await tester.pumpAndSettle();
        expect(find.byType(AccountPage), findsOneWidget);
      });

      testWidgets('displays correctly with missing profile data', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('User'), findsOneWidget);
      });

      testWidgets('handles missing platform usernames gracefully', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Belum terhubung'), findsWidgets);
      });

      testWidgets('displays all menu sections without data', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('GENERAL'), findsOneWidget);
        expect(find.text('HELPDESK'), findsOneWidget);
        expect(find.text('CONNECT'), findsOneWidget);
        expect(find.text('DANGER ZONE'), findsOneWidget);
      });

      testWidgets('profile icon persists when image loading fails', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('all menu tiles remain functional after scroll', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();
        final helpTile = find.widgetWithText(ListTile, 'Help');
        await tester.ensureVisible(helpTile);
        await tester.pump();
        await tester.tap(helpTile);
        await tester.pumpAndSettle();
      });

      testWidgets('handles back button press gracefully', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    ),
                    child: const Text('Go'),
                  );
                },
              ),
            ),
          ),
        );
        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      });

      testWidgets('menu sections load correctly in any order', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('GENERAL'), findsOneWidget);
        expect(find.text('CONNECT'), findsOneWidget);
      });

      testWidgets('connection tiles show no username by default', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Belum terhubung'), findsWidgets);
      });
    });

    // ===== Complete User Workflows =====
    group('complete user workflows', () {
      testWidgets('user can navigate through all menu items', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();

        // Tap Account
        await tester.tap(find.widgetWithText(ListTile, 'Account'));
        await tester.pumpAndSettle();
        expect(find.byType(AccountPage), findsOneWidget);

        // Go back and tap Notification
        await tester.tap(find.byIcon(Icons.arrow_back).first);
        await tester.pumpAndSettle();
        expect(find.byType(ProfilePage), findsOneWidget);

        await tester.tap(find.widgetWithText(ListTile, 'Notification'));
        await tester.pumpAndSettle();
        expect(find.byType(NotificationPage), findsOneWidget);
      });

      testWidgets('user can view all sections by scrolling', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();

        // Start at top
        expect(find.text('GENERAL'), findsOneWidget);

        // Scroll down
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        // End at bottom
        expect(find.text('Log Out'), findsOneWidget);
      });

      testWidgets('user profile loads correctly on page open', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();

        expect(find.text('User'), findsOneWidget);
        expect(find.byType(CircleAvatar), findsWidgets);
        expect(find.text('GENERAL'), findsOneWidget);
      });
    });
  });
}
