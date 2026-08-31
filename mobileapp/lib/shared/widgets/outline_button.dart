import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';

class OutlineButton extends StatefulWidget {
  const OutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  bool _isPressed = false;

  bool get _isInteractive => widget.enabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isInteractive ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: _isInteractive ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: _isInteractive ? () => setState(() => _isPressed = false) : null,
      onTap: _isInteractive ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: AppTypography.button.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}
