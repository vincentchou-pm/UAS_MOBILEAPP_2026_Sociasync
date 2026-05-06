import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/services/sign_up_validator.dart';

void main() {
  group('SignUpValidator - Name Validation', () {
    test('validateName returns error when name is empty', () {
      expect(
        SignUpValidator.validateName(''),
        equals('Nama tidak boleh kosong'),
      );
    });

    test('validateName returns error when name is less than 2 characters', () {
      expect(SignUpValidator.validateName('A'), contains('minimal 2 karakter'));
    });

    test(
      'validateName returns error when name contains invalid characters',
      () {
        expect(
          SignUpValidator.validateName('John123'),
          contains('hanya boleh berisi huruf'),
        );
      },
    );

    test('validateName accepts valid single names', () {
      expect(SignUpValidator.validateName('John'), isNull);
    });

    test('validateName accepts valid full names', () {
      expect(SignUpValidator.validateName('John Doe'), isNull);
    });

    test('validateName accepts names with apostrophes', () {
      expect(SignUpValidator.validateName("O'Brien"), isNull);
    });

    test('validateName accepts names with hyphens', () {
      expect(SignUpValidator.validateName('Mary-Jane'), isNull);
    });

    test('validateName trims whitespace', () {
      expect(SignUpValidator.validateName('  John Doe  '), isNull);
    });

    test('validateName rejects names with only whitespace', () {
      expect(
        SignUpValidator.validateName('   '),
        equals('Nama tidak boleh kosong'),
      );
    });

    test('validateName rejects names with numbers', () {
      expect(
        SignUpValidator.validateName('John1'),
        contains('hanya boleh berisi huruf'),
      );
    });

    test('validateName rejects names with special characters', () {
      expect(
        SignUpValidator.validateName('John@Doe'),
        contains('hanya boleh berisi huruf'),
      );
    });
  });

  group('SignUpValidator - Email Validation', () {
    test('validateEmail returns error when email is empty', () {
      expect(
        SignUpValidator.validateEmail(''),
        equals('Email tidak boleh kosong'),
      );
    });

    test('validateEmail returns error when email format is invalid', () {
      expect(
        SignUpValidator.validateEmail('invalidemail'),
        contains('Format email tidak valid'),
      );
    });

    test('validateEmail rejects email without @ symbol', () {
      expect(
        SignUpValidator.validateEmail('test.example.com'),
        contains('Format email tidak valid'),
      );
    });

    test('validateEmail rejects email without domain', () {
      expect(
        SignUpValidator.validateEmail('test@'),
        contains('Format email tidak valid'),
      );
    });

    test('validateEmail rejects email without local part', () {
      expect(
        SignUpValidator.validateEmail('@example.com'),
        contains('Format email tidak valid'),
      );
    });

    test('validateEmail accepts valid simple email', () {
      expect(SignUpValidator.validateEmail('test@example.com'), isNull);
    });

    test('validateEmail accepts email with dots in local part', () {
      expect(SignUpValidator.validateEmail('john.doe@example.com'), isNull);
    });

    test('validateEmail accepts email with hyphens in domain', () {
      expect(SignUpValidator.validateEmail('test@my-domain.com'), isNull);
    });

    test('validateEmail accepts email with multiple subdomains', () {
      expect(SignUpValidator.validateEmail('test@mail.example.co.uk'), isNull);
    });

    test('validateEmail trims whitespace', () {
      expect(SignUpValidator.validateEmail('  test@example.com  '), isNull);
    });
  });

  group('SignUpValidator - Gender Validation', () {
    test('validateGender returns error when gender is empty', () {
      expect(SignUpValidator.validateGender(''), equals('Pilih jenis kelamin'));
    });

    test('validateGender accepts Male', () {
      expect(SignUpValidator.validateGender('Male'), isNull);
    });

    test('validateGender accepts Female', () {
      expect(SignUpValidator.validateGender('Female'), isNull);
    });
  });

  group('SignUpValidator - Date of Birth Validation', () {
    test('validateDateOfBirth returns error when date is null', () {
      expect(
        SignUpValidator.validateDateOfBirth(null),
        equals('Pilih tanggal lahir'),
      );
    });

    test('validateDateOfBirth accepts valid date', () {
      expect(SignUpValidator.validateDateOfBirth(DateTime(2000, 5, 3)), isNull);
    });
  });

  group('SignUpValidator - Region Validation', () {
    test('validateRegion returns error when region is empty', () {
      expect(SignUpValidator.validateRegion(''), equals('Pilih region'));
    });

    test('validateRegion accepts Indonesia', () {
      expect(SignUpValidator.validateRegion('Indonesia'), isNull);
    });

    test('validateRegion accepts United States', () {
      expect(SignUpValidator.validateRegion('United States'), isNull);
    });
  });

  group('SignUpValidator - Password Validation', () {
    test('validatePassword returns error when password is empty', () {
      expect(
        SignUpValidator.validatePassword(''),
        equals('Password tidak boleh kosong'),
      );
    });

    test(
      'validatePassword returns error when password is less than 8 characters',
      () {
        expect(
          SignUpValidator.validatePassword('Pass12'),
          contains('minimal 8 karakter'),
        );
      },
    );

    test(
      'validatePassword returns error when password has no uppercase letter',
      () {
        expect(
          SignUpValidator.validatePassword('password123'),
          contains('minimal 1 huruf kapital'),
        );
      },
    );

    test('validatePassword returns error when password has no digit', () {
      expect(
        SignUpValidator.validatePassword('Password'),
        contains('minimal 1 angka'),
      );
    });

    test('validatePassword accepts valid password', () {
      expect(SignUpValidator.validatePassword('Password123'), isNull);
    });

    test(
      'validatePassword accepts password with multiple uppercase letters',
      () {
        expect(SignUpValidator.validatePassword('PassWord123'), isNull);
      },
    );

    test('validatePassword accepts password with multiple digits', () {
      expect(SignUpValidator.validatePassword('Password12345'), isNull);
    });

    test('validatePassword accepts 8 character password', () {
      expect(SignUpValidator.validatePassword('Pass1234'), isNull);
    });

    test('validatePassword accepts password with special characters', () {
      expect(SignUpValidator.validatePassword('Pass@word123'), isNull);
    });
  });

  group('SignUpValidator - Confirm Password Validation', () {
    test('validateConfirmPassword returns error when password is empty', () {
      expect(
        SignUpValidator.validateConfirmPassword('Password123', ''),
        equals('Konfirmasi password tidak boleh kosong'),
      );
    });

    test(
      'validateConfirmPassword returns error when passwords do not match',
      () {
        expect(
          SignUpValidator.validateConfirmPassword('Password123', 'Password456'),
          contains('tidak cocok'),
        );
      },
    );

    test('validateConfirmPassword accepts matching passwords', () {
      expect(
        SignUpValidator.validateConfirmPassword('Password123', 'Password123'),
        isNull,
      );
    });
  });

  group('SignUpValidator - Date Formatting', () {
    test('formatDateForDisplay formats date as DD-MM-YYYY', () {
      final date = DateTime(2000, 5, 3);
      expect(SignUpValidator.formatDateForDisplay(date), '03-05-2000');
    });

    test('formatDateForDisplay pads day with zero', () {
      final date = DateTime(2005, 1, 9);
      expect(SignUpValidator.formatDateForDisplay(date), '09-01-2005');
    });

    test('formatDateForDisplay pads month with zero', () {
      final date = DateTime(2010, 1, 15);
      expect(SignUpValidator.formatDateForDisplay(date), '15-01-2010');
    });

    test('formatDateForApi formats date as YYYY-MM-DD', () {
      final date = DateTime(2000, 5, 3);
      expect(SignUpValidator.formatDateForApi(date), '2000-05-03');
    });

    test('formatDateForApi pads day with zero', () {
      final date = DateTime(2005, 1, 9);
      expect(SignUpValidator.formatDateForApi(date), '2005-01-09');
    });

    test('formatDateForApi pads month with zero', () {
      final date = DateTime(2010, 1, 15);
      expect(SignUpValidator.formatDateForApi(date), '2010-01-15');
    });
  });

  group('SignUpValidator - Combined Validation Scenarios', () {
    test('all validations pass with complete valid data', () {
      expect(SignUpValidator.validateName('John Doe'), isNull);
      expect(SignUpValidator.validateEmail('john@example.com'), isNull);
      expect(SignUpValidator.validateGender('Male'), isNull);
      expect(SignUpValidator.validateDateOfBirth(DateTime(2000, 1, 1)), isNull);
      expect(SignUpValidator.validateRegion('Indonesia'), isNull);
      expect(SignUpValidator.validatePassword('Password123'), isNull);
      expect(
        SignUpValidator.validateConfirmPassword('Password123', 'Password123'),
        isNull,
      );
    });

    test('all validations fail with empty data', () {
      expect(SignUpValidator.validateName(''), isNotNull);
      expect(SignUpValidator.validateEmail(''), isNotNull);
      expect(SignUpValidator.validateGender(''), isNotNull);
      expect(SignUpValidator.validateDateOfBirth(null), isNotNull);
      expect(SignUpValidator.validateRegion(''), isNotNull);
      expect(SignUpValidator.validatePassword(''), isNotNull);
      expect(SignUpValidator.validateConfirmPassword('', ''), isNotNull);
    });
  });
}
