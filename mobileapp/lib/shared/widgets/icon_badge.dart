import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';

/// Flat tinted circle behind a decorative icon — no gradient, no blur filter.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.size = 72,
    this.iconSize = 36,
    this.iconColor = AppColors.primary,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primaryContainer,
        shape: BoxShape.circle,
        boxShadow: AppShadows.iconCircle,
      ),
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
