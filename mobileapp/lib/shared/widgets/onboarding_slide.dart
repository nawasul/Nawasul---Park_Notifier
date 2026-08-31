import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Static onboarding slide — entrance handled by parent stagger animation.
class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.icon,
    required this.heading,
    required this.subheading,
    this.iconColor = AppColors.primary,
  });

  final IconData icon;
  final String heading;
  final String subheading;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSpacing.iconHero,
            height: AppSpacing.iconHero,
            decoration: const BoxDecoration(
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
              boxShadow: AppShadows.iconCircle,
            ),
            child: Icon(
              icon,
              size: 88,
              color: iconColor,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            heading,
            style: AppTypography.headingL,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            subheading,
            style: AppTypography.bodyL.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
