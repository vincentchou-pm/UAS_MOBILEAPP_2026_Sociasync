/// Validator service for SignUp page
class SignUpValidator {
  static String? validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return 'Nama tidak boleh kosong';
    } else if (trimmed.length < 2) {
      return 'Nama minimal 2 karakter';
    } else if (!RegExp(r"^[a-zA-Z\s'.-]+$").hasMatch(trimmed)) {
      return 'Nama hanya boleh berisi huruf';
    }
    return null;
  }

  static String? validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(trimmed)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validateGender(String gender) {
    if (gender.isEmpty) {
      return 'Pilih jenis kelamin';
    }
    return null;
  }

  static String? validateDateOfBirth(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'Pilih tanggal lahir';
    }
    return null;
  }

  static String? validateRegion(String region) {
    if (region.isEmpty) {
      return 'Pilih region';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (password.length < 8) {
      return 'Password minimal 8 karakter';
    } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      return 'Password harus mengandung minimal 1 huruf kapital';
    } else if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
      return 'Password harus mengandung minimal 1 angka';
    }
    return null;
  }

  static String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    } else if (confirmPassword != password) {
      return 'Password tidak cocok';
    }
    return null;
  }

  static String formatDateForDisplay(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '$dd-$mm-${date.year}';
  }

  static String formatDateForApi(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }
}
