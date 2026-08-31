import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/language_option_card.dart';
import '../../../shared/widgets/primary_button.dart';

enum AppLanguage { english, arabic }

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  AppLanguage? _selectedLanguage;

  void _onContinue() {
    if (_selectedLanguage == null) return;
    debugPrint('Selected language: $_selectedLanguage');
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'Choose your language',
                style: AppTypography.headingL,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'اختر لغتك',
                style: AppTypography.arabicHeading('اختر لغتك'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Expanded(
                flex: 3,
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 400),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 16,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        LanguageOptionCard(
                          flag: '🇬🇧',
                          label: 'English',
                          isSelected: _selectedLanguage == AppLanguage.english,
                          onTap: () => setState(
                            () => _selectedLanguage = AppLanguage.english,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LanguageOptionCard(
                          flag: '🇸🇦',
                          label: 'العربية',
                          isSelected: _selectedLanguage == AppLanguage.arabic,
                          onTap: () => setState(
                            () => _selectedLanguage = AppLanguage.arabic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                label: 'Continue',
                enabled: _selectedLanguage != null,
                onPressed: _onContinue,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
