import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'app_loader.dart';

class DestructiveButton extends StatelessWidget {
  const DestructiveButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && !isLoading && onPressed != null;

    return FilledButton(
      onPressed: interactive ? onPressed : null,
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.error.withValues(alpha: 0.38),
        disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.38),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: AppTypography.button,
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.error.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.errorDark;
          }
          return AppColors.error;
        }),
      ),
      child: isLoading
            ? const AppLoader(size: 24, color: AppColors.onPrimary)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(label),
              ],
            ),
    );
  }
}
