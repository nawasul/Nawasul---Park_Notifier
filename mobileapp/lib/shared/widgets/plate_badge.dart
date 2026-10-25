import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class PlateBadge extends StatelessWidget {
  const PlateBadge({
    super.key,
    required this.plate,
    this.onDark = false,
  });

  final String plate;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: onDark ? AppColors.surfaceDarkElevated : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        plate,
        textDirection: TextDirection.ltr,
        style: AppTypography.bodyL.copyWith(
          fontWeight: FontWeight.w600,
          color: onDark ? AppColors.textOnDark : AppColors.textPrimary,
        ),
      ),
    );
  }
}
