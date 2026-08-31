import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_auth_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/icon_badge.dart';
import '../../../shared/widgets/otp_input_field.dart';
import '../../../shared/widgets/primary_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _isLoading = false;

  Future<void> _onVerify() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    debugPrint('Verify OTP tapped');
    context.go(AppRoutes.accountSetup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
              const SizedBox(height: AppSpacing.xl),
              const Center(
                child: IconBadge(
                  icon: Icons.verified_user_outlined,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Verify your number',
                style: AppTypography.headingL,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Code sent to ${MockAuthData.primaryUser.maskedPhone}',
                style: AppTypography.bodyM,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const OtpInputField(
                onCompleted: _onOtpCompleted,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Resend code in 00:45',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              PrimaryButton(
                label: 'Verify',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onVerify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _onOtpCompleted(String code) {
    debugPrint('OTP entered: $code');
  }
}
