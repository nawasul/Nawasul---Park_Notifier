/// Placeholder catalog values. Not a price decision.
/// Replace from `GET /pricing` in Phase M8.
class MockConfig {
  MockConfig._();

  static const price3MonthsSar = 99;
  static const price6MonthsSar = 179;
  static const price12MonthsSar = 299;
  static const deliveryFeeSar = 25;
  static const vatRate = 0.15;
  static const pricesIncludeVat = false;
  static const deliveryEta = '3–5 business days';
  static const successOtp = '123456';
  static const expiredOtp = '000000';
  static const otpAttempts = 5;

  /// Reserved mock numbers so error screens can be opened without a backend.
  static const rateLimitedPhone = '+966500000001';
  static const networkPhone = '+966500000002';
  static const noWhatsappPhone = '+966500000003';
}
