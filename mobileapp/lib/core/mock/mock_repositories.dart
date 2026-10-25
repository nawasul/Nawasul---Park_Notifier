import '../config/app_config.dart';
import '../config/mock_config.dart';
import '../models/alert_item.dart';
import '../models/enums.dart';
import '../models/order.dart';
import '../models/pricing.dart';
import '../models/user.dart';
import '../models/vehicle.dart';
import '../utils/order_quote.dart';
import '../utils/protection.dart';
import '../utils/validators.dart';
import 'mock_database.dart';
import 'mock_payment_outcome.dart';

class MockAuthRepository {
  MockAuthRepository(this.db);

  final MockDatabase db;

  Future<SendOtpResult> sendOtp(String phoneE164) async {
    await db.pause();
    if (!PhoneValidator.isValidE164(phoneE164)) {
      throw const AppException(code: 'invalid_phone', message: 'invalid_phone');
    }
    if (phoneE164 == MockConfig.networkPhone) {
      throw const AppException(code: 'network', message: 'network');
    }
    if (phoneE164 == MockConfig.rateLimitedPhone) {
      throw const AppException(
        code: 'rate_limited',
        message: 'rate_limited',
        retryAfterSeconds: 60,
      );
    }
    final existing = db.pendingOtp;
    final lockedUntil = existing?.lockedUntil;
    if (existing != null &&
        existing.phone == phoneE164 &&
        lockedUntil != null &&
        DateTime.now().isBefore(lockedUntil)) {
      throw AppException(
        code: 'too_many_attempts',
        message: 'too_many_attempts',
        retryAfterSeconds: lockedUntil.difference(DateTime.now()).inSeconds,
      );
    }
    final noWhatsapp = phoneE164 == MockConfig.noWhatsappPhone;
    db.pendingPhone = phoneE164;
    db.pendingOtp = PendingOtp(
      phone: phoneE164,
      attemptsLeft: MockConfig.otpAttempts,
      noWhatsapp: noWhatsapp,
    );
    return SendOtpResult(delivered: !noWhatsapp);
  }

  Future<VerifyResult> verifyOtp(String phoneE164, String code) async {
    await db.pause();
    if (!PhoneValidator.isValidE164(phoneE164)) {
      throw const AppException(code: 'invalid_phone', message: 'invalid_phone');
    }
    final pending = db.pendingOtp;
    if (pending == null || pending.phone != phoneE164) {
      throw const AppException(code: 'expired_otp', message: 'expired_otp');
    }
    final lockedUntil = pending.lockedUntil;
    if (lockedUntil != null && DateTime.now().isBefore(lockedUntil)) {
      throw AppException(
        code: 'too_many_attempts',
        message: 'too_many_attempts',
        retryAfterSeconds: lockedUntil.difference(DateTime.now()).inSeconds,
      );
    }
    if (pending.noWhatsapp) {
      throw const AppException(code: 'no_whatsapp', message: 'no_whatsapp');
    }
    if (code == MockConfig.expiredOtp) {
      throw const AppException(code: 'expired_otp', message: 'expired_otp');
    }
    if (code != MockConfig.successOtp) {
      final left = pending.attemptsLeft - 1;
      if (left <= 0) {
        final until = DateTime.now().add(const Duration(seconds: 60));
        db.pendingOtp = pending.copyWith(attemptsLeft: 0, lockedUntil: until);
        throw const AppException(
          code: 'too_many_attempts',
          message: 'too_many_attempts',
          attemptsLeft: 0,
          retryAfterSeconds: 60,
        );
      }
      db.pendingOtp = pending.copyWith(attemptsLeft: left);
      throw AppException(
        code: 'invalid_otp',
        message: 'invalid_otp',
        attemptsLeft: left,
      );
    }
    final isNewUser = phoneE164 != db.user.phone;
    if (isNewUser) {
      db.user = db.user.copyWith(phone: phoneE164);
      db.vehicles = [];
      db.orders = [];
      db.alerts = [];
    }
    db.pendingOtp = null;
    return VerifyResult(
      accessToken: 'mock-access',
      refreshToken: 'mock-refresh',
      isNewUser: isNewUser,
    );
  }

  /// Same result as a correct code, without sending or checking WhatsApp.
  Future<VerifyResult> acceptPhone(String phoneE164) async {
    await db.pause();
    if (!PhoneValidator.isValidE164(phoneE164)) {
      throw const AppException(code: 'invalid_phone', message: 'invalid_phone');
    }
    final isNewUser = phoneE164 != db.user.phone;
    if (isNewUser) {
      db.user = db.user.copyWith(phone: phoneE164);
      db.vehicles = [];
      db.orders = [];
      db.alerts = [];
    }
    db.pendingOtp = null;
    db.pendingPhone = phoneE164;
    return VerifyResult(
      accessToken: 'mock-access',
      refreshToken: 'mock-refresh',
      isNewUser: isNewUser,
    );
  }

  Future<void> logout() async {
    await db.pause();
    db.pendingPhone = null;
  }
}

class MockVehicleRepository {
  MockVehicleRepository(this.db);

  final MockDatabase db;

  Future<List<Vehicle>> fetchVehicles() async {
    await db.pause();
    return List.of(db.vehicles);
  }

  Future<Vehicle> fetchVehicle(String id) async {
    await db.pause();
    return db.vehicles.firstWhere((vehicle) => vehicle.id == id);
  }

  Future<Vehicle> addVehicle(Vehicle vehicle) async {
    await db.pause();
    _ensureUniquePlate(vehicle);
    final id = vehicle.id.isEmpty
        ? 'veh-${db.vehicles.length + 1}'
        : vehicle.id;
    final created = vehicle.copyWith(
      id: id,
      qrCode: vehicle.qrCode.isEmpty ? 'qr_tok_$id' : vehicle.qrCode,
      shortCode: vehicle.shortCode.isEmpty
          ? 'NW-${5000 + db.vehicles.length}'
          : vehicle.shortCode,
    );
    db.vehicles = [...db.vehicles, created];
    return created;
  }

  Future<Vehicle> updateVehicle(Vehicle vehicle) async {
    await db.pause();
    _ensureUniquePlate(vehicle);
    db.vehicles = [
      for (final item in db.vehicles)
        if (item.id == vehicle.id) vehicle else item,
    ];
    return vehicle;
  }

  Future<void> deleteVehicle(String id) async {
    await db.pause();
    db.vehicles = db.vehicles.where((vehicle) => vehicle.id != id).toList();
    db.orders = db.orders.where((order) => order.vehicleId != id).toList();
    db.alerts = db.alerts.where((alert) => alert.vehicleId != id).toList();
  }

  void _ensureUniquePlate(Vehicle vehicle) {
    final plate = PlateValidator.normalize(vehicle.plate);
    final clash = db.vehicles.any(
      (item) =>
          item.id != vehicle.id && PlateValidator.normalize(item.plate) == plate,
    );
    if (clash) {
      throw const AppException(
        code: 'duplicate_plate',
        message: 'duplicate_plate',
      );
    }
  }
}

class MockOrderRepository {
  MockOrderRepository(this.db);

  final MockDatabase db;

  Future<List<Order>> fetchOrders() async {
    await db.pause();
    return List.of(db.orders);
  }

  Future<Order> fetchOrder(String id) async {
    await db.pause();
    final outcome = db.armedPayment.remove(id);
    if (outcome != null) _applyOutcome(id, outcome);
    return db.orders.firstWhere((order) => order.id == id);
  }

  Future<Order> createOrder({
    required String vehicleId,
    required int months,
    required DeliveryDetails delivery,
  }) async {
    await db.pause();
    final item = db.pricing.items.firstWhere((entry) => entry.months == months);
    final amounts = quoteAmounts(
      stickerSar: item.priceSar,
      deliverySar: db.pricing.deliveryFeeSar,
      vatRate: db.pricing.vatRate,
      pricesIncludeVat: db.pricing.pricesIncludeVat,
    );
    final order = Order(
      id: 'order-${db.orders.length + 1}',
      number: 'NW-${1000 + db.orders.length + 1}',
      vehicleId: vehicleId,
      months: months,
      status: OrderStatus.pendingPayment,
      amounts: amounts,
      delivery: delivery,
      timeline: [
        OrderTimelineEvent(
          status: OrderStatus.pendingPayment,
          at: db.now,
        ),
      ],
    );
    db.orders = [...db.orders, order];
    return order;
  }

  Future<String> paymentUrl(String orderId) async {
    await db.pause();
    db.armedPayment[orderId] = db.nextPayment;
    final index = db.orders.indexWhere((order) => order.id == orderId);
    if (index >= 0 && !db.orders[index].status.isPaid) {
      db.orders[index] = db.orders[index].copyWith(
        status: OrderStatus.pendingPayment,
      );
    }
    return 'https://nawasul.app/pay/mock/$orderId';
  }

  void _applyOutcome(String id, MockPaymentOutcome outcome) {
    final index = db.orders.indexWhere((order) => order.id == id);
    if (index < 0) return;
    final order = db.orders[index];
    switch (outcome) {
      case MockPaymentOutcome.pending:
        db.orders[index] = order.copyWith(status: OrderStatus.pendingPayment);
      case MockPaymentOutcome.failed:
        db.orders[index] = order.copyWith(
          status: OrderStatus.paymentFailed,
          timeline: [
            ...order.timeline,
            OrderTimelineEvent(status: OrderStatus.paymentFailed, at: db.now),
          ],
        );
      case MockPaymentOutcome.success:
        final until = computeProtectedUntil(
          db.now,
          order.months,
          bufferDays: AppConfig.shippingBufferDays,
        );
        db.orders[index] = order.copyWith(
          status: OrderStatus.paid,
          paidAt: db.now,
          protectedUntil: until,
          invoiceUrl: 'https://nawasul.app/invoices/${order.number}',
          timeline: [
            ...order.timeline,
            OrderTimelineEvent(status: OrderStatus.paid, at: db.now),
          ],
        );
        db.vehicles = [
          for (final vehicle in db.vehicles)
            if (vehicle.id == order.vehicleId)
              vehicle.copyWith(protectedUntil: until)
            else
              vehicle,
        ];
    }
  }
}

class MockAlertRepository {
  MockAlertRepository(this.db);

  final MockDatabase db;

  Future<List<AlertItem>> fetchAlerts() async {
    await db.pause();
    return List.of(db.alerts);
  }

  Future<AlertItem> fetchAlert(String id) async {
    await db.pause();
    return db.alerts.firstWhere((alert) => alert.id == id);
  }

  Future<AlertItem> markRead(String id) async {
    await db.pause();
    return _replace(id, (alert) {
      return alert.copyWith(readAt: alert.readAt ?? db.now);
    });
  }

  Future<AlertItem> acknowledge(String id) async {
    await db.pause();
    return _replace(id, (alert) {
      return alert.copyWith(
        readAt: alert.readAt ?? db.now,
        ackAt: alert.ackAt ?? db.now,
      );
    });
  }

  Future<AlertItem> sendTest() async {
    await db.pause();
    db.alertSerial += 1;
    final prefs = db.user.preferences;
    final deliveries = <DeliveryStatus>[
      if (prefs.pushAlerts)
        const DeliveryStatus(
          channel: DeliveryChannel.push,
          status: DeliveryState.sent,
        ),
      if (prefs.whatsappAlerts)
        const DeliveryStatus(
          channel: DeliveryChannel.whatsapp,
          status: DeliveryState.sent,
        ),
    ];
    final alert = AlertItem(
      id: 'alert-${db.alertSerial}',
      type: AlertType.carAlert,
      vehicleId: db.vehicles.isEmpty ? null : db.vehicles.first.id,
      isTest: true,
      createdAt: db.now,
      deliveries: deliveries.isEmpty
          ? const [
              DeliveryStatus(
                channel: DeliveryChannel.push,
                status: DeliveryState.sent,
              ),
            ]
          : deliveries,
    );
    db.alerts = [alert, ...db.alerts];
    return alert;
  }

  Future<AlertItem> simulateAlert() async {
    await db.pause();
    db.alertSerial += 1;
    final vehicleId = db.vehicles.isEmpty ? null : db.vehicles.first.id;
    final alert = AlertItem(
      id: 'alert-${db.alertSerial}',
      type: AlertType.carAlert,
      vehicleId: vehicleId,
      reason: AlertReason.lightsOn,
      createdAt: db.now,
      deliveries: const [
        DeliveryStatus(
          channel: DeliveryChannel.push,
          status: DeliveryState.sent,
        ),
        DeliveryStatus(
          channel: DeliveryChannel.whatsapp,
          status: DeliveryState.sent,
        ),
      ],
    );
    db.alerts = [alert, ...db.alerts];
    return alert;
  }

  Future<void> report(String id) async {
    await db.pause();
    db.alerts = db.alerts.where((alert) => alert.id != id).toList();
  }

  AlertItem _replace(String id, AlertItem Function(AlertItem alert) update) {
    AlertItem? updated;
    db.alerts = [
      for (final alert in db.alerts)
        if (alert.id == id) (updated = update(alert)) else alert,
    ];
    return updated!;
  }
}

class MockAccountRepository {
  MockAccountRepository(this.db);

  final MockDatabase db;

  Future<User> fetchMe() async {
    await db.pause();
    return db.user;
  }

  Future<User> updateMe({required String name, String? city}) async {
    await db.pause();
    db.user = db.user.copyWith(name: name, city: city);
    return db.user;
  }

  Future<void> deleteMe({String? reason}) async {
    await db.pause();
    db.lastDeleteReason = reason;
    db.vehicles = [];
    db.alerts = [];
    db.orders = db.orders.where((order) => order.status.isPaid).toList();
  }

  Future<Preferences> fetchPreferences() async {
    await db.pause();
    return db.user.preferences;
  }

  Future<Preferences> updatePreferences(Preferences preferences) async {
    await db.pause();
    db.user = db.user.copyWith(preferences: preferences);
    return db.user.preferences;
  }
}

class MockPricingRepository {
  MockPricingRepository(this.db);

  final MockDatabase db;

  Future<Pricing> fetchPricing() async {
    await db.pause();
    return db.pricing;
  }
}
