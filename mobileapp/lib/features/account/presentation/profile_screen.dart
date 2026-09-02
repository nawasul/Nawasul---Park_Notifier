import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/profile_menu_item.dart';
import 'providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _onLogout(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Log out?',
      message: 'Are you sure you want to log out of your account?',
      confirmLabel: 'Log Out',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    final memberSince = DateFormat('MMMM yyyy').format(user.memberSince);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Account', style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.accentSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user.initials,
                          style: AppTypography.headingM.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(user.name, style: AppTypography.headingM),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      user.phone,
                      style: AppTypography.bodyM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Member since $memberSince',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                decoration: AppTheme.surfaceCardDecoration,
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                      onTap: () => context.push(AppRoutes.profileEdit),
                    ),
                    ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                    ProfileMenuItem(
                      icon: Icons.card_membership_outlined,
                      label: 'Subscription Plans',
                      onTap: () => context.push(AppRoutes.subscriptionPlans),
                    ),
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      label: 'Help & FAQ',
                      onTap: () => context.push(AppRoutes.helpFaq),
                    ),
                    ProfileMenuItem(
                      icon: Icons.support_agent_outlined,
                      label: 'Contact Support',
                      onTap: () => context.push(AppRoutes.contactSupport),
                    ),
                    ProfileMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () => context.push(AppRoutes.privacyPolicy),
                    ),
                    ProfileMenuItem(
                      icon: Icons.description_outlined,
                      label: 'Terms & Conditions',
                      onTap: () => context.push(AppRoutes.termsConditions),
                    ),
                    ProfileMenuItem(
                      icon: Icons.delete_outline,
                      label: 'Delete Account',
                      isDestructive: true,
                      onTap: () => context.push(AppRoutes.deleteAccount),
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      label: 'Logout',
                      isDestructive: true,
                      showDivider: false,
                      onTap: () => _onLogout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
