import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum InfoBannerTone { info, warning, error }

class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.tone = InfoBannerTone.info,
  });

  final String message;
  final InfoBannerTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      InfoBannerTone.info => (AppColors.primaryContainer, AppColors.textPrimary),
      InfoBannerTone.warning => (AppColors.warningContainer, AppColors.warning),
      InfoBannerTone.error => (AppColors.errorContainer, AppColors.error),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        message,
        style: AppTypography.bodyM.copyWith(color: foreground),
      ),
    );
  }
}
