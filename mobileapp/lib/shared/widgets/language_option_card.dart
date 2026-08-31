import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class LanguageOptionCard extends StatelessWidget {
  const LanguageOptionCard({
    super.key,
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surface : AppColors.accentSoft,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                flag,
                style: AppTypography.headingL.copyWith(fontSize: 28),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyL.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 17,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const _SelectedCheckmark(),
          ],
        ),
      ),
    );
  }
}

class _SelectedCheckmark extends StatelessWidget {
  const _SelectedCheckmark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_rounded,
        color: AppColors.surface,
        size: 18,
      ),
    );
  }
}
