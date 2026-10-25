import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/models/alert_item.dart';
import 'package:mobileapp/core/models/enums.dart';
import 'package:mobileapp/core/notifications/deep_link.dart';
import 'package:mobileapp/core/router/app_routes.dart';
import 'package:mobileapp/features/alerts/presentation/alert_groups.dart';

void main() {
  final now = DateTime(2026, 6, 15, 9);

  AlertItem car({required String id, required DateTime created, DateTime? ackAt}) {
    return AlertItem(
      id: id,
      type: AlertType.carAlert,
      reason: AlertReason.blocking,
      createdAt: created,
      ackAt: ackAt,
      deliveries: const [],
    );
  }

  test('groups alerts under the newest day first', () {
    final groups = groupAlertsByDay([
      car(id: 'old', created: now.subtract(const Duration(days: 2))),
      car(id: 'new', created: now.subtract(const Duration(hours: 1))),
    ]);
    expect(groups.first.day, DateTime(2026, 6, 15));
    expect(groups.first.items.single.id, 'new');
    expect(groups.last.day, DateTime(2026, 6, 13));
  });

  test('stop alarm stays available for half an hour', () {
    final fresh = car(id: 'a', created: now.subtract(const Duration(minutes: 30)));
    final old = car(id: 'b', created: now.subtract(const Duration(minutes: 31)));
    final acked = car(
      id: 'c',
      created: now,
      ackAt: now,
    );
    expect(showStopAlarm(fresh, now, const {}), isTrue);
    expect(showStopAlarm(old, now, const {}), isFalse);
    expect(showStopAlarm(acked, now, const {}), isFalse);
    expect(showStopAlarm(fresh, now, {'a'}), isFalse);
  });

  test('an alert link opens that alert', () {
    expect(
      locationForDeepLink(Uri.parse('nawasul://alerts/alert-001')),
      AppRoutes.alert('alert-001'),
    );
    expect(
      locationForDeepLink(Uri.parse('nawasul://order/order-9')),
      AppRoutes.orderResult('order-9'),
    );
  });
}
