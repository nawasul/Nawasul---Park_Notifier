import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_auth_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  late final TextEditingController _nameController;
  late String? _selectedCity;
  bool _isDropdownFocused = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: MockAuthData.primaryUser.name,
    );
    _selectedCity = MockAuthData.primaryUser.city;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onFinishSetup() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    debugPrint('Finish setup tapped — city: $_selectedCity');
    if (mounted) context.go(AppRoutes.home);
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
              Text('Complete your profile', style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Just a few more details to get started',
                style: AppTypography.bodyM,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'City / Region',
                      style: AppTypography.bodyM.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _CitySelectField(
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
                label: 'Finish Setup',
                enabled: _selectedCity != null,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onFinishSetup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CitySelectField extends StatelessWidget {
  const _CitySelectField({
    required this.cities,
    required this.selectedCity,
    required this.isFocused,
    required this.onFocusChange,
    required this.onChanged,
  });

  final List<String> cities;
  final String? selectedCity;
  final bool isFocused;
  final ValueChanged<bool> onFocusChange;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: isFocused ? AppShadows.inputFocused : AppShadows.input,
      ),
      child: Focus(
        onFocusChange: onFocusChange,
        child: InputDecorator(
          decoration: const InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCity,
              isExpanded: true,
              isDense: true,
              hint: Text(
                'Select your city',
                style: AppTypography.bodyM.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              style: AppTypography.bodyL,
              borderRadius: BorderRadius.circular(AppRadius.md),
              items: cities
                  .map(
                    (city) => DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
