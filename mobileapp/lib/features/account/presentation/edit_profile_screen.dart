import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_auth_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/city_select_field.dart';
import '../../../shared/widgets/primary_button.dart';
import 'providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late String? _selectedCity;
  bool _isDropdownFocused = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(profileProvider);
    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
    _selectedCity = user.city;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    ref.read(profileProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          city: _selectedCity,
        );
    setState(() => _isLoading = false);
    if (mounted) context.pop();
  }

  void _onAvatarTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo upload coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTypography.headingM),
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
              Center(
                child: GestureDetector(
                  onTap: _onAvatarTap,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: AppColors.accentSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user.initials,
                            style: AppTypography.headingL.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        end: 0,
                        bottom: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.accentSoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                    AppTextField(
                      label: 'Phone',
                      controller: _phoneController,
                      readOnly: true,
                      prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Phone changes require OTP verification',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
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
                label: 'Save Changes',
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
