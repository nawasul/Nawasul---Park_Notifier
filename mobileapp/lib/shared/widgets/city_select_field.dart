import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class CitySelectField extends StatelessWidget {
  const CitySelectField({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.isFocused,
    required this.onFocusChange,
    required this.onChanged,
    this.hint = 'Select your city',
  });

  final List<String> cities;
  final String? selectedCity;
  final bool isFocused;
  final ValueChanged<bool> onFocusChange;
  final ValueChanged<String?> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textMuted,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(
              color: isFocused ? AppColors.primary : AppColors.outline,
              width: isFocused ? 2 : 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(
              color: AppColors.outline,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedCity,
            isExpanded: true,
            isDense: true,
            hint: Text(
              hint,
              style: AppTypography.bodyM.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            style: AppTypography.bodyL,
            borderRadius: BorderRadius.circular(AppRadius.md),
            items: cities
                .map(
                  (city) => DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
