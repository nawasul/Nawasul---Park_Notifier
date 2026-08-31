class AppRoutes {
  AppRoutes._();

  // Auth
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const language = '/language';
  static const login = '/login';
  static const register = '/register';
  static const otp = '/otp';
  static const forgotPassword = '/forgot-password';
  static const accountSetup = '/account-setup';

  // Shell tabs
  static const home = '/home';
  static const vehicles = '/vehicles';
  static const myQr = '/my-qr';
  static const alerts = '/alerts';
  static const account = '/account';

  // Pushed routes
  static const vehiclesAdd = '/vehicles/add';
  static String vehicleEdit(String id) => '/vehicles/$id/edit';
  static String vehicleDetails(String id) => '/vehicles/$id';
  static String vehicleQr(String id) => '/vehicles/$id/qr';
  static String stickerOrder(String id) => '/vehicles/$id/sticker-order';
  static String stickerOrderStatus(String orderId) => '/sticker-orders/$orderId';
  static String alertDetail(String id) => '/alerts/$id';
  static const subscriptionPlans = '/subscription/plans';
  static const subscriptionCheckout = '/subscription/checkout';
  static const subscriptionSuccess = '/subscription/success';
}
