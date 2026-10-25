import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/mock/mock_providers.dart';
import '../../../account/data/account_repository.dart';
import '../../../alerts/data/alert_repository.dart';
import '../../../orders/data/order_repository.dart';
import '../../../../core/models/alert_item.dart';
import '../../../../core/models/order.dart';
import '../../../../core/models/user.dart';

final ordersProvider = FutureProvider<List<Order>>((ref) {
  return ref.watch(orderRepositoryProvider).fetchOrders();
});

final alertsProvider = FutureProvider<List<AlertItem>>((ref) {
  return ref.watch(alertRepositoryProvider).fetchAlerts();
});

final currentUserProvider = FutureProvider<User>((ref) {
  return ref.watch(accountRepositoryProvider).fetchMe();
});

final clockProvider = Provider<DateTime>((ref) {
  return ref.watch(mockDatabaseProvider).now;
});

/// `false` only after the user allowed notifications and the system denied them.
final notificationsAllowedProvider = FutureProvider<bool?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('notifications_allowed');
});

void refreshGarage(WidgetRef ref) {
  ref.invalidate(ordersProvider);
  ref.invalidate(alertsProvider);
  ref.invalidate(currentUserProvider);
}
