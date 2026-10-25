/// Platform alarm setup that Chrome cannot exercise.
///
/// Android creates channel [androidChannelId] at process start
/// (`AlarmChannel.kt`): high importance, alarm usage, no full-screen
/// intent, and Do Not Disturb is not bypassed. A repeating sound is
/// applied on the notification itself when push is connected later.
///
/// iOS uses Time-Sensitive interruption level only. Critical Alerts
/// are not requested. The entitlement lives in
/// `ios/Runner/Runner.entitlements` and must be enabled on the Apple
/// developer account before a device build.
class AlarmChannel {
  AlarmChannel._();

  static const androidChannelId = 'nawasul_alarm';
  static const androidChannelName = 'Car alerts';
  static const iosInterruptionLevel = 'time-sensitive';
}
