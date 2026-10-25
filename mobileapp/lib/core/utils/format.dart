import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Keeps digits Western even when the locale would use Arabic-Indic numerals.
String westernDigits(String value) {
  const eastern = '٠١٢٣٤٥٦٧٨٩';
  const western = '0123456789';
  var out = value;
  for (var i = 0; i < eastern.length; i++) {
    out = out.replaceAll(eastern[i], western[i]);
  }
  return out;
}

String formatAppDate(DateTime date, String languageCode) {
  final formatted = DateFormat.yMMMd(languageCode).format(date);
  return westernDigits(formatted);
}

String formatAppTime(DateTime date, String languageCode) {
  final formatted = DateFormat.jm(languageCode).format(date);
  return westernDigits(formatted);
}

/// English "SAR 150", Arabic "150 ر.س". Digits stay Western.
String formatSar(int amount, String languageCode) {
  final digits = westernDigits(amount.toString());
  if (languageCode == 'ar') return '$digits ر.س';
  return 'SAR $digits';
}

/// Shows the country code and the last four digits.
String maskPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 8) return westernDigits(phone);
  final last = digits.substring(digits.length - 4);
  return '+966 5X XXX $last';
}

String nameInitials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2);
  return parts.map((part) => part.characters.first).join();
}
