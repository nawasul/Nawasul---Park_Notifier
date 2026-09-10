import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class QrTextResultSheet extends StatelessWidget {
  const QrTextResultSheet({
    super.key,
    required this.content,
    required this.onClose,
  });

  final String content;
  final VoidCallback onClose;

  static Future<void> show(
    BuildContext context, {
    required String content,
    required VoidCallback onClose,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.brandDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => QrTextResultSheet(
        content: content,
        onClose: () {
          Navigator.of(context).pop();
          onClose();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textOnDarkSecondary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'QR Code Detected',
              style: AppTypography.headingM.copyWith(
                color: AppColors.textOnDark,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceDarkElevated,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.onPrimary.withValues(alpha: 0.08),
                ),
              ),
              child: SelectableText(
                content,
                style: AppTypography.bodyM.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: content));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textOnDark,
                      side: BorderSide(
                        color: AppColors.onPrimary.withValues(alpha: 0.2),
                      ),
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: onClose,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
