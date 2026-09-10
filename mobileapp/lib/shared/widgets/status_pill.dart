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
      StatusPillVariant.active => (
          AppColors.successContainer,
          AppColors.success,
        ),
      StatusPillVariant.pending => (
          AppColors.warningContainer,
          AppColors.warning,
        ),
      StatusPillVariant.muted => (
          AppColors.surfaceContainer,
          AppColors.textMuted,
        ),
      StatusPillVariant.success => (
          AppColors.successContainer,
          AppColors.success,
        ),
      StatusPillVariant.error => (
          AppColors.errorContainer,
          AppColors.error,
        ),
    };

    return Chip(
      label: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: bg,
      side: BorderSide.none,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}
