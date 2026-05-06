import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/dashboard/notification_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';
import 'package:sociasync_app/widgets/dashboard_header.dart';

void main() {
  group('NotificationPage - Widget Test (Fixed)', () {
    testWidgets('Header & Title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationPage(
            getMe: () async => {'name': 'Test User'},
            getNotifications: () async => [],
            markAllRead: () async {},
            showNotification:
                ({required title, required body, payload}) async {},
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(DashboardHeader), findsOneWidget);
      expect(find.text('Notification'), findsOneWidget);
    });

    testWidgets('Loading State', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Empty State', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationPage(
            getMe: () async => {'name': 'User'},
            getNotifications: () async => [],
            markAllRead: () async {},
            showNotification:
                ({required title, required body, payload}) async {},
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Belum ada notifikasi.'), findsOneWidget);
    });

    testWidgets('ListView muncul', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationPage(
            getMe: () async => {'name': 'User'},
            getNotifications: () async => [
              {
                'id': 1,
                'title': 'Test Title',
                'message': 'Test Message',
                'created_at': DateTime.now().toIso8601String(),
                'is_read': false,
              },
            ],
            markAllRead: () async {},
            showNotification:
                ({required title, required body, payload}) async {},
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Notification Card tampil', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationPage(
            getMe: () async => {'name': 'User'},
            getNotifications: () async => [
              {
                'id': 1,
                'title': 'Judul Notif',
                'message': 'Isi Notif',
                'created_at': DateTime.now().toIso8601String(),
                'is_read': false,
              },
            ],
            markAllRead: () async {},
            showNotification:
                ({required title, required body, payload}) async {},
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Judul Notif'), findsOneWidget);
      expect(find.text('Isi Notif'), findsOneWidget);
    });

    testWidgets('Fallback data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationPage(
            getMe: () async => {'name': 'User'},
            getNotifications: () async => [
              {
                'id': 1,
                'title': '',
                'message': '',
                'created_at': '',
                'is_read': true,
              },
            ],
            markAllRead: () async {},
            showNotification:
                ({required title, required body, payload}) async {},
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('Bottom Navbar muncul', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotificationPage(
            getMe: () async => {'name': 'User'},
            getNotifications: () async => [],
            markAllRead: () async {},
            showNotification:
                ({required title, required body, payload}) async {},
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AppNavbar), findsOneWidget);
    });
  });
}
