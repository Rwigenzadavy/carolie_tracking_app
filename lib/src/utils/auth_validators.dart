class AuthValidators {
  const AuthValidators._();

  static String? fullName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Enter your full name';
    }
    if (text.length < 2) {
      return 'Name is too short';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Enter your email address';
    }

    final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailPattern.hasMatch(text)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Enter your password';
    }
    if (text.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Confirm your password';
    }
    if (text != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
