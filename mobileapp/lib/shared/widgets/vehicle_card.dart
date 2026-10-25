import 'package:flutter/material.dart';

import '../../core/models/vehicle.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'status_pill.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.compact = false,
    this.statusLabel,
    this.statusVariant = StatusPillVariant.muted,
  });

  final Vehicle vehicle;
  final VoidCallback? onTap;
  final bool compact;
  final String? statusLabel;
  final StatusPillVariant statusVariant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.all(compact ? AppSpacing.md : AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 48 : 56,
              height: compact ? 48 : 56,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                AppIcons.car,
                color: AppColors.primary,
                size: compact ? 24 : 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.displayName,
                    style: AppTypography.bodyL.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    vehicle.plate,
                    textDirection: TextDirection.ltr,
                    style: AppTypography.bodyM,
                  ),
                ],
              ),
            ),
            if (statusLabel != null)
              StatusPill(label: statusLabel!, variant: statusVariant),
          ],
        ),
      ),
    );
  }
}
