import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/profile/account_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AccountPage - Integration Tests - Navigation', () {
    testWidgets('klik back button kembali ke halaman sebelumnya', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      expect(find.text('Account'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should navigate back
      expect(find.byType(AccountPage), findsNothing);
    });
  });

  group('AccountPage - Integration Tests - Header & Profile', () {
    testWidgets('tap profile avatar membuka bottom sheet add photo', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(CircleAvatar));
      await tester.pumpAndSettle();

      expect(find.text('Tambah Foto Profil'), findsOneWidget);
      expect(find.text('Pilih dari Galeri'), findsOneWidget);
      expect(find.text('Ambil dari Kamera'), findsOneWidget);
    });

    testWidgets('close bottom sheet dengan tap area luar sheet', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(CircleAvatar));
      await tester.pumpAndSettle();

      expect(find.text('Tambah Foto Profil'), findsOneWidget);

      // Tap outside the sheet to close
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();

      // Sheet should be closed (but text may still exist in search results)
      // So we check the modal is gone by ensuring only one scaffold
      expect(find.byType(BottomSheet), findsNothing);
    });
  });

  group('AccountPage - Integration Tests - Edit Fields', () {
    testWidgets('tap Name tile, edit, dan simpan nilai baru', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      // Tap Name field
      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Name'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);

      // Clear existing text and type new name
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'New User Name');
      await tester.pumpAndSettle();

      // Tap Save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Dialog should close
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('tap Email tile, edit dengan email keyboard, dan simpan', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      // Tap Email field
      await tester.tap(find.text('Email'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Email'), findsOneWidget);

      // Enter email
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'newemail@example.com');
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('tap Edit dialog Cancel button menutup dialog tanpa simpan', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('AccountPage - Integration Tests - Date Picker', () {
    testWidgets('tap Date of birth membuka date picker', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Date of birth'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('select date dari picker dan tutup', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Date of birth'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Tap OK button (biasanya ada di bawah date picker)
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsNothing);
    });
  });

  group('AccountPage - Integration Tests - Region Picker', () {
    testWidgets('tap Account Region membuka region picker dialog', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Account Region'));
      await tester.pumpAndSettle();

      expect(find.text('Select Region'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('region picker menampilkan semua pilihan region', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Account Region'));
      await tester.pumpAndSettle();

      expect(find.text('Indonesia'), findsOneWidget);
      expect(find.text('Malaysia'), findsOneWidget);
      expect(find.text('Singapore'), findsOneWidget);
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Australia'), findsOneWidget);
    });

    testWidgets('select region dari picker dan tutup dialog', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Account Region'));
      await tester.pumpAndSettle();

      // Tap Malaysia as example
      await tester.tap(find.text('Malaysia'));
      await tester.pumpAndSettle();

      // Dialog should close after selection
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('region picker menampilkan checkmark untuk selected region', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      // First select a region
      await tester.tap(find.text('Account Region'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      // Then open the picker again to see the checkmark on selected region
      await tester.tap(find.text('Account Region'));
      await tester.pumpAndSettle();

      // Now the selected region should have a checkmark
      expect(find.byIcon(Icons.check), findsWidgets);
    });

    testWidgets('tap Cancel di region picker menutup dialog tanpa perubahan', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Account Region'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('AccountPage - Integration Tests - Password Change', () {
    testWidgets('tap Password membuka password change dialog', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Password'));
      await tester.pumpAndSettle();

      expect(find.text('Change Password'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('password dialog memiliki 3 password input fields', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Password'));
      await tester.pumpAndSettle();

      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm New Password'), findsOneWidget);
    });

    testWidgets('toggle password visibility mengubah icon', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Password'));
      await tester.pumpAndSettle();

      // Check visibility icons are present
      expect(find.byIcon(Icons.visibility_off), findsWidgets);

      // Tap first visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pumpAndSettle();

      // Should show visibility icon now
      expect(find.byIcon(Icons.visibility), findsWidgets);
    });

    testWidgets('enter passwords dan tap Save menampilkan snackbar', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Password'));
      await tester.pumpAndSettle();

      // Enter passwords
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'oldpass123');
      await tester.enterText(textFields.at(1), 'newpass456');
      await tester.enterText(textFields.at(2), 'newpass456');
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Should show snackbar
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  group('AccountPage - Integration Tests - Deactivate/Delete Account', () {
    testWidgets(
      'tap "Deactivate or delete account" membuka confirmation dialog',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AccountPage()));

        await tester.pumpAndSettle();

        await tester.tap(find.text('Deactivate or delete account'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(
          find.text(
            'Are you sure you want to deactivate or delete your account? This action cannot be undone.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'confirmation dialog memiliki Cancel, Deactivate, Delete button',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AccountPage()));

        await tester.pumpAndSettle();

        await tester.tap(find.text('Deactivate or delete account'));
        await tester.pumpAndSettle();

        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Deactivate'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      },
    );

    testWidgets('tap Cancel menutup deactivate dialog tanpa aksi', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Deactivate or delete account'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('tap Deactivate menampilkan snackbar "belum tersedia"', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Deactivate or delete account'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Deactivate'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Fitur deactivate belum tersedia.'), findsOneWidget);
    });
  });

  group('AccountPage - Integration Tests - UI Consistency', () {
    testWidgets('header selalu visible saat scroll content', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      expect(find.text('Account'), findsOneWidget);

      // Scroll down
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Header should still be visible
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('navbar selalu visible di bottom', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      expect(find.byType(AppNavbar), findsOneWidget);

      // Scroll down
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Navbar should still be visible
      expect(find.byType(AppNavbar), findsOneWidget);
    });

    testWidgets('semua info tiles dalam scrollable area', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);

      // Scroll and ensure all tiles are accessible
      await tester.ensureVisible(find.text('Deactivate or delete account'));
      await tester.pumpAndSettle();

      expect(find.text('Deactivate or delete account'), findsOneWidget);
    });
  });

  group('AccountPage - Integration Tests - Full Edit Flow', () {
    testWidgets('complete edit flow: Name -> Email -> Region -> Password', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AccountPage()));

      await tester.pumpAndSettle();

      // Edit Name
      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'New Full Name');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Edit Email
      await tester.tap(find.text('Email'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'user@newmail.com');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Edit Region
      await tester.tap(find.text('Account Region'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Singapore'));
      await tester.pumpAndSettle();

      // Edit Password
      await tester.tap(find.text('Password'));
      await tester.pumpAndSettle();
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'oldpass');
      await tester.enterText(textFields.at(1), 'newpass123');
      await tester.enterText(textFields.at(2), 'newpass123');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Should complete without errors
      expect(find.byType(AccountPage), findsOneWidget);
    });
  });
}
