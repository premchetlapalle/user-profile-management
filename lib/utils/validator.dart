
class Validators {
  static String? validateNotEmpty(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? validatePassword(String password) {
    final RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+=\-{};:,.<>?]).{8,}$');

    if (!regex.hasMatch(password)) {
      return 'Password must be at least 8 characters,\ninclude a capital letter, lowercase letter, and special character.';
    }
    return null;
  }
  static bool validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return regex.hasMatch(value.trim());
  }

  static bool validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final RegExp regex = RegExp(r'^\+?\d{7,15}$');
    return regex.hasMatch(value.trim());
  }

}
