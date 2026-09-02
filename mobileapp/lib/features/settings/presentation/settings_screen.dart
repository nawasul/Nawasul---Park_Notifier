import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/profile_menu_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTypography.headingM),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.sm,
            ),
            decoration: AppTheme.surfaceCardDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfileMenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notification Preferences',
                  onTap: () => context.push(AppRoutes.notificationPreferences),
                ),
                ProfileMenuItem(
                  icon: Icons.language_outlined,
                  label: 'Language & Region',
                  showDivider: false,
                  onTap: () => context.push(AppRoutes.languageRegion),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
