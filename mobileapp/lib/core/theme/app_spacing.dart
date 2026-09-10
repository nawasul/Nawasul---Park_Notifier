/// Direct mirror of docs/design.json `spacing` object (+ layout constants).
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Primary button touch target height (design.json componentRules).
  static const double buttonHeight = 56;

  /// Hero icon circle diameter on onboarding slides.
  static const double iconHero = 190;

  /// OTP digit box width/height baseline.
  static const double otpBoxSize = 56;

  /// Legacy spacing token — maps to [xxl] under the new scale.
  static const double xxxl = xxl;
}
