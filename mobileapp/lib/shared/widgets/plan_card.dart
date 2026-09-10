import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'primary_button.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.features,
    required this.onSelect,
    this.isPopular = false,
    this.isCurrent = false,
  });

  final String name;
  final String price;
  final List<String> features;
  final VoidCallback onSelect;
  final bool isPopular;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: isPopular
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: isPopular ? AppShadows.button : AppShadows.card,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isPopular)
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'Most Popular',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.onSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (isPopular) const SizedBox(height: AppSpacing.md),
              Text(name, style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.sm),
              Text(
                price,
                style: AppTypography.headingL.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...features.map(
                (f) => Padding(
                  padding: const EdgeInsetsDirectional.only(
                    bottom: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(f, style: AppTypography.bodyM)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: isCurrent ? 'Current Plan' : 'Select',
                enabled: !isCurrent,
                onPressed: onSelect,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
