import 'alarm_channel.dart';

/// Alarm-style alerts. Chrome uses [NoopNotificationService].
/// Real push is added in a later phase.
const alarmAndroidChannelId = AlarmChannel.androidChannelId;

abstract class NotificationService {
  Future<bool> requestPermission();

  Future<String?> getPushToken();

  Stream<NotificationEvent> get onTap;

  Future<void> showAlarmAlert(AlertPayload payload);

  Future<void> stopAlarm(String alertId);

  /// Opens the system notification settings. False when this device cannot.
  Future<bool> openSystemSettings();

  /// True when the loud alarm channel is ready on this device.
  Future<bool> loudAlertsReady();
}

class NotificationEvent {
  const NotificationEvent({required this.alertId});

  final String alertId;
}

class AlertPayload {
  const AlertPayload({
    required this.alertId,
    required this.title,
    required this.body,
  });

  final String alertId;
  final String title;
  final String body;
}

/// How long "Stop alarm" stays available after a car alert.
/// The sound itself is device-only and is not played in Chrome.
const alarmRecentWindow = Duration(minutes: 30);
