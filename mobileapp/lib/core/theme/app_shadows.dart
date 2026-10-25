import 'package:flutter/material.dart';

/// Cheap depth presets — BoxShadow only, no blur filters.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x12171717),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x2EF2572B),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x1A171717),
      blurRadius: 30,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> input = [
    BoxShadow(
      color: Color(0x0F171717),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> inputFocused = [
    BoxShadow(
      color: Color(0x1FF2572B),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> iconCircle = floating;

  static const List<BoxShadow> navBar = [
    BoxShadow(
      color: Color(0x14171717),
      blurRadius: 20,
      offset: Offset(0, -4),
    ),
  ];
}
