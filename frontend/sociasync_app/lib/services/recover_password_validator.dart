/// Service untuk validasi recover password
/// Single source of truth untuk semua validasi recover password
class RecoverPasswordValidator {
  /// Validasi email/username
  /// Returns: error message atau null jika valid
  static String? validateEmail(String email) {
    email = email.trim();
    if (email.isEmpty) {
      return 'Email/username tidak boleh kosong';
    }

    // Logic persis dari recover_password_page.dart
    if (email.contains('@') &&
        !RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Validasi code (6 digit angka)
  /// Returns: error message atau null jika valid
  static String? validateCode(String code) {
    code = code.trim();
    if (code.isEmpty) {
      return 'Kode tidak boleh kosong';
    }

    if (!RegExp(r'^\d+$').hasMatch(code)) {
      return 'Kode harus berupa angka';
    }

    if (code.length != 6) {
      return 'Kode harus 6 digit';
    }

    return null;
  }

  /// Validasi password baru (minimum 8 karakter)
  /// Returns: error message atau null jika valid
  static String? validateNewPassword(String password) {
    if (password.isEmpty) {
      return 'Password baru tidak boleh kosong';
    }

    if (password.length < 8) {
      return 'Password minimal 8 karakter';
    }

    return null;
  }

  /// Validasi konfirmasi password (harus cocok dengan password baru)
  /// Returns: error message atau null jika valid
  static String? validateConfirmPassword(
    String confirmPassword,
    String newPassword,
  ) {
    if (confirmPassword != newPassword) {
      return 'Konfirmasi password tidak cocok';
    }

    return null;
  }

  /// Validasi semua field recover password
  /// Returns: true jika semua valid, false jika ada yang error
  static bool validateRecoverPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) {
    return validateEmail(email) == null &&
        validateCode(code) == null &&
        validateNewPassword(newPassword) == null &&
        validateConfirmPassword(confirmPassword, newPassword) == null;
  }
}
