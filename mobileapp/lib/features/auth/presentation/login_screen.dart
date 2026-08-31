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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _onLogin() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    debugPrint('Login tapped');
  }

  void _navigateToRegister() {
    context.push(AppRoutes.register);
  }

  void _navigateToForgotPassword() {
    context.push(AppRoutes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              const Center(child: AppLogo(size: AppLogoSize.small)),
              const SizedBox(height: AppSpacing.xxxl),
              Text('Welcome back', style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sign in to manage your vehicles',
                style: AppTypography.bodyM,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PhoneInputField(label: 'Phone number'),
                    SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: GestureDetector(
                  onTap: _navigateToForgotPassword,
                  child: Text(
                    'Forgot password?',
                    style: AppTypography.link,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Log In',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onLogin,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTypography.bodyM,
                  ),
                  GestureDetector(
                    onTap: _navigateToRegister,
                    child: Text('Register', style: AppTypography.link),
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
