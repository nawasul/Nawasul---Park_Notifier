import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/validators.dart';
import 'app_text_field.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.dialCode = PhoneValidator.dialCode,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final String dialCode;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppTextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [PhoneDigitsFormatter()],
        errorText: errorText,
        onChanged: onChanged,
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.md),
          child: Center(
            widthFactor: 1,
            child: Text(
              dialCode,
              style: AppTypography.bodyL.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneDigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > 10 ? digits.substring(0, 10) : digits;
    return TextEditingValue(
      text: clipped,
      selection: TextSelection.collapsed(offset: clipped.length),
    );
  }
}
