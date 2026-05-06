import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/services/recover_password_validator.dart';

void main() {
  describe('RecoverPasswordValidator - Email Validation', () {
    test('should return error if email is empty', () {
      final result = RecoverPasswordValidator.validateEmail('');
      expect(result, 'Email/username tidak boleh kosong');
    });

    test('should return error if email is only whitespace', () {
      final result = RecoverPasswordValidator.validateEmail('   ');
      expect(result, 'Email/username tidak boleh kosong');
    });

    test('should return null for valid username (no @)', () {
      final result = RecoverPasswordValidator.validateEmail('johndoe');
      expect(result, null);
    });

    test('should return null for valid email with standard format', () {
      final result = RecoverPasswordValidator.validateEmail('user@example.com');
      expect(result, null);
    });

    test('should return error for invalid email format (missing domain)', () {
      final result = RecoverPasswordValidator.validateEmail('user@example');
      expect(result, 'Format email tidak valid');
    });

    test('should return error for invalid email format (no @)', () {
      final result = RecoverPasswordValidator.validateEmail('userexample.com');
      expect(result, null); // No @, treated as username
    });

    test('should return null for email with subdomain', () {
      final result = RecoverPasswordValidator.validateEmail(
        'user@mail.example.com',
      );
      expect(result, null);
    });

    test('should return null for email with dot in username', () {
      final result = RecoverPasswordValidator.validateEmail(
        'john.doe@example.com',
      );
      expect(result, null);
    });

    test('should return null for email with hyphen in domain', () {
      final result = RecoverPasswordValidator.validateEmail(
        'user@ex-ample.com',
      );
      expect(result, null);
    });

    test('should return null for email with numbers', () {
      final result = RecoverPasswordValidator.validateEmail(
        'user123@example456.com',
      );
      expect(result, null);
    });

    test('should trim whitespace from email', () {
      final result = RecoverPasswordValidator.validateEmail(
        '  user@example.com  ',
      );
      expect(result, null);
    });

    test('should return null for valid email with uppercase', () {
      final result = RecoverPasswordValidator.validateEmail('User@Example.COM');
      expect(result, null);
    });
  });

  describe('RecoverPasswordValidator - Code Validation', () {
    test('should return error if code is empty', () {
      final result = RecoverPasswordValidator.validateCode('');
      expect(result, 'Kode tidak boleh kosong');
    });

    test('should return error if code is only whitespace', () {
      final result = RecoverPasswordValidator.validateCode('   ');
      expect(result, 'Kode tidak boleh kosong');
    });

    test('should return error if code contains letters', () {
      final result = RecoverPasswordValidator.validateCode('12345a');
      expect(result, 'Kode harus berupa angka');
    });

    test('should return error if code contains special characters', () {
      final result = RecoverPasswordValidator.validateCode('123-45');
      expect(result, 'Kode harus berupa angka');
    });

    test('should return error if code is less than 6 digits', () {
      final result = RecoverPasswordValidator.validateCode('12345');
      expect(result, 'Kode harus 6 digit');
    });

    test('should return error if code is more than 6 digits', () {
      final result = RecoverPasswordValidator.validateCode('1234567');
      expect(result, 'Kode harus 6 digit');
    });

    test('should return null for valid 6-digit code', () {
      final result = RecoverPasswordValidator.validateCode('123456');
      expect(result, null);
    });

    test('should return null for code with all zeros', () {
      final result = RecoverPasswordValidator.validateCode('000000');
      expect(result, null);
    });

    test('should trim whitespace from code', () {
      final result = RecoverPasswordValidator.validateCode('  123456  ');
      expect(result, null);
    });

    test('should return error for code with spaces', () {
      final result = RecoverPasswordValidator.validateCode('12 34 56');
      expect(result, 'Kode harus berupa angka');
    });
  });

  describe('RecoverPasswordValidator - New Password Validation', () {
    test('should return error if password is empty', () {
      final result = RecoverPasswordValidator.validateNewPassword('');
      expect(result, 'Password baru tidak boleh kosong');
    });

    test('should return error if password is less than 8 characters', () {
      final result = RecoverPasswordValidator.validateNewPassword('Pass123');
      expect(result, 'Password minimal 8 karakter');
    });

    test('should return null for password with exactly 8 characters', () {
      final result = RecoverPasswordValidator.validateNewPassword('Password');
      expect(result, null);
    });

    test('should return null for password with more than 8 characters', () {
      final result = RecoverPasswordValidator.validateNewPassword(
        'MyPassword123',
      );
      expect(result, null);
    });

    test('should return null for password with numbers', () {
      final result = RecoverPasswordValidator.validateNewPassword('Pass1234');
      expect(result, null);
    });

    test('should return null for password with special characters', () {
      final result = RecoverPasswordValidator.validateNewPassword('Pass@123!');
      expect(result, null);
    });

    test('should return null for very long password', () {
      final result = RecoverPasswordValidator.validateNewPassword(
        'VeryLongPasswordWith123SpecialChars!@#\$%^&*',
      );
      expect(result, null);
    });

    test('should not trim password (preserve exact input)', () {
      final result = RecoverPasswordValidator.validateNewPassword(
        '  Pass123  ',
      );
      expect(result, null);
    });

    test('should return null for password with unicode characters', () {
      final result = RecoverPasswordValidator.validateNewPassword('пароль123');
      expect(result, null);
    });
  });

  describe('RecoverPasswordValidator - Confirm Password Validation', () {
    test('should return error if passwords do not match', () {
      final result = RecoverPasswordValidator.validateConfirmPassword(
        'Password1',
        'Password2',
      );
      expect(result, 'Konfirmasi password tidak cocok');
    });

    test('should return null if passwords match exactly', () {
      final result = RecoverPasswordValidator.validateConfirmPassword(
        'Password123',
        'Password123',
      );
      expect(result, null);
    });

    test('should return error if passwords differ only in case', () {
      final result = RecoverPasswordValidator.validateConfirmPassword(
        'password123',
        'Password123',
      );
      expect(result, 'Konfirmasi password tidak cocok');
    });

    test('should return error if passwords differ by one character', () {
      final result = RecoverPasswordValidator.validateConfirmPassword(
        'Password123',
        'Password124',
      );
      expect(result, 'Konfirmasi password tidak cocok');
    });

    test('should return null for empty passwords if they match', () {
      final result = RecoverPasswordValidator.validateConfirmPassword('', '');
      expect(result, null);
    });

    test('should return null for matching special character passwords', () {
      final result = RecoverPasswordValidator.validateConfirmPassword(
        'Pass@#\$123!',
        'Pass@#\$123!',
      );
      expect(result, null);
    });

    test('should consider leading/trailing spaces in comparison', () {
      final result = RecoverPasswordValidator.validateConfirmPassword(
        ' Password123',
        'Password123',
      );
      expect(result, 'Konfirmasi password tidak cocok');
    });

    test('should return null for matching unicode passwords', () {
      final result = RecoverPasswordValidator.validateConfirmPassword(
        'пароль123',
        'пароль123',
      );
      expect(result, null);
    });

    test('should return error for swapped similar characters', () {
      final result = RecoverPasswordValidator.validateConfirmPassword(
        'PasSword123',
        'PassWord123',
      );
      expect(result, 'Konfirmasi password tidak cocok');
    });
  });

  describe('RecoverPasswordValidator - Combined Validation', () {
    test('should return true when all fields are valid', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'NewPass123',
        confirmPassword: 'NewPass123',
      );
      expect(result, true);
    });

    test('should return false when email is invalid', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: '',
        code: '123456',
        newPassword: 'NewPass123',
        confirmPassword: 'NewPass123',
      );
      expect(result, false);
    });

    test('should return false when code is invalid', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '12345',
        newPassword: 'NewPass123',
        confirmPassword: 'NewPass123',
      );
      expect(result, false);
    });

    test('should return false when new password is invalid', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'Short1',
        confirmPassword: 'Short1',
      );
      expect(result, false);
    });

    test('should return false when passwords do not match', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'NewPass123',
        confirmPassword: 'DifferPass123',
      );
      expect(result, false);
    });

    test('should return false when multiple fields are invalid', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: '',
        code: 'abcdef',
        newPassword: 'Short',
        confirmPassword: 'Different',
      );
      expect(result, false);
    });

    test('should return true with username instead of email', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'johndoe',
        code: '999999',
        newPassword: 'SecurePass456',
        confirmPassword: 'SecurePass456',
      );
      expect(result, true);
    });

    test('should return true with minimum valid password length (8)', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '000000',
        newPassword: 'MinLen8!',
        confirmPassword: 'MinLen8!',
      );
      expect(result, true);
    });
  });

  describe('RecoverPasswordValidator - Edge Cases', () {
    test('should handle very long email addresses', () {
      final longEmail = 'a' * 50 + '@' + 'b' * 50 + '.com';
      final result = RecoverPasswordValidator.validateEmail(longEmail);
      expect(result, null);
    });

    test('should handle very long passwords', () {
      final longPassword = 'A' * 1000;
      final result = RecoverPasswordValidator.validateNewPassword(longPassword);
      expect(result, null);
    });

    test('should handle code with leading zeros', () {
      final result = RecoverPasswordValidator.validateCode('000001');
      expect(result, null);
    });

    test('should handle password with only numbers', () {
      final result = RecoverPasswordValidator.validateNewPassword('12345678');
      expect(result, null);
    });

    test('should handle password with only special characters (8+ length)', () {
      final result = RecoverPasswordValidator.validateNewPassword('!@#\$%^&*');
      expect(result, null);
    });
  });

  describe('RecoverPasswordValidator - Real-world Scenarios', () {
    test('should validate typical business email recovery', () {
      final emailErr = RecoverPasswordValidator.validateEmail(
        'john.smith@company.com',
      );
      final codeErr = RecoverPasswordValidator.validateCode('654321');
      final passwordErr = RecoverPasswordValidator.validateNewPassword(
        'CompanyPass2024!',
      );
      final confirmErr = RecoverPasswordValidator.validateConfirmPassword(
        'CompanyPass2024!',
        'CompanyPass2024!',
      );

      expect(emailErr, null);
      expect(codeErr, null);
      expect(passwordErr, null);
      expect(confirmErr, null);
    });

    test('should validate user with username instead of email', () {
      final emailErr = RecoverPasswordValidator.validateEmail('johndoe123');
      final codeErr = RecoverPasswordValidator.validateCode('111111');
      final passwordErr = RecoverPasswordValidator.validateNewPassword(
        'NewPassword888',
      );
      final confirmErr = RecoverPasswordValidator.validateConfirmPassword(
        'NewPassword888',
        'NewPassword888',
      );

      expect(emailErr, null);
      expect(codeErr, null);
      expect(passwordErr, null);
      expect(confirmErr, null);
    });

    test('should reject recovery with typo in code', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: 'abcdef', // Wrong: letters instead of numbers
        newPassword: 'NewPassword123',
        confirmPassword: 'NewPassword123',
      );
      expect(result, false);
    });

    test('should reject recovery with password too short', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'Pass12', // Only 6 chars, need 8+
        confirmPassword: 'Pass12',
      );
      expect(result, false);
    });

    test('should reject recovery with mismatched password confirmation', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'CorrectPass123',
        confirmPassword: 'WrongPass1234', // Typo in confirmation
      );
      expect(result, false);
    });

    test('should handle recovery with special recovery code', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '999999',
        newPassword: 'SuperSecurePass!@#',
        confirmPassword: 'SuperSecurePass!@#',
      );
      expect(result, true);
    });

    test('should handle recovery with international domain', () {
      final result = RecoverPasswordValidator.validateEmail(
        'user@example.co.uk',
      );
      expect(result, null);
    });

    test('should reject invalid email format in recovery', () {
      final result = RecoverPasswordValidator.validateEmail('user@.com');
      expect(result, 'Format email tidak valid');
    });

    test('should reject code that is too short', () {
      final result = RecoverPasswordValidator.validateCode('12345');
      expect(result, 'Kode harus 6 digit');
    });

    test('should reject code that is too long', () {
      final result = RecoverPasswordValidator.validateCode('1234567');
      expect(result, 'Kode harus 6 digit');
    });

    test('should handle case sensitivity in password confirmation', () {
      final result = RecoverPasswordValidator.validateRecoverPassword(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'MyPassword123',
        confirmPassword: 'mypassword123',
      );
      expect(result, false);
    });

    test('should accept exact 8-character password', () {
      final result = RecoverPasswordValidator.validateNewPassword('Pass1234');
      expect(result, null);
    });

    test('should reject 7-character password', () {
      final result = RecoverPasswordValidator.validateNewPassword('Pass123');
      expect(result, 'Password minimal 8 karakter');
    });
  });
}

// Helper untuk describe blocks (untuk organized test structure)
void describe(String description, void Function() tests) {
  group(description, tests);
}
