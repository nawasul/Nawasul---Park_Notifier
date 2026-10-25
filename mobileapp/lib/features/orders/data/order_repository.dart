import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/mock/mock_repositories.dart';
import '../../../core/models/order.dart';
import '../../../core/network/live_repositories.dart';
import '../../../core/network/network_providers.dart';

abstract class OrderRepository {
  Future<List<Order>> fetchOrders();
  Future<Order> fetchOrder(String id);
  Future<Order> createOrder({
    required String vehicleId,
    required int months,
    required DeliveryDetails delivery,
  });
  Future<String> paymentUrl(String orderId);
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  if (!AppConfig.useMock) {
    return LiveOrderRepository(ref.watch(apiClientProvider));
  }
  return _OrderAdapter(MockOrderRepository(ref.watch(mockDatabaseProvider)));
});

class _OrderAdapter implements OrderRepository {
  _OrderAdapter(this._mock);

  final MockOrderRepository _mock;

  @override
  Future<List<Order>> fetchOrders() => _mock.fetchOrders();

  @override
  Future<Order> fetchOrder(String id) => _mock.fetchOrder(id);

  @override
  Future<Order> createOrder({
    required String vehicleId,
    required int months,
    required DeliveryDetails delivery,
  }) {
    return _mock.createOrder(
      vehicleId: vehicleId,
      months: months,
      delivery: delivery,
    );
  }

  @override
  Future<String> paymentUrl(String orderId) => _mock.paymentUrl(orderId);
}
