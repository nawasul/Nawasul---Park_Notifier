import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';

enum StatusPillVariant { active, pending, muted, success, error }

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.variant = StatusPillVariant.muted,
  });

  final String label;
  final StatusPillVariant variant;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      StatusPillVariant.active => (AppColors.accentSoft, AppColors.primary),
      StatusPillVariant.pending => (AppColors.surfaceElevated, AppColors.textSecondary),
      StatusPillVariant.muted => (AppColors.borderSubtle, AppColors.textMuted),
      StatusPillVariant.success => (AppColors.successBg, AppColors.success),
      StatusPillVariant.error => (AppColors.errorBg, AppColors.error),
    };

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
