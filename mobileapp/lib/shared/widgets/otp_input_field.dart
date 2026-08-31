import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    this.onCompleted,
    this.onChanged,
    this.hasError = false,
    this.length = 6,
  });

  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;
  final int length;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  PinTheme _buildPinTheme({bool isFocused = false, bool hasError = false}) {
    final borderColor = hasError
        ? AppColors.error
        : isFocused
            ? AppColors.primary
            : AppColors.borderSubtle;

    return PinTheme(
      width: AppSpacing.otpBoxSize,
      height: AppSpacing.otpBoxSize + 8,
      textStyle: AppTypography.headingM.copyWith(fontSize: 22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: borderColor,
          width: isFocused || hasError ? 2 : 1,
        ),
        boxShadow: isFocused ? AppShadows.inputFocused : AppShadows.input,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = _buildPinTheme();
    final focusedTheme = _buildPinTheme(isFocused: true);
    final errorTheme = _buildPinTheme(hasError: true);

    return Pinput(
      length: widget.length,
      controller: _controller,
      focusNode: _focusNode,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: focusedTheme,
      errorPinTheme: errorTheme,
      submittedPinTheme: defaultTheme,
      separatorBuilder: (_) => const SizedBox(width: AppSpacing.md),
      onChanged: widget.onChanged,
      onCompleted: widget.onCompleted,
      forceErrorState: widget.hasError,
      cursor: Container(
        width: 2,
        height: 28,
        color: AppColors.primary,
      ),
    );
  }
}
