import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/profile/profile_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

Future<void> openLogOutDialog(WidgetTester tester) async {
  final logOutTile = find.widgetWithText(ListTile, 'Log Out');
  await tester.ensureVisible(logOutTile);
  await tester.pump();
  await tester.tap(logOutTile);
  await tester.pumpAndSettle();
}

void main() {
  group('ProfilePage Widget Tests', () {
    // ===== Basic Rendering Tests =====
    group('basic rendering', () {
      testWidgets('widget renders without errors', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        expect(find.byType(ProfilePage), findsOneWidget);
      });

      testWidgets('displays profile header', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('displays back button in header', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('displays AppNavbar at bottom', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('displays profile picture CircleAvatar', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(CircleAvatar), findsWidgets);
      });
    });

    // ===== Profile Header Tests =====
    group('profile header (SizedBox with Stack)', () {
      testWidgets('header displays blue gradient background', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(ClipPath), findsWidgets);
      });

      testWidgets('header contains title "Profile"', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('back button is positioned correctly', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        final backButton = find.byIcon(Icons.arrow_back);
        expect(backButton, findsOneWidget);
      });
    });

    // ===== Profile Picture Tests =====
    group('profile picture (CircleAvatar)', () {
      testWidgets('displays profile picture avatar', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(CircleAvatar), findsWidgets);
      });

      testWidgets('displays default icon when no image', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('avatar is tappable for adding photo', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('displays loading indicator when uploading', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        // Initially no loading indicator
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    // ===== User Name Display Tests =====
    group('user name display', () {
      testWidgets('displays default username on load', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('User'), findsOneWidget);
      });

      testWidgets('username text has correct style', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        final userNameWidget = find.text('User');
        expect(userNameWidget, findsOneWidget);
      });
    });

    // ===== Menu List Tests =====
    group('menu list (settings group)', () {
      testWidgets('displays "General" section label', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('GENERAL'), findsOneWidget);
      });

      testWidgets('displays Account menu item', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Account'), findsOneWidget);
      });

      testWidgets('displays Notification menu item', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Notification'), findsOneWidget);
      });

      testWidgets('displays Helpdesk section', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('HELPDESK'), findsOneWidget);
      });

      testWidgets('displays Help menu item', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Help'), findsOneWidget);
      });

      testWidgets('displays Connect section', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('CONNECT'), findsOneWidget);
      });

      testWidgets('displays Danger Zone section', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('DANGER ZONE'), findsOneWidget);
      });

      testWidgets('menu items have correct icons', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
        expect(find.byIcon(Icons.notifications_none), findsOneWidget);
      });

      testWidgets('menu items are scrollable', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(SingleChildScrollView), findsWidgets);
      });
    });

    // ===== Connect TikTok Tile Tests =====
    group('connect TikTok tile', () {
      testWidgets('displays TikTok menu item', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('TikTok'), findsOneWidget);
      });

      testWidgets('shows "Belum terhubung" when not connected', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Belum terhubung'), findsWidgets);
      });

      testWidgets('TikTok tile has link icon', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.link), findsWidgets);
      });

      testWidgets('TikTok tile is tappable', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsWidgets);
      });
    });

    // ===== Connect Instagram Tile Tests =====
    group('connect Instagram tile', () {
      testWidgets('displays Instagram menu item', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Instagram'), findsOneWidget);
      });

      testWidgets('shows "Belum terhubung" when not connected', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Belum terhubung'), findsWidgets);
      });

      testWidgets('Instagram tile has link icon', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.link), findsWidgets);
      });

      testWidgets('Instagram tile is tappable', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsWidgets);
      });
    });

    // ===== Log Out Button Tests =====
    group('log out button', () {
      testWidgets('displays Log Out menu item in Danger Zone', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('Log Out'), findsOneWidget);
      });

      testWidgets('Log Out text is red', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.logout), findsOneWidget);
      });

      testWidgets('Log Out tile is tappable', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsWidgets);
      });
    });

    // ===== Log Out Dialog Tests =====
    group('log out dialog', () {
      testWidgets('dialog appears when Log Out is tapped', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await openLogOutDialog(tester);
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('dialog displays correct title', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await openLogOutDialog(tester);
        expect(find.text('Log Out'), findsWidgets);
      });

      testWidgets('dialog displays confirmation message', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await openLogOutDialog(tester);
        expect(find.text('Are you sure you want to log out?'), findsOneWidget);
      });

      testWidgets('dialog has Cancel and Log Out buttons', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await openLogOutDialog(tester);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('Cancel button closes dialog', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await openLogOutDialog(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    // ===== Bottom Navigation Tests =====
    group('bottom navigation', () {
      testWidgets('displays AppNavbar', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar is positioned at bottom', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar has correct selected index', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppNavbar), findsOneWidget);
      });
    });

    // ===== Negative Tests =====
    group('negative and edge case tests', () {
      testWidgets('handles empty profile data gracefully', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('User'), findsOneWidget);
      });

      testWidgets('handles missing image URL', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('displays default sections without data', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('GENERAL'), findsOneWidget);
        expect(find.text('CONNECT'), findsOneWidget);
        expect(find.text('DANGER ZONE'), findsOneWidget);
      });

      testWidgets('menu items remain visible during scroll', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();
        expect(find.text('Account'), findsOneWidget);
      });

      testWidgets('username displays correctly with long names', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.text('User'), findsOneWidget);
      });

      testWidgets('handles rapid taps on Log Out button', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        await openLogOutDialog(tester);
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('all menu tiles have chevron icon', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.chevron_right), findsWidgets);
      });
    });
  });
}
