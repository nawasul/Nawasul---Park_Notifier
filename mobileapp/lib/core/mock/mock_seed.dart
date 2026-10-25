import '../config/app_config.dart';
import '../config/mock_config.dart';
import '../models/alert_item.dart';
import '../models/enums.dart';
import '../models/order.dart';
import '../models/pricing.dart';
import '../models/user.dart';
import '../models/vehicle.dart';
import '../utils/protection.dart';
import 'mock_home_state.dart';

class MockSeed {
  const MockSeed({
    required this.user,
    required this.vehicles,
    required this.orders,
    required this.alerts,
    required this.pricing,
    required this.expectedProtection,
    required this.now,
  });

  final User user;
  final List<Vehicle> vehicles;
  final List<Order> orders;
  final List<AlertItem> alerts;
  final Pricing pricing;
  final ProtectionState expectedProtection;
  final DateTime now;

  static MockSeed forState(MockHomeState state, {DateTime? now}) {
    final clock = now ?? DateTime.now();
    final user = _user();
    final pricing = _pricing();
    final vehicle = _vehicle(clock, state);
    final orders = _orders(clock, state);
    final alerts = _alerts(clock, state);
    final vehicles = state == MockHomeState.noVehicle
        ? const <Vehicle>[]
        : [vehicle];
    final seed = MockSeed(
      user: user,
      vehicles: vehicles,
      orders: orders,
      alerts: alerts,
      pricing: pricing,
      expectedProtection: _expected(state),
      now: clock,
    );
    return seed;
  }

  ProtectionState protectionAt(DateTime clock) {
    return protectionForVehicle(
      vehicle: vehicles.isEmpty ? null : vehicles.first,
      orders: orders,
      now: clock,
    );
  }

  static ProtectionState _expected(MockHomeState state) => switch (state) {
        MockHomeState.noVehicle => ProtectionState.noVehicle,
        MockHomeState.noSticker => ProtectionState.noSticker,
        MockHomeState.paymentPending => ProtectionState.paymentPending,
        MockHomeState.inTransit => ProtectionState.inTransit,
        MockHomeState.active => ProtectionState.active,
        MockHomeState.expiring => ProtectionState.expiring,
        MockHomeState.expired => ProtectionState.expired,
        MockHomeState.failedPayment => ProtectionState.noSticker,
        MockHomeState.emptyAlerts => ProtectionState.active,
      };

  static User _user() {
    return const User(
      id: 'user-001',
      name: 'Ahmed',
      phone: '+966512345678',
      city: 'Riyadh',
      preferences: Preferences(
        whatsappAlerts: true,
        pushAlerts: true,
        alarmStyle: AlarmStyle.loud,
        marketing: false,
      ),
    );
  }

  static Pricing _pricing() {
    return const Pricing(
      items: [
        PricingItem(months: 3, priceSar: MockConfig.price3MonthsSar),
        PricingItem(months: 6, priceSar: MockConfig.price6MonthsSar),
        PricingItem(months: 12, priceSar: MockConfig.price12MonthsSar),
      ],
      deliveryFeeSar: MockConfig.deliveryFeeSar,
      vatRate: MockConfig.vatRate,
      pricesIncludeVat: MockConfig.pricesIncludeVat,
      deliveryEta: MockConfig.deliveryEta,
    );
  }

  static Vehicle _vehicle(DateTime clock, MockHomeState state) {
    final until = switch (state) {
      MockHomeState.active ||
      MockHomeState.emptyAlerts =>
        clock.add(const Duration(days: 90)),
      MockHomeState.expiring => clock.add(const Duration(days: 10)),
      MockHomeState.expired => clock.subtract(const Duration(days: 2)),
      MockHomeState.inTransit => clock.add(const Duration(days: 90)),
      _ => null,
    };
    return Vehicle(
      id: 'veh-001',
      plate: 'ABC 1234',
      make: 'Toyota',
      model: 'Camry',
      color: 'White',
      qrCode: 'qr_tok_veh001',
      shortCode: 'NW-4821',
      protectedUntil: until,
    );
  }

  static List<Order> _orders(DateTime clock, MockHomeState state) {
    final status = switch (state) {
      MockHomeState.paymentPending => OrderStatus.pendingPayment,
      MockHomeState.failedPayment => OrderStatus.paymentFailed,
      MockHomeState.inTransit => OrderStatus.shipped,
      MockHomeState.active ||
      MockHomeState.expiring ||
      MockHomeState.expired ||
      MockHomeState.emptyAlerts =>
        OrderStatus.delivered,
      _ => null,
    };
    if (status == null) return const [];
    final paid = status.isPaid;
    final until = _vehicle(clock, state).protectedUntil;
    return [
      Order(
        id: 'order-001',
        number: 'NW-1001',
        vehicleId: 'veh-001',
        months: 12,
        status: status,
        amounts: const OrderAmounts(
          stickerSar: MockConfig.price12MonthsSar,
          deliverySar: MockConfig.deliveryFeeSar,
          vatSar: 49,
          totalSar: 373,
        ),
        delivery: DeliveryDetails(
          name: 'Ahmed',
          phone: '+966512345678',
          city: 'Riyadh',
          address: 'Olaya Street, Al Olaya',
          shortAddress: 'RRRD2929',
        ),
        paidAt: paid ? clock.subtract(const Duration(days: 3)) : null,
        protectedUntil: paid ? until : null,
        trackingNumber: status == OrderStatus.shipped ? 'TRK1001' : null,
        timeline: [
          OrderTimelineEvent(status: status, at: clock),
        ],
      ),
    ];
  }

  static List<AlertItem> _alerts(DateTime clock, MockHomeState state) {
    if (state == MockHomeState.emptyAlerts || state == MockHomeState.noVehicle) {
      return const [];
    }
    final car = _alert(clock);
    if (state != MockHomeState.active) return [car];
    return [
      car,
      AlertItem(
        id: 'alert-002',
        type: AlertType.orderUpdate,
        createdAt: clock.subtract(const Duration(days: 1)),
        deliveries: const [
          DeliveryStatus(
            channel: DeliveryChannel.push,
            status: DeliveryState.delivered,
          ),
        ],
      ),
      AlertItem(
        id: 'alert-003',
        type: AlertType.stickerExpiry,
        vehicleId: 'veh-001',
        createdAt: clock.subtract(const Duration(days: 3)),
        readAt: clock.subtract(const Duration(days: 3)),
        deliveries: const [
          DeliveryStatus(
            channel: DeliveryChannel.push,
            status: DeliveryState.read,
          ),
        ],
      ),
    ];
  }

  static AlertItem _alert(DateTime clock) {
    return AlertItem(
      id: 'alert-001',
      type: AlertType.carAlert,
      vehicleId: 'veh-001',
      reason: AlertReason.blocking,
      createdAt: clock.subtract(const Duration(hours: 2)),
      deliveries: const [
        DeliveryStatus(
          channel: DeliveryChannel.push,
          status: DeliveryState.delivered,
        ),
        DeliveryStatus(
          channel: DeliveryChannel.whatsapp,
          status: DeliveryState.sent,
        ),
      ],
    );
  }
}

String qrUrlFor(String code) => '${AppConfig.qrHost}/qr/$code';
