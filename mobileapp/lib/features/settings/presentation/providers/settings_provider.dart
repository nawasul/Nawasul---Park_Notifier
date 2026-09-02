import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../language/presentation/language_selection_screen.dart';

class NotificationPreferences {
  const NotificationPreferences({
    this.pushNotifications = true,
    this.smsAlerts = true,
    this.automatedCallAlerts = true,
    this.emailUpdates = false,
  });

  final bool pushNotifications;
  final bool smsAlerts;
  final bool automatedCallAlerts;
  final bool emailUpdates;

  NotificationPreferences copyWith({
    bool? pushNotifications,
    bool? smsAlerts,
    bool? automatedCallAlerts,
    bool? emailUpdates,
  }) {
    return NotificationPreferences(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsAlerts: smsAlerts ?? this.smsAlerts,
      automatedCallAlerts: automatedCallAlerts ?? this.automatedCallAlerts,
      emailUpdates: emailUpdates ?? this.emailUpdates,
    );
  }
}

class NotificationPreferencesNotifier extends Notifier<NotificationPreferences> {
  @override
  NotificationPreferences build() => const NotificationPreferences();

  void setPushNotifications(bool value) {
    state = state.copyWith(pushNotifications: value);
  }

  void setSmsAlerts(bool value) {
    state = state.copyWith(smsAlerts: value);
  }

  void setAutomatedCallAlerts(bool value) {
    state = state.copyWith(automatedCallAlerts: value);
  }

  void setEmailUpdates(bool value) {
    state = state.copyWith(emailUpdates: value);
  }
}

final notificationPreferencesProvider = NotifierProvider<
    NotificationPreferencesNotifier, NotificationPreferences>(
  NotificationPreferencesNotifier.new,
);

class AppLanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => AppLanguage.english;

  void setLanguage(AppLanguage language) {
    state = language;
  }
}

final appLanguageProvider =
    NotifierProvider<AppLanguageNotifier, AppLanguage>(AppLanguageNotifier.new);
