import 'dart:async';

import 'notification_service.dart';

/// Web and test fallback. Permission stays denied so Home can show the
/// blocked banner after the user asks to allow alerts.
class NoopNotificationService implements NotificationService {
  final _taps = StreamController<NotificationEvent>.broadcast();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getPushToken() async => null;

  @override
  Stream<NotificationEvent> get onTap => _taps.stream;

  @override
  Future<void> showAlarmAlert(AlertPayload payload) async {}

  @override
  Future<void> stopAlarm(String alertId) async {}

  @override
  Future<bool> openSystemSettings() async => false;

  @override
  Future<bool> loudAlertsReady() async => false;

  void dispose() {
    _taps.close();
  }
}
