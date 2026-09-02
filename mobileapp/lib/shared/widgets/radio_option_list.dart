import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class RadioOptionList extends StatelessWidget {
  const RadioOptionList({
    super.key,
    this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  final String? label;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.bodyM.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () => onChanged(option),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: selectedValue == option
                      ? AppColors.accentSoft
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: selectedValue == option
                        ? AppColors.primary
                        : AppColors.borderSubtle,
                    width: selectedValue == option ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedValue == option
                              ? AppColors.primary
                              : AppColors.textMuted,
                          width: 2,
                        ),
                        color: selectedValue == option
                            ? AppColors.primary
                            : AppColors.surface,
                      ),
                      child: selectedValue == option
                          ? const Icon(
                              Icons.circle,
                              size: 10,
                              color: AppColors.surface,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(option, style: AppTypography.bodyL),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
