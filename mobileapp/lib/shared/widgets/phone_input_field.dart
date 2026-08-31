import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    this.label,
    this.controller,
    this.hint = '5X XXX XXXX',
    this.onChanged,
    this.errorText,
  });

  final String? label;
  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.bodyM.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        _PhoneFieldBody(
          controller: controller,
          hint: hint,
          onChanged: onChanged,
          errorText: errorText,
        ),
      ],
    );
  }
}

class _PhoneFieldBody extends StatefulWidget {
  const _PhoneFieldBody({
    this.controller,
    required this.hint,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  State<_PhoneFieldBody> createState() => _PhoneFieldBodyState();
}

class _PhoneFieldBodyState extends State<_PhoneFieldBody> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final borderColor = hasError
        ? AppColors.error
        : _isFocused
            ? AppColors.primary
            : AppColors.borderSubtle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: _isFocused && !hasError
                ? AppShadows.inputFocused
                : AppShadows.input,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: borderColor,
                width: _isFocused || hasError ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColors.borderSubtle),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🇸🇦', style: AppTypography.bodyL),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '+966',
                        style: AppTypography.bodyL.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.phone,
                    style: AppTypography.bodyL,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: AppTypography.bodyM.copyWith(
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    onChanged: (value) {
                      widget.onChanged?.call('+966$value');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
            style: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
