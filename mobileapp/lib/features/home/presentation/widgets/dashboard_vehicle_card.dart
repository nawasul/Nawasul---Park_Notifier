import 'package:flutter/material.dart';

import '../../../../core/mock/mock_vehicles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Dashboard-only vehicle card with fixed dimensions for dark-background layout.
class DashboardVehicleCard extends StatefulWidget {
  const DashboardVehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
  });

  final Vehicle vehicle;
  final VoidCallback? onTap;

  static const double cardHeight = 88;

  @override
  State<DashboardVehicleCard> createState() => _DashboardVehicleCardState();
}

class _DashboardVehicleCardState extends State<DashboardVehicleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.vehicle.qrStatus == QrStatus.active;
    final statusLabel = isActive ? 'QR Active' : 'Sticker Pending';

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: SizedBox(
          height: DashboardVehicleCard.cardHeight,
          child: Container(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.vehicle.make} ${widget.vehicle.model}',
                        style: AppTypography.bodyL.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.vehicle.plateNumber,
                              style: AppTypography.bodyM.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _VehicleStatusBadge(
                            label: statusLabel,
                            isActive: isActive,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleStatusBadge extends StatelessWidget {
  const _VehicleStatusBadge({
    required this.label,
    required this.isActive,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bg = isActive ? AppColors.successContainer : AppColors.warningContainer;
    final fg = isActive ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
        maxLines: 1,
      ),
    );
  }
}
