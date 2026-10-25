import '../../../core/models/alert_item.dart';
import '../../../core/models/enums.dart';
import '../../../core/notifications/notification_service.dart';

class AlertDayGroup {
  const AlertDayGroup({required this.day, required this.items});

  final DateTime day;
  final List<AlertItem> items;
}

List<AlertDayGroup> groupAlertsByDay(List<AlertItem> alerts) {
  final sorted = [...alerts]
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  final groups = <DateTime, List<AlertItem>>{};
  for (final alert in sorted) {
    final day = DateTime(
      alert.createdAt.year,
      alert.createdAt.month,
      alert.createdAt.day,
    );
    groups.putIfAbsent(day, () => []).add(alert);
  }
  return [
    for (final entry in groups.entries)
      AlertDayGroup(day: entry.key, items: entry.value),
  ];
}

bool showStopAlarm(AlertItem alert, DateTime now, Set<String> stopped) {
  if (alert.type != AlertType.carAlert) return false;
  if (alert.ackAt != null || stopped.contains(alert.id)) return false;
  final age = now.difference(alert.createdAt);
  return !age.isNegative && age <= alarmRecentWindow;
}
