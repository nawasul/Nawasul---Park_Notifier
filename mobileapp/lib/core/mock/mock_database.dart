import '../config/app_config.dart';
import '../models/alert_item.dart';
import '../models/enums.dart';
import '../models/order.dart';
import '../models/pricing.dart';
import '../models/user.dart';
import '../models/vehicle.dart';
import 'mock_home_state.dart';
import 'mock_payment_outcome.dart';
import 'mock_seed.dart';

/// Shared in-memory store so every mock repository sees the same seed.
class MockDatabase {
  factory MockDatabase({
    MockHomeState? homeState,
    Duration delay = const Duration(milliseconds: 400),
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    return MockDatabase._(
      homeState: homeState,
      delay: delay,
      clock: clock,
    );
  }

  MockDatabase._({
    MockHomeState? homeState,
    required this.delay,
    required DateTime clock,
  }) : now = clock,
       seed = MockSeed.forState(
         homeState ?? AppConfig.mockHomeState,
         now: clock,
       ) {
    user = seed.user;
    vehicles = List.of(seed.vehicles);
    orders = List.of(seed.orders);
    alerts = List.of(seed.alerts);
    pricing = seed.pricing;
  }

  void applyHomeState(MockHomeState state) {
    final next = MockSeed.forState(state, now: now);
    user = next.user;
    vehicles = List.of(next.vehicles);
    orders = List.of(next.orders);
    alerts = List.of(next.alerts);
    pricing = next.pricing;
    lastDeleteReason = null;
    armedPayment.clear();
  }

  /// Moves a paid order to delivered so Home can show Active.
  void markDelivered(String id) {
    final index = orders.indexWhere((order) => order.id == id);
    if (index < 0) return;
    final order = orders[index];
    if (!order.status.isPaid || order.status == OrderStatus.delivered) return;
    final digits = order.number.replaceAll(RegExp(r'\D'), '');
    orders[index] = order.copyWith(
      status: OrderStatus.delivered,
      trackingNumber: order.trackingNumber ?? 'TRK$digits',
      timeline: [
        ...order.timeline,
        if (!order.timeline.any((event) => event.status == OrderStatus.printed))
          OrderTimelineEvent(status: OrderStatus.printed, at: now),
        if (!order.timeline.any((event) => event.status == OrderStatus.shipped))
          OrderTimelineEvent(status: OrderStatus.shipped, at: now),
        OrderTimelineEvent(status: OrderStatus.delivered, at: now),
      ],
    );
  }

  final MockSeed seed;
  final Duration delay;
  final DateTime now;

  late User user;
  String? lastDeleteReason;
  late List<Vehicle> vehicles;
  late List<Order> orders;
  late List<AlertItem> alerts;
  late Pricing pricing;

  int alertSerial = 100;
  MockPaymentOutcome nextPayment = MockPaymentOutcome.success;
  DeliveryDetails? savedDelivery;
  final Map<String, MockPaymentOutcome> armedPayment = {};

  String? pendingPhone;
  PendingOtp? pendingOtp;

  Future<void> pause() {
    if (delay == Duration.zero) return Future<void>.value();
    return Future<void>.delayed(delay);
  }
}

class PendingOtp {
  const PendingOtp({
    required this.phone,
    required this.attemptsLeft,
    required this.noWhatsapp,
    this.lockedUntil,
  });

  final String phone;
  final int attemptsLeft;
  final bool noWhatsapp;
  final DateTime? lockedUntil;

  PendingOtp copyWith({
    int? attemptsLeft,
    DateTime? lockedUntil,
  }) {
    return PendingOtp(
      phone: phone,
      attemptsLeft: attemptsLeft ?? this.attemptsLeft,
      noWhatsapp: noWhatsapp,
      lockedUntil: lockedUntil ?? this.lockedUntil,
    );
  }
}
