import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        backgroundColor: AppColors.secondaryContainer,
        foregroundColor: AppColors.primary,
        disabledBackgroundColor:
            AppColors.secondaryContainer.withValues(alpha: 0.5),
        disabledForegroundColor: AppColors.primary.withValues(alpha: 0.38),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: AppTypography.button.copyWith(color: AppColors.primary),
      ),
      child: Text(label),
    );
  }
}
