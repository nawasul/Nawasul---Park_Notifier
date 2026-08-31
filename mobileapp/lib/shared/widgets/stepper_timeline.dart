import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class StepperTimeline extends StatelessWidget {
  const StepperTimeline({
    super.key,
    required this.steps,
    required this.currentStepIndex,
  });

  final List<String> steps;
  final int currentStepIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentStepIndex;
        final isActive = index == currentStepIndex;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? AppColors.primary
                        : AppColors.borderSubtle,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle,
                    color: isCompleted || isActive
                        ? AppColors.surface
                        : AppColors.textMuted,
                    size: isCompleted ? 18 : 8,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.borderSubtle,
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.lg),
                child: Text(
                  steps[index],
                  style: AppTypography.bodyL.copyWith(
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? AppColors.primary
                        : isCompleted
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
