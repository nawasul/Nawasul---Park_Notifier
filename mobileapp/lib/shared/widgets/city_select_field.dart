import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: isFocused ? AppShadows.inputFocused : AppShadows.input,
      ),
      child: Focus(
        onFocusChange: onFocusChange,
        child: InputDecorator(
          decoration: const InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
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
      ),
    );
  }
}
