import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'status_pill.dart';

class ValidityOptionCard extends StatelessWidget {
  const ValidityOptionCard({
    super.key,
    required this.monthsLabel,
    required this.priceLabel,
    required this.selected,
    required this.onTap,
    this.bestValueLabel,
  });

  final String monthsLabel;
  final String priceLabel;
  final bool selected;
  final VoidCallback onTap;
  final String? bestValueLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(monthsLabel, style: AppTypography.headingM),
                    const SizedBox(height: AppSpacing.xs),
                    Text(priceLabel, style: AppTypography.bodyL),
                  ],
                ),
              ),
              if (bestValueLabel != null)
                StatusPill(
                  label: bestValueLabel!,
                  variant: StatusPillVariant.active,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
