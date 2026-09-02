import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/toggle_setting_row.dart';
import 'providers/settings_provider.dart';

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPreferencesProvider);
    final notifier = ref.read(notificationPreferencesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notification Preferences', style: AppTypography.headingM),
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
              horizontal: AppSpacing.lg,
            ),
            decoration: AppTheme.surfaceCardDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ToggleSettingRow(
                  label: 'Push Notifications',
                  subtitle: 'Receive instant alerts on your device',
                  value: prefs.pushNotifications,
                  onChanged: notifier.setPushNotifications,
                ),
                ToggleSettingRow(
                  label: 'SMS Alerts',
                  subtitle: 'Get text messages for important events',
                  value: prefs.smsAlerts,
                  onChanged: notifier.setSmsAlerts,
                ),
                ToggleSettingRow(
                  label: 'Automated Call Alerts',
                  subtitle: 'Receive a call when someone scans your QR',
                  value: prefs.automatedCallAlerts,
                  onChanged: notifier.setAutomatedCallAlerts,
                ),
                ToggleSettingRow(
                  label: 'Email Updates',
                  subtitle: 'Product news and account updates via email',
                  value: prefs.emailUpdates,
                  onChanged: notifier.setEmailUpdates,
                  showDivider: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
