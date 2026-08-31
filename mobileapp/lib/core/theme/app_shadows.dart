import 'package:flutter/material.dart';

/// Cheap depth presets — BoxShadow only, no blur filters.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x474A70A9),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> input = [
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> inputFocused = [
    BoxShadow(
      color: Color(0x1F4A70A9),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> iconCircle = [
    BoxShadow(
      color: Color(0x144A70A9),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}
