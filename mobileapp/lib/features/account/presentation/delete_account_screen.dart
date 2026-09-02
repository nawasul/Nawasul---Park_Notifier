import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/destructive_button.dart';
import '../../../shared/widgets/radio_option_list.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  static const _reasons = [
    'Not using the app',
    'Privacy concerns',
    'Found a better alternative',
    'Other',
  ];

  String? _selectedReason;
  bool _isLoading = false;

  Future<void> _onDelete() async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete your account?',
      message:
          'This action is permanent and cannot be undone. All your data, '
          'vehicles, and subscription will be permanently removed.',
      confirmLabel: 'Delete Account',
      cancelLabel: 'Keep Account',
      isDestructive: true,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted successfully')),
    );
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Delete Account', style: AppTypography.headingM),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.errorBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.error,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Delete your account?',
                      style: AppTypography.headingM.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'This action is permanent. The following will be removed:',
                      style: AppTypography.bodyM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _BulletItem(text: 'Your profile and personal data'),
                    const _BulletItem(text: 'All registered vehicles'),
                    const _BulletItem(text: 'Active subscription and billing'),
                    const _BulletItem(text: 'QR codes and alert history'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: RadioOptionList(
                  label: 'Reason for leaving (optional)',
                  options: _reasons,
                  selectedValue: _selectedReason,
                  onChanged: (value) => setState(() => _selectedReason = value),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              DestructiveButton(
                label: 'Delete Account',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(color: AppColors.error)),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyM.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
