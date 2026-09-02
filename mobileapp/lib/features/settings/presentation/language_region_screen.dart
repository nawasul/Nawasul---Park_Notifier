import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_auth_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/city_select_field.dart';
import '../../../shared/widgets/language_option_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../language/presentation/language_selection_screen.dart';
import 'providers/settings_provider.dart';

class LanguageRegionScreen extends ConsumerStatefulWidget {
  const LanguageRegionScreen({super.key});

  @override
  ConsumerState<LanguageRegionScreen> createState() =>
      _LanguageRegionScreenState();
}

class _LanguageRegionScreenState extends ConsumerState<LanguageRegionScreen> {
  late AppLanguage _selectedLanguage;
  late String? _selectedCity;
  bool _isDropdownFocused = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = ref.read(appLanguageProvider);
    _selectedCity = MockAuthData.primaryUser.city;
  }

  Future<void> _onSave() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    ref.read(appLanguageProvider.notifier).setLanguage(_selectedLanguage);
    setState(() => _isLoading = false);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Language & Region', style: AppTypography.headingM),
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
              Text(
                'Language',
                style: AppTypography.bodyM.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LanguageOptionCard(
                flag: '🇬🇧',
                label: 'English',
                isSelected: _selectedLanguage == AppLanguage.english,
                onTap: () => setState(
                  () => _selectedLanguage = AppLanguage.english,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LanguageOptionCard(
                flag: '🇸🇦',
                label: 'العربية',
                isSelected: _selectedLanguage == AppLanguage.arabic,
                onTap: () => setState(
                  () => _selectedLanguage = AppLanguage.arabic,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Region / City',
                      style: AppTypography.bodyM.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    CitySelectField(
                      cities: MockAuthData.saudiCities,
                      selectedCity: _selectedCity,
                      isFocused: _isDropdownFocused,
                      onFocusChange: (focused) {
                        setState(() => _isDropdownFocused = focused);
                      },
                      onChanged: (city) => setState(() => _selectedCity = city),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              PrimaryButton(
                label: 'Save',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
