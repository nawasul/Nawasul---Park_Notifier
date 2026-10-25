import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/router/app_routes.dart';
import '../../data/auth_repository.dart';

class Session {
  const Session({
    required this.isAuthenticated,
    required this.hasSeenOnboarding,
    required this.isNewUser,
    required this.profileComplete,
    required this.alertsPromptSeen,
    this.phoneE164,
  });

  final bool isAuthenticated;
  final bool hasSeenOnboarding;
  final bool isNewUser;
  final bool profileComplete;
  final bool alertsPromptSeen;
  final String? phoneE164;

  static const empty = Session(
    isAuthenticated: false,
    hasSeenOnboarding: false,
    isNewUser: false,
    profileComplete: false,
    alertsPromptSeen: false,
  );
}

/// Where a cold start or a finished auth step should land.
String destinationFor(Session session) {
  if (session.isAuthenticated) {
    if (session.isNewUser && !session.profileComplete) return AppRoutes.name;
    if (session.isNewUser && !session.alertsPromptSeen) {
      return AppRoutes.allowAlerts;
    }
    return AppRoutes.home;
  }
  if (!session.hasSeenOnboarding) return AppRoutes.onboarding;
  return AppRoutes.phone;
}

class SessionNotifier extends AsyncNotifier<Session> {
  static const authenticatedKey = 'session_authenticated';
  static const onboardingKey = 'onboarding_seen';
  static const newUserKey = 'is_new_user';
  static const profileKey = 'profile_complete';
  static const alertsKey = 'alerts_prompt_seen';
  static const phoneKey = 'session_phone';

  @override
  Future<Session> build() => _read();

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingKey, true);
    state = AsyncData(await _read());
  }

  Future<void> signIn({
    required bool isNewUser,
    required String phoneE164,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(authenticatedKey, true);
    await prefs.setBool(newUserKey, isNewUser);
    await prefs.setString(phoneKey, phoneE164);
    if (isNewUser) {
      await prefs.setBool(profileKey, false);
      await prefs.setBool(alertsKey, false);
    } else {
      await prefs.setBool(profileKey, true);
      await prefs.setBool(alertsKey, true);
    }
    state = AsyncData(await _read());
  }

  Future<void> completeProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(profileKey, true);
    state = AsyncData(await _read());
  }

  Future<void> completeAlertsPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(alertsKey, true);
    state = AsyncData(await _read());
  }

  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } on Object {
      // The local session still ends if the server cannot be reached.
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(authenticatedKey, false);
    await prefs.remove(phoneKey);
    await prefs.setBool(newUserKey, false);
    state = AsyncData(await _read());
  }

  Future<Session> _read() async {
    final prefs = await SharedPreferences.getInstance();
    return Session(
      isAuthenticated: prefs.getBool(authenticatedKey) ?? false,
      hasSeenOnboarding: prefs.getBool(onboardingKey) ?? false,
      isNewUser: prefs.getBool(newUserKey) ?? false,
      profileComplete: prefs.getBool(profileKey) ?? false,
      alertsPromptSeen: prefs.getBool(alertsKey) ?? false,
      phoneE164: prefs.getString(phoneKey),
    );
  }
}

final sessionProvider =
    AsyncNotifierProvider<SessionNotifier, Session>(SessionNotifier.new);
