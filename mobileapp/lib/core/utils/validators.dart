/// Saudi mobile numbers only at launch. National number is 9 digits starting with 5.
class PhoneValidator {
  PhoneValidator._();

  static const dialCode = '+966';
  static final _national = RegExp(r'^5\d{8}$');
  static final _e164 = RegExp(r'^\+9665\d{8}$');

  /// Returns null when [input] is a valid national number.
  /// Accepts `5XXXXXXXX` or a local `05XXXXXXXX`.
  static String? nationalError(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'required';
    final normalized = digits.startsWith('0') ? digits.substring(1) : digits;
    if (!_national.hasMatch(normalized)) return 'invalid';
    return null;
  }

  static String? toE164(String input) {
    if (nationalError(input) != null) return null;
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final normalized = digits.startsWith('0') ? digits.substring(1) : digits;
    return '$dialCode$normalized';
  }

  static bool isValidE164(String value) => _e164.hasMatch(value);

  /// `+966 5•••••678` for a valid Saudi mobile number.
  static String mask(String e164) {
    if (!isValidE164(e164)) return e164;
    final national = e164.substring(dialCode.length);
    return '$dialCode ${national[0]}${'•' * 5}${national.substring(6)}';
  }
}

/// Plate must include letters (Arabic or English) and Western digits.
class PlateValidator {
  PlateValidator._();

  static final _allowed = RegExp(r'^[A-Za-z\u0600-\u06FF0-9 ]+$');
  static final _letter = RegExp(r'[A-Za-z\u0600-\u06FF]');
  static final _digit = RegExp(r'[0-9]');

  static String? error(String input) {
    final value = input.trim();
    if (value.isEmpty) return 'required';
    if (value.length < 2 || value.length > 12) return 'invalid';
    if (!_allowed.hasMatch(value)) return 'invalid';
    if (!_letter.hasMatch(value) || !_digit.hasMatch(value)) return 'invalid';
    return null;
  }

  static String normalize(String plate) {
    return plate.trim().toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}
