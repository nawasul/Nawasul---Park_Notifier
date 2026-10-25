import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Static decorations. The orange glow is a radial fill, never a blur filter.
class AppGradients {
  AppGradients._();

  static const hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandDark, Color(0xFF2E2E2E)],
  );

  /// Primary at about 12% opacity, top-right corner.
  static const heroGlow = RadialGradient(
    center: Alignment.topRight,
    radius: 1.1,
    colors: [Color(0x1FF2572B), Color(0x00F2572B)],
  );

  static const primary = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary, AppColors.primaryDark],
  );
}
