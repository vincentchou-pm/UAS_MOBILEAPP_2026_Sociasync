import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/chatbot_Ai/chatbot.dart';

void main() {
  group('Chatbot Widget Test', () {
    /// ==============================
    /// 1. Render UI awal
    /// ==============================
    testWidgets('ChatbotPage tampil dengan benar', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChatbotPage()));

      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('Sociasync AI'), findsWidgets);
      expect(find.text('Sociasync Reminders'), findsOneWidget);
    });

    /// ==============================
    /// 2. Switch Tab ke AI
    /// ==============================
    testWidgets('Bisa switch ke tab AI', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChatbotPage()));

      await tester.tap(find.text('Sociasync AI').at(1)); // FIX
      await tester.pump(); // JANGAN pumpAndSettle

      expect(find.text('Tulis pesan untuk Sociasync AI...'), findsOneWidget);
    });

    /// ==============================
    /// 3. Input & Kirim Pesan
    /// ==============================
    testWidgets('User bisa input dan kirim pesan', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChatbotPage()));

      await tester.tap(find.text('Sociasync AI').at(1)); // FIX
      await tester.pump();

      await tester.enterText(find.byType(TextField).last, 'Halo AI');

      await tester.tap(find.text('Kirim'));
      await tester.pump();

      expect(find.text('Halo AI'), findsOneWidget);
    });

    /// ==============================
    /// 4. Loading indicator saat kirim
    /// ==============================
    testWidgets('Menampilkan loading saat mengirim', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChatbotPage()));

      await tester.tap(find.text('Sociasync AI').at(1)); // FIX
      await tester.pump();

      await tester.enterText(find.byType(TextField).last, 'Test');

      await tester.tap(find.text('Kirim'));
      await tester.pump();

      expect(find.textContaining('mengetik'), findsOneWidget);
    });
  });
}