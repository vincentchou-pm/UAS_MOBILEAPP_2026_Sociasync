import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/chatbot_Ai/chatbot.dart';

void main() {
  group('Reminder Widget Test', () {

    Future<void> pumpReminderPage(
      WidgetTester tester, {
      List<Map<String, dynamic>> fakeData = const [],
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChatbotPage(
            getRemindersOverride: () async => fakeData,
          ),
        ),
      );

      // biarin future selesai + UI stabil
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
    }

    testWidgets('Menampilkan empty reminder', (tester) async {
      await pumpReminderPage(tester, fakeData: []);

      expect(find.text('Belum ada reminder.'), findsOneWidget);
      expect(find.text('Tambah Reminder'), findsOneWidget);
    });

    testWidgets('Klik tambah buka dialog', (tester) async {
      await pumpReminderPage(tester, fakeData: []);

      await tester.tap(find.text('Tambah Reminder'));
      await tester.pump();

      expect(find.text('Tambah Sociasync Reminder'), findsOneWidget);
    });

    testWidgets('Validasi form kosong', (tester) async {
      await pumpReminderPage(tester, fakeData: []);

      await tester.tap(find.text('Tambah Reminder'));
      await tester.pump();

      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('wajib diisi'), findsOneWidget);
    });

    testWidgets('Cancel menutup dialog', (tester) async {
      await pumpReminderPage(tester, fakeData: []);

      await tester.tap(find.text('Tambah Reminder'));
      await tester.pump();

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(find.text('Tambah Sociasync Reminder'), findsNothing);
    });

  });
}