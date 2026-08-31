import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_auth_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/otp_input_field.dart';
import '../../../shared/widgets/phone_input_field.dart';
import '../../../shared/widgets/primary_button.dart';

enum ForgotPasswordStep { phone, otp, reset }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordStep _step = ForgotPasswordStep.phone;
  bool _isLoading = false;

  int get _stepIndex {
    switch (_step) {
      case ForgotPasswordStep.phone:
        return 0;
      case ForgotPasswordStep.otp:
        return 1;
      case ForgotPasswordStep.reset:
        return 2;
    }
  }

  void _onBack() {
    switch (_step) {
      case ForgotPasswordStep.phone:
        context.pop();
      case ForgotPasswordStep.otp:
        setState(() => _step = ForgotPasswordStep.phone);
      case ForgotPasswordStep.reset:
        setState(() => _step = ForgotPasswordStep.otp);
    }
  }

  Future<void> _onPrimaryAction() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (_step) {
      case ForgotPasswordStep.phone:
        debugPrint('Send code tapped');
        setState(() => _step = ForgotPasswordStep.otp);
      case ForgotPasswordStep.otp:
        debugPrint('Verify OTP tapped');
        setState(() => _step = ForgotPasswordStep.reset);
      case ForgotPasswordStep.reset:
        debugPrint('Reset password tapped');
        context.pop();
    }
  }

  String get _heading {
    switch (_step) {
      case ForgotPasswordStep.phone:
        return 'Forgot password?';
      case ForgotPasswordStep.otp:
        return 'Verify your number';
      case ForgotPasswordStep.reset:
        return 'Reset password';
    }
  }

  String get _subheading {
    switch (_step) {
      case ForgotPasswordStep.phone:
        return 'Enter your phone number and we\'ll send you a verification code.';
      case ForgotPasswordStep.otp:
        return 'Code sent to ${MockAuthData.primaryUser.maskedPhone}';
      case ForgotPasswordStep.reset:
        return 'Create a new password for your account.';
    }
  }

  String get _buttonLabel {
    switch (_step) {
      case ForgotPasswordStep.phone:
        return 'Send Code';
      case ForgotPasswordStep.otp:
        return 'Verify';
      case ForgotPasswordStep.reset:
        return 'Reset Password';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: _onBack,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              _StepIndicator(currentStep: _stepIndex, totalSteps: 3),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Step ${_stepIndex + 1} of 3',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(_heading, style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.md),
              Text(_subheading, style: AppTypography.bodyM),
              const SizedBox(height: AppSpacing.xxxl),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStepContent(),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              PrimaryButton(
                label: _buttonLabel,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onPrimaryAction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case ForgotPasswordStep.phone:
        return Container(
          key: const ValueKey('phone'),
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          decoration: AppTheme.surfaceCardDecoration,
          child: const PhoneInputField(label: 'Phone number'),
        );
      case ForgotPasswordStep.otp:
        return Column(
          key: const ValueKey('otp'),
          children: [
            const OtpInputField(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Resend code in 00:45',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case ForgotPasswordStep.reset:
        return Container(
          key: const ValueKey('reset'),
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          decoration: AppTheme.surfaceCardDecoration,
          child: const Column(
            children: [
              AppTextField(
                label: 'New Password',
                hint: 'Enter new password',
                obscureText: true,
              ),
              SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Confirm Password',
                hint: 'Re-enter new password',
                obscureText: true,
              ),
            ],
          ),
        );
    }
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 4,
            margin: EdgeInsetsDirectional.only(
              end: index < totalSteps - 1 ? AppSpacing.sm : 0,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.borderSubtle,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: index == currentStep ? AppShadows.inputFocused : null,
            ),
          ),
        );
      }),
    );
  }
}
