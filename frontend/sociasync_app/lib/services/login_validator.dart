/// Login Validator Service
/// Single source of truth untuk semua login validation logic
class LoginValidator {
  /// Validate email/username field
  /// Returns error message if invalid, null if valid
  static String? validateEmail(String email) {
    email = email.trim();

    if (email.isEmpty) {
      return 'Email/username tidak boleh kosong';
    }

    // If contains @, validate as email format
    if (email.contains('@')) {
      if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
        return 'Format email tidak valid';
      }
    }

    return null;
  }

  /// Validate password field
  /// Returns error message if invalid, null if valid
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  /// Validate entire login form
  /// Returns true if all fields are valid
  static bool validateLogin(String email, String password) {
    return validateEmail(email) == null && validatePassword(password) == null;
  }
}
