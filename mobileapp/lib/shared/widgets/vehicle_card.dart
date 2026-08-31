import 'package:flutter/material.dart';

import '../../core/mock/mock_vehicles.dart';
import '../../core/theme/app_colors.dart';
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
  });

  final Vehicle vehicle;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final statusLabel = vehicle.qrStatus == QrStatus.active
        ? 'QR Active'
        : 'Sticker Pending';
    final statusVariant = vehicle.qrStatus == QrStatus.active
        ? StatusPillVariant.active
        : StatusPillVariant.pending;

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
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                Icons.directions_car_outlined,
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
                    '${vehicle.make} ${vehicle.model}',
                    style: AppTypography.bodyL.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    vehicle.plateNumber,
                    style: AppTypography.bodyM,
                  ),
                ],
              ),
            ),
            StatusPill(label: statusLabel, variant: statusVariant),
          ],
        ),
      ),
    );
  }
}
