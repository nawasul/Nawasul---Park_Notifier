import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'app_loader.dart';

class PrimaryButton extends StatefulWidget {
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
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  bool get _isInteractive =>
      widget.enabled && !widget.isLoading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final scale = reduce || !_isPressed ? 1.0 : 0.97;

    return GestureDetector(
      onTapDown: _isInteractive ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: _isInteractive ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: _isInteractive ? () => setState(() => _isPressed = false) : null,
      onTap: _isInteractive ? widget.onPressed : null,
      child: AnimatedScale(
        scale: scale,
        duration: reduce ? Duration.zero : const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1 : 0.5,
          duration: reduce ? Duration.zero : const Duration(milliseconds: 200),
          child: Container(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: widget.enabled ? AppGradients.primary : null,
              color: widget.enabled ? null : AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: widget.enabled ? AppShadows.button : null,
            ),
            child: widget.isLoading
                ? const AppLoader(size: 24, color: AppColors.onPrimary)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.leadingIcon != null) ...[
                        Icon(widget.leadingIcon, color: AppColors.onPrimary, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(widget.label, style: AppTypography.button),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
