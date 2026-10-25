import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'app_loader.dart';

class DestructiveButton extends StatefulWidget {
  const DestructiveButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.enabled = true,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;
  final bool enabled;
  final bool expand;

  @override
  State<DestructiveButton> createState() => _DestructiveButtonState();
}

class _DestructiveButtonState extends State<DestructiveButton> {
  bool _isPressed = false;

  bool get _isInteractive =>
      widget.enabled && !widget.isLoading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isInteractive ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: _isInteractive ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: _isInteractive ? () => setState(() => _isPressed = false) : null,
      onTap: _isInteractive ? widget.onPressed : null,
      child: AnimatedScale(
        scale: MediaQuery.disableAnimationsOf(context) || !_isPressed ? 1.0 : 0.97,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: widget.expand ? double.infinity : null,
            height: AppSpacing.buttonHeight,
            padding: widget.expand
                ? null
                : const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: _isPressed ? AppColors.errorDark : AppColors.error,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: widget.isLoading
                ? const Center(
                    child: AppLoader(size: 24, color: AppColors.surface),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                    children: [
                      if (widget.leadingIcon != null) ...[
                        Icon(
                          widget.leadingIcon,
                          color: AppColors.surface,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      if (widget.expand)
                        Flexible(
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.button,
                          ),
                        )
                      else
                        Text(widget.label, style: AppTypography.button),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
