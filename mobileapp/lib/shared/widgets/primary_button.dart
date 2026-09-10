import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'app_loader.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: interactive ? AppShadows.button : null,
      ),
      child: FilledButton(
        onPressed: interactive ? onPressed : null,
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTypography.button,
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
      ),
    );
  }
}
