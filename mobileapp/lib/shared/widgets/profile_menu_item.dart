import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final iconColor = isDestructive ? AppColors.error : AppColors.primary;
    final labelColor = isDestructive ? AppColors.error : AppColors.textPrimary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDestructive ? AppColors.errorBg : AppColors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyL.copyWith(color: labelColor),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDestructive ? AppColors.error : AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.borderSubtle),
      ],
    );
  }
}
