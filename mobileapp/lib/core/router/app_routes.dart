class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const phone = '/auth/phone';
  static const verify = '/auth/verify';
  static const name = '/auth/name';
  static const allowAlerts = '/auth/allow-alerts';

  static const legal = '/legal/:type';
  static String legalType(String type) => '/legal/$type';

  static const home = '/home';
  static const vehicles = '/vehicles';
  static const vehiclesAdd = '/vehicles/add';
  static String vehicle(String id) => '/vehicles/$id';
  static String vehicleEdit(String id) => '/vehicles/$id/edit';
  static String vehicleQr(String id) => '/vehicles/$id/qr';

  static const alerts = '/alerts';
  static String alert(String id) => '/alerts/$id';

  static const account = '/account';
  static const accountEdit = '/account/edit';
  static const notifications = '/account/notifications';
  static const help = '/account/help';
  static const deleteAccount = '/account/delete';

  static const orderVehicle = '/order/vehicle';
  static const orderDelivery = '/order/delivery';
  static const orderReview = '/order/review';
  static String orderResult(String orderId) => '/order/result/$orderId';
  static const orders = '/orders';
  static String order(String orderId) => '/orders/$orderId';
}
