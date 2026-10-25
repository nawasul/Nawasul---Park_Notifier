import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_home_state.dart';
import 'package:mobileapp/core/mock/mock_payment_outcome.dart';
import 'package:mobileapp/core/mock/mock_repositories.dart';
import 'package:mobileapp/core/models/enums.dart';
import 'package:mobileapp/core/models/order.dart';
import 'package:mobileapp/core/utils/protection.dart';

void main() {
  const delivery = DeliveryDetails(
    name: 'Ahmed',
    phone: '+966512345678',
    city: 'riyadh',
    address: 'Olaya, Al Olaya, 12',
  );

  MockDatabase db() {
    return MockDatabase(
      homeState: MockHomeState.noSticker,
      delay: Duration.zero,
      now: DateTime(2026, 6, 15, 9),
    );
  }

  Future<Order> pay(MockDatabase database, MockPaymentOutcome outcome) async {
    final repo = MockOrderRepository(database);
    database.nextPayment = outcome;
    final created = await repo.createOrder(
      vehicleId: 'veh-001',
      months: 12,
      delivery: delivery,
    );
    await repo.paymentUrl(created.id);
    return repo.fetchOrder(created.id);
  }

  test('a successful payment moves the car to in transit, then active', () async {
    final database = db();
    final paid = await pay(database, MockPaymentOutcome.success);
    expect(paid.status, OrderStatus.paid);
    expect(paid.protectedUntil, DateTime(2027, 6, 15, 9));
    expect(
      protectionForVehicle(
        vehicle: database.vehicles.first,
        orders: database.orders,
        now: database.now,
      ),
      ProtectionState.inTransit,
    );

    database.markDelivered(paid.id);
    expect(
      protectionForVehicle(
        vehicle: database.vehicles.first,
        orders: database.orders,
        now: database.now,
      ),
      ProtectionState.active,
    );
  });

  test('a failed payment leaves the car without a sticker', () async {
    final database = db();
    final order = await pay(database, MockPaymentOutcome.failed);
    expect(order.status, OrderStatus.paymentFailed);
    expect(database.vehicles.first.protectedUntil, isNull);
    expect(
      protectionForVehicle(
        vehicle: database.vehicles.first,
        orders: database.orders,
        now: database.now,
      ),
      ProtectionState.noSticker,
    );
  });

  test('a pending payment stays unpaid', () async {
    final database = db();
    final order = await pay(database, MockPaymentOutcome.pending);
    expect(order.status, OrderStatus.pendingPayment);
    expect(
      protectionForVehicle(
        vehicle: database.vehicles.first,
        orders: database.orders,
        now: database.now,
      ),
      ProtectionState.paymentPending,
    );
  });
}
