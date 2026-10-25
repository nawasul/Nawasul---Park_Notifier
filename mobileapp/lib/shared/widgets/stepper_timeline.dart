import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class TimelineStep {
  const TimelineStep({
    required this.label,
    required this.done,
    this.dateLabel,
  });

  final String label;
  final bool done;
  final String? dateLabel;
}

class StepperTimeline extends StatelessWidget {
  const StepperTimeline({super.key, required this.steps});

  final List<TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: steps[i].done ? AppColors.primary : AppColors.outlineVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (i != steps.length - 1)
                    Container(
                      width: 2,
                      height: 28,
                      color: AppColors.outlineVariant,
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(steps[i].label, style: AppTypography.bodyL),
                      if (steps[i].dateLabel != null)
                        Text(steps[i].dateLabel!, style: AppTypography.caption),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
