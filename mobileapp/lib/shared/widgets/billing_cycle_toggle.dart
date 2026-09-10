import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum BillingCycle { monthly, yearly }

class BillingCycleToggle extends StatelessWidget {
  const BillingCycleToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final BillingCycle value;
  final ValueChanged<BillingCycle> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: 'Monthly',
              isSelected: value == BillingCycle.monthly,
              onTap: () => onChanged(BillingCycle.monthly),
            ),
          ),
          Expanded(
            child: _Segment(
              label: 'Yearly',
              isSelected: value == BillingCycle.yearly,
              onTap: () => onChanged(BillingCycle.yearly),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.bodyM.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
