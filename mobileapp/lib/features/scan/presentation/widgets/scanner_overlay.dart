import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final frameSize = (size.width * 0.68).clamp(200.0, 280.0);
        final left = (size.width - frameSize) / 2;
        final top = (size.height - frameSize) / 2 - 40;

        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _ScannerMaskPainter(
                frameRect: Rect.fromLTWH(left, top, frameSize, frameSize),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: frameSize,
              height: frameSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.onPrimary.withValues(alpha: 0.75),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScannerMaskPainter extends CustomPainter {
  _ScannerMaskPainter({required this.frameRect});

  final Rect frameRect;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final fullRect = Offset.zero & size;
    final path = Path()
      ..addRect(fullRect)
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerMaskPainter oldDelegate) {
    return oldDelegate.frameRect != frameRect;
  }
}

class ScannerPermissionView extends StatelessWidget {
  const ScannerPermissionView({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brandDark,
      padding: const EdgeInsetsDirectional.all(AppSpacing.xl),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner_rounded,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.9),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.headingM.copyWith(
                color: AppColors.textOnDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyM.copyWith(
                color: AppColors.textOnDarkSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                ),
                child: Text(actionLabel),
              ),
            ),
            if (secondaryActionLabel != null && onSecondaryAction != null) ...[
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onSecondaryAction,
                child: Text(
                  secondaryActionLabel!,
                  style: AppTypography.link.copyWith(
                    color: AppColors.textOnDarkSecondary,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
