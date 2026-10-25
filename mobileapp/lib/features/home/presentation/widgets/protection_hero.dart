import 'package:flutter/material.dart';

import '../../../../core/models/enums.dart';
import '../../../../core/models/vehicle.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/plate_badge.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/thin_progress_bar.dart';

class ProtectionHero extends StatelessWidget {
  const ProtectionHero({
    super.key,
    required this.vehicle,
    required this.state,
    required this.status,
    this.daysLabel,
    this.validUntilLabel,
    this.progress = 0,
    this.actionLabel,
    this.onAction,
  });

  final Vehicle? vehicle;
  final ProtectionState state;
  final String status;
  final String? daysLabel;
  final String? validUntilLabel;
  final double progress;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (state) {
      ProtectionState.active => AppColors.success,
      ProtectionState.expiring || ProtectionState.paymentPending => AppColors.warning,
      ProtectionState.expired => AppColors.error,
      _ => AppColors.textOnDark,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: BorderRadius.circular(AppRadius.hero),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppGradients.heroGlow,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.hero)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vehicle != null) ...[
              Text(
                vehicle!.displayName,
                style: AppTypography.headingM.copyWith(color: AppColors.textOnDark),
              ),
              const SizedBox(height: AppSpacing.sm),
              PlateBadge(plate: vehicle!.plate, onDark: true),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(status, style: AppTypography.headingL.copyWith(color: statusColor)),
            if (daysLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                daysLabel!,
                style: AppTypography.displayL.copyWith(color: statusColor),
              ),
            ],
            if (validUntilLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                validUntilLabel!,
                style: AppTypography.bodyM.copyWith(color: AppColors.textOnDarkSecondary),
              ),
            ],
            if (progress > 0) ...[
              const SizedBox(height: AppSpacing.md),
              ThinProgressBar(
                value: progress,
                color: statusColor,
                track: AppColors.surfaceDarkElevated,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
