import '../../features/account/data/account_repository.dart';
import '../../features/alerts/data/alert_repository.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/orders/data/order_repository.dart';
import '../../features/orders/data/pricing_repository.dart';
import '../../features/vehicles/data/vehicle_repository.dart';
import '../models/alert_item.dart';
import '../models/order.dart';
import '../models/pricing.dart';
import '../models/user.dart';
import '../models/vehicle.dart';
import 'api_client.dart';
import 'api_codecs.dart';
import 'token_store.dart';

class LiveAuthRepository implements AuthRepository {
  LiveAuthRepository(this._api, this._tokens);

  final ApiClient _api;
  final TokenStore _tokens;

  @override
  Future<SendOtpResult> sendOtp(String phoneE164) async {
    final data = asJsonMap(
      await _api.post(
        '/api/v1/auth/otp/send',
        body: {'phone': phoneE164},
        skipAuth: true,
      ),
    );
    return SendOtpResult(delivered: data['delivered'] != false);
  }

  @override
  Future<VerifyResult> acceptPhone(String phoneE164) {
    throw UnimplementedError('Phone sign-in without OTP is mock-only.');
  }

  @override
  Future<VerifyResult> verifyOtp(String phoneE164, String code) async {
    final data = asJsonMap(
      await _api.post(
        '/api/v1/auth/otp/verify',
        body: {'phone': phoneE164, 'code': code},
        skipAuth: true,
      ),
    );
    final result = VerifyResult(
      accessToken: data['accessToken'].toString(),
      refreshToken: data['refreshToken'].toString(),
      isNewUser: data['isNewUser'] == true,
    );
    await _tokens.write(
      access: result.accessToken,
      refresh: result.refreshToken,
    );
    return result;
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post('/api/v1/auth/logout');
    } on AppException {
      // Still drop the local session if the server is unreachable.
    }
    await _tokens.clear();
  }
}

class LiveAccountRepository implements AccountRepository {
  LiveAccountRepository(this._api);

  final ApiClient _api;

  @override
  Future<User> fetchMe() async => userFromJson(await _api.get('/api/v1/me'));

  @override
  Future<User> updateMe({required String name, String? city}) async {
    return userFromJson(
      await _api.patch('/api/v1/me', body: {'name': name, 'city': city}),
    );
  }

  @override
  Future<void> deleteMe({String? reason}) async {
    await _api.delete(
      '/api/v1/me',
      body: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );
  }

  @override
  Future<Preferences> fetchPreferences() async =>
      preferencesFromJson(await _api.get('/api/v1/me/preferences'));

  @override
  Future<Preferences> updatePreferences(Preferences preferences) async {
    return preferencesFromJson(
      await _api.patch(
        '/api/v1/me/preferences',
        body: preferencesToJson(preferences),
      ),
    );
  }
}

class LiveVehicleRepository implements VehicleRepository {
  LiveVehicleRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<Vehicle>> fetchVehicles() async {
    final data = await _api.get('/api/v1/vehicles');
    return asJsonList(data).map(vehicleFromJson).toList();
  }

  @override
  Future<Vehicle> fetchVehicle(String id) async =>
      vehicleFromJson(await _api.get('/api/v1/vehicles/$id'));

  @override
  Future<Vehicle> addVehicle(Vehicle vehicle) async => vehicleFromJson(
    await _api.post('/api/v1/vehicles', body: vehicleToJson(vehicle)),
  );

  @override
  Future<Vehicle> updateVehicle(Vehicle vehicle) async => vehicleFromJson(
    await _api.patch('/api/v1/vehicles/${vehicle.id}', body: vehicleToJson(vehicle)),
  );

  @override
  Future<void> deleteVehicle(String id) async {
    await _api.delete('/api/v1/vehicles/$id');
  }
}

class LivePricingRepository implements PricingRepository {
  LivePricingRepository(this._api);

  final ApiClient _api;

  @override
  Future<Pricing> fetchPricing() async =>
      pricingFromJson(await _api.get('/api/v1/pricing'));
}

class LiveOrderRepository implements OrderRepository {
  LiveOrderRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<Order>> fetchOrders() async {
    final data = await _api.get('/api/v1/orders');
    return asJsonList(data).map(orderFromJson).toList();
  }

  @override
  Future<Order> fetchOrder(String id) async =>
      orderFromJson(await _api.get('/api/v1/orders/$id'));

  @override
  Future<Order> createOrder({
    required String vehicleId,
    required int months,
    required DeliveryDetails delivery,
  }) async {
    return orderFromJson(
      await _api.post(
        '/api/v1/orders',
        body: {
          'vehicleId': vehicleId,
          'months': months,
          'delivery': deliveryToJson(delivery),
        },
      ),
    );
  }

  @override
  Future<String> paymentUrl(String orderId) async {
    final data = asJsonMap(await _api.post('/api/v1/orders/$orderId/pay'));
    final url = data['url']?.toString() ?? '';
    if (url.isEmpty) {
      throw const AppException(code: 'bad_response', message: 'No payment link.');
    }
    return url;
  }
}

class LiveAlertRepository implements AlertRepository {
  LiveAlertRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<AlertItem>> fetchAlerts() async {
    final data = await _api.get('/api/v1/alerts');
    return asJsonList(data).map(alertFromJson).toList();
  }

  @override
  Future<AlertItem> fetchAlert(String id) async =>
      alertFromJson(await _api.get('/api/v1/alerts/$id'));

  @override
  Future<AlertItem> markRead(String id) async => fetchAlert(id);

  @override
  Future<AlertItem> acknowledge(String id) async =>
      alertFromJson(await _api.post('/api/v1/alerts/$id/ack'));

  @override
  Future<void> report(String id) async {
    await _api.post('/api/v1/alerts/$id/report');
  }

  @override
  Future<AlertItem> simulateAlert() {
    throw const AppException(
      code: 'debug_only',
      message: 'Simulated alerts exist only in mock mode.',
    );
  }

  @override
  Future<AlertItem> sendTest() async =>
      alertFromJson(await _api.post('/api/v1/alerts/test'));
}

Future<void> registerDevice(
  ApiClient api, {
  required String token,
  required String platform,
  required String locale,
}) {
  return api.post(
    '/api/v1/devices',
    body: {'token': token, 'platform': platform, 'locale': locale},
  );
}
