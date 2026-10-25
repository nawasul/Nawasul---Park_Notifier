import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum AppLogoSize { large, small }

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = AppLogoSize.large,
    this.showTagline = true,
    this.tagline,
  });

  final AppLogoSize size;
  final bool showTagline;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final isLarge = size == AppLogoSize.large;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'نواصل',
          style: AppTypography.arabicHeading('نواصل').copyWith(
            fontSize: isLarge ? 36 : 22,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: isLarge ? AppSpacing.sm : AppSpacing.xs),
        Text(
          'NAWASUL',
          style: (isLarge ? AppTypography.headingL : AppTypography.headingM)
              .copyWith(
            letterSpacing: isLarge ? 6 : 4,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: isLarge ? AppSpacing.sm : AppSpacing.xs),
        if (showTagline && tagline != null)
          Text(
            tagline!,
            style: AppTypography.caption.copyWith(
              fontSize: isLarge ? 12 : 10,
              letterSpacing: isLarge ? 3 : 2,
              color: AppColors.secondary,
            ),
          ),
      ],
    );
  }
}
