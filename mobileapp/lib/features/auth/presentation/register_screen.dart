import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/phone_input_field.dart';
import '../../../shared/widgets/primary_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void _onCreateAccount(BuildContext context) {
    debugPrint('Create account tapped');
    context.go(AppRoutes.otp);
  }

  void _navigateToLogin(BuildContext context) {
    context.go(AppRoutes.login);
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
              const Center(child: AppLogo(size: AppLogoSize.small)),
              const SizedBox(height: AppSpacing.xxxl),
              Text('Create account', style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Register to protect your vehicle',
                style: AppTypography.bodyM,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    PhoneInputField(label: 'Phone number'),
                    SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Password',
                      hint: 'Create a password',
                      obscureText: true,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Create Account',
                onPressed: () => _onCreateAccount(context),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: AppTypography.bodyM),
                  GestureDetector(
                    onTap: () => _navigateToLogin(context),
                    child: Text('Log In', style: AppTypography.link),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
