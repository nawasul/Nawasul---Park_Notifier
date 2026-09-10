import 'package:flutter/material.dart';

import '../../../../core/mock/mock_alerts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class DashboardAlertTile extends StatefulWidget {
  const DashboardAlertTile({
    super.key,
    required this.alert,
    this.onTap,
  });

  final Alert alert;
  final VoidCallback? onTap;

  @override
  State<DashboardAlertTile> createState() => _DashboardAlertTileState();
}

class _DashboardAlertTileState extends State<DashboardAlertTile> {
  bool _isPressed = false;

  String get _relativeTime {
    final diff = DateTime.now().difference(widget.alert.timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkElevated,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.onPrimary.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.primary.withValues(alpha: 0.85),
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.alert.reason,
                      style: AppTypography.bodyM.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textOnDark,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.alert.vehicleName,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textOnDarkSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _relativeTime,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textOnDarkSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
