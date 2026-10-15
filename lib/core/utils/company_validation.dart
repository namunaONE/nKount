/// Shared company/business-profile validators.
///
/// Used by onboarding registration and the Settings company editor so both
/// forms enforce identical rules. Messages are part of the widget-test
/// contract — keep them stable.
abstract final class CompanyValidators {
  static final RegExp emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp phonePattern = RegExp(r'^[+\d][\d\s-]{6,}$');

  /// Nepal PAN / VAT numbers are 9 digits.
  static final RegExp taxIdPattern = RegExp(r'^\d{9}$');

  static String? required(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label is required' : null;

  static String? phone(String? value, {required bool required}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Phone is required' : null;
    }
    if (!phonePattern.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!emailPattern.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? taxId(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    if (!taxIdPattern.hasMatch(value.trim())) {
      return '$label must be 9 digits';
    }
    return null;
  }

  /// Percentage rate between 0 and 100.
  static String? percentage(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 0 || parsed > 100) {
      return 'Enter a $label between 0 and 100';
    }
    return null;
  }
}
