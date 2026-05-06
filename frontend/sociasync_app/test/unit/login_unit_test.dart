import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/services/login_validator.dart';

void main() {
  // ─────────────────────────────────────────────
  // GROUP 1: Email Validation Tests
  // ─────────────────────────────────────────────
  group('LoginValidator - Email Validation', () {
    test('empty email returns error', () {
      expect(LoginValidator.validateEmail(''), isNotEmpty);
      expect(
        LoginValidator.validateEmail(''),
        'Email/username tidak boleh kosong',
      );
    });

    test('whitespace only email returns error', () {
      expect(LoginValidator.validateEmail('   '), isNotEmpty);
    });

    test('username without @ is valid', () {
      expect(LoginValidator.validateEmail('budi'), isNull);
    });

    test('email with @ but invalid format returns error', () {
      expect(LoginValidator.validateEmail('invalid@'), isNotEmpty);
    });

    test('email without domain returns error', () {
      expect(LoginValidator.validateEmail('invalid@domain'), isNotEmpty);
    });

    test('valid email format passes validation', () {
      expect(LoginValidator.validateEmail('user@example.com'), isNull);
    });

    test('valid email with numbers passes validation', () {
      expect(LoginValidator.validateEmail('user123@example.com'), isNull);
    });

    test('valid email with dots passes validation', () {
      expect(LoginValidator.validateEmail('first.last@example.com'), isNull);
    });

    test('valid email with hyphens passes validation', () {
      expect(
        LoginValidator.validateEmail('user-name@example-domain.com'),
        isNull,
      );
    });

    test('email with multiple subdomains passes validation', () {
      expect(LoginValidator.validateEmail('user@mail.example.co.id'), isNull);
    });

    test('email with leading/trailing spaces is trimmed', () {
      expect(LoginValidator.validateEmail('  user@example.com  '), isNull);
    });

    test('uppercase email is accepted', () {
      expect(LoginValidator.validateEmail('USER@EXAMPLE.COM'), isNull);
    });

    test('mixed case email is accepted', () {
      expect(LoginValidator.validateEmail('User@Example.Com'), isNull);
    });

    test('email without @ is treated as username', () {
      expect(LoginValidator.validateEmail('john123'), isNull);
    });

    test('username with underscores is valid', () {
      expect(LoginValidator.validateEmail('budi_123'), isNull);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 2: Password Validation Tests
  // ─────────────────────────────────────────────
  group('LoginValidator - Password Validation', () {
    test('empty password returns error', () {
      expect(LoginValidator.validatePassword(''), isNotEmpty);
      expect(
        LoginValidator.validatePassword(''),
        'Password tidak boleh kosong',
      );
    });

    test('password less than 6 chars returns error', () {
      expect(LoginValidator.validatePassword('12345'), isNotEmpty);
      expect(
        LoginValidator.validatePassword('12345'),
        'Password minimal 6 karakter',
      );
    });

    test('password exactly 6 chars passes validation', () {
      expect(LoginValidator.validatePassword('123456'), isNull);
    });

    test('password 7 chars passes validation', () {
      expect(LoginValidator.validatePassword('1234567'), isNull);
    });

    test('password with letters and numbers passes', () {
      expect(LoginValidator.validatePassword('password123'), isNull);
    });

    test('password with special characters passes', () {
      expect(LoginValidator.validatePassword('pass@123!'), isNull);
    });

    test('password with spaces passes', () {
      expect(LoginValidator.validatePassword('pass word'), isNull);
    });

    test('long password passes validation', () {
      expect(
        LoginValidator.validatePassword(
          'this_is_a_very_long_password_with_many_characters',
        ),
        isNull,
      );
    });

    test('password with unicode characters passes', () {
      expect(LoginValidator.validatePassword('пароль123'), isNull);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 3: Combined Login Validation Tests
  // ─────────────────────────────────────────────
  group('LoginValidator - Combined Validation', () {
    test('both fields empty returns false', () {
      expect(LoginValidator.validateLogin('', ''), false);
    });

    test('invalid email and valid password returns false', () {
      expect(LoginValidator.validateLogin('invalid@', 'password123'), false);
    });

    test('valid email and invalid password returns false', () {
      expect(LoginValidator.validateLogin('user@example.com', '123'), false);
    });

    test('valid email and valid password returns true', () {
      expect(
        LoginValidator.validateLogin('user@example.com', 'password123'),
        true,
      );
    });

    test('valid username and valid password returns true', () {
      expect(LoginValidator.validateLogin('budi', 'password123'), true);
    });

    test('form with various valid inputs', () {
      final testCases = [
        ('john@example.com', 'pass123', true),
        ('jane.doe@company.co.id', 'SecurePass', true),
        ('username', '654321', true),
        ('user_123@gmail.com', 'Password!', true),
        ('invalid@', 'valid123', false),
        ('valid@example.com', '123', false),
        ('', '', false),
      ];

      for (final (email, password, expected) in testCases) {
        expect(
          LoginValidator.validateLogin(email, password),
          expected,
          reason:
              'validateLogin("$email", "$password") should return $expected',
        );
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 4: Edge Cases
  // ─────────────────────────────────────────────
  group('LoginValidator - Edge Cases', () {
    test('password exactly 5 chars fails', () {
      expect(LoginValidator.validatePassword('12345'), isNotEmpty);
    });

    test('very long email passes if format valid', () {
      expect(
        LoginValidator.validateEmail(
          'very.long.email.address.name@subdomain.example.co.id',
        ),
        isNull,
      );
    });

    test('email with numbers in domain passes', () {
      expect(LoginValidator.validateEmail('user@domain123.com'), isNull);
    });

    test('email starting with number passes', () {
      expect(LoginValidator.validateEmail('123user@example.com'), isNull);
    });

    test('username with numbers and underscores', () {
      expect(LoginValidator.validateEmail('user_123_456'), isNull);
    });

    test('very long password passes', () {
      expect(LoginValidator.validatePassword('a' * 100), isNull);
    });

    test('single character username passes', () {
      expect(LoginValidator.validateEmail('a'), isNull);
    });

    test('single character password passes', () {
      expect(LoginValidator.validatePassword('aaaaaa'), isNull);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 5: Real-world Login Scenarios
  // ─────────────────────────────────────────────
  group('LoginValidator - Real-world Scenarios', () {
    test('typical user login with email', () {
      expect(LoginValidator.validateEmail('budi@gmail.com'), isNull);
      expect(LoginValidator.validatePassword('Budi123!'), isNull);
      expect(LoginValidator.validateLogin('budi@gmail.com', 'Budi123!'), true);
    });

    test('business email with subdomain', () {
      expect(LoginValidator.validateEmail('john.doe@company.co.id'), isNull);
      expect(LoginValidator.validatePassword('CompanySecurePass2024'), isNull);
      expect(
        LoginValidator.validateLogin(
          'john.doe@company.co.id',
          'CompanySecurePass2024',
        ),
        true,
      );
    });

    test('social media username', () {
      expect(LoginValidator.validateEmail('budi_indonesia'), isNull);
      expect(LoginValidator.validatePassword('InstaPass@123'), isNull);
      expect(
        LoginValidator.validateLogin('budi_indonesia', 'InstaPass@123'),
        true,
      );
    });

    test('minimum valid credentials', () {
      expect(LoginValidator.validateEmail('a@b.c'), isNull);
      expect(LoginValidator.validatePassword('123456'), isNull);
      expect(LoginValidator.validateLogin('a@b.c', '123456'), true);
    });

    test('Indonesian domain email', () {
      expect(LoginValidator.validateEmail('user@domain.co.id'), isNull);
      expect(LoginValidator.validatePassword('SukuBangsaSatau'), isNull);
      expect(
        LoginValidator.validateLogin('user@domain.co.id', 'SukuBangsaSatau'),
        true,
      );
    });

    test('simple username login', () {
      expect(LoginValidator.validateEmail('admin'), isNull);
      expect(LoginValidator.validatePassword('admin123'), isNull);
      expect(LoginValidator.validateLogin('admin', 'admin123'), true);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 6: Input Normalization
  // ─────────────────────────────────────────────
  group('LoginValidator - Input Normalization', () {
    test('email with leading spaces is trimmed', () {
      expect(LoginValidator.validateEmail('  user@example.com'), isNull);
    });

    test('email with trailing spaces is trimmed', () {
      expect(LoginValidator.validateEmail('user@example.com  '), isNull);
    });

    test('email with both spaces is trimmed', () {
      expect(LoginValidator.validateEmail('  user@example.com  '), isNull);
    });

    test('username with leading spaces is trimmed', () {
      expect(LoginValidator.validateEmail('  budi123  '), isNull);
    });

    test('password is NOT trimmed', () {
      // Password validation doesn't trim, only email does
      expect(LoginValidator.validatePassword('  pass  '), isNull);
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 7: Email Format Rules
  // ─────────────────────────────────────────────
  group('LoginValidator - Email Format Rules', () {
    test('validate different email formats', () {
      final testEmails = {
        'simple@example.com': true,
        'very.common@example.com': true,
        'disposable.email@example.com': true,
        'other.email-with-hyphen@example.com': true,
        'fully-qualified-domain@example.com': true,
        'user@localhost.localdomain': true,
        '@example.com': false,
        'user@': false,
        'user@.com': false,
      };

      testEmails.forEach((email, shouldPass) {
        final error = LoginValidator.validateEmail(email);
        if (shouldPass) {
          expect(
            error,
            isNull,
            reason: 'Email "$email" should be valid, but got error: $error',
          );
        } else {
          expect(error, isNotNull, reason: 'Email "$email" should be invalid');
        }
      });
    });

    test('username without @ does not require @ format', () {
      final usernames = ['user', 'user123', 'user_123', 'USER', 'admin-user'];

      for (final username in usernames) {
        expect(
          LoginValidator.validateEmail(username),
          isNull,
          reason: 'Username "$username" should be valid',
        );
      }
    });
  });

  // ─────────────────────────────────────────────
  // GROUP 8: Password Length Rules
  // ─────────────────────────────────────────────
  group('LoginValidator - Password Length Rules', () {
    test('validate different password lengths', () {
      final passwords = [
        ('', false),
        ('1', false),
        ('12', false),
        ('123', false),
        ('1234', false),
        ('12345', false),
        ('123456', true),
        ('1234567', true),
        ('MyPassword123', true),
      ];

      for (final (password, shouldPass) in passwords) {
        final error = LoginValidator.validatePassword(password);
        if (shouldPass) {
          expect(
            error,
            isNull,
            reason: 'Password with ${password.length} chars should be valid',
          );
        } else {
          expect(
            error,
            isNotNull,
            reason: 'Password with ${password.length} chars should be invalid',
          );
        }
      }
    });
  });
}
