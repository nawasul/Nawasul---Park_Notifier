import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends AsyncNotifier<Locale> {
  static const prefsKey = 'app_language';

  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(prefsKey);
    if (saved == 'ar' || saved == 'en') return Locale(saved!);
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    return Locale(device.languageCode == 'ar' ? 'ar' : 'en');
  }

  Future<void> setLanguageCode(String code) async {
    final next = code == 'ar' ? 'ar' : 'en';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, next);
    state = AsyncData(Locale(next));
  }
}

final localeProvider =
    AsyncNotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
