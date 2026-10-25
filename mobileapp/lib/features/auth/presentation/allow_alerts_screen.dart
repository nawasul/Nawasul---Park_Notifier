import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../services/notification_prompt.dart';
import 'providers/session_provider.dart';

class AllowAlertsScreen extends ConsumerStatefulWidget {
  const AllowAlertsScreen({super.key});

  @override
  ConsumerState<AllowAlertsScreen> createState() => _AllowAlertsScreenState();
}

class _AllowAlertsScreenState extends ConsumerState<AllowAlertsScreen> {
  var _loudStep = false;
  var _loading = false;

  Future<void> _allow() async {
    if (_loading) return;
    setState(() => _loading = true);
    final granted = await ref.read(notificationServiceProvider).requestPermission();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_allowed', granted);
    if (!mounted) return;
    if (showLoudAlertStep(isWeb: kIsWeb, platform: defaultTargetPlatform)) {
      setState(() {
        _loudStep = true;
        _loading = false;
      });
      return;
    }
    await _finish();
  }

  Future<void> _later() async {
    if (_loading) return;
    setState(() => _loading = true);
    await _finish();
  }

  Future<void> _finish() async {
    await ref.read(sessionProvider.notifier).completeAlertsPrompt();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _loudStep ? l10n.alertsAndroidTitle : l10n.alertsTitle,
                style: AppTypography.headingL,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _loudStep ? l10n.alertsAndroidBody : l10n.alertsBody,
                style: AppTypography.bodyL.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              if (_loudStep)
                PrimaryButton(
                  label: l10n.actionContinue,
                  isLoading: _loading,
                  onPressed: _finish,
                )
              else ...[
                PrimaryButton(
                  label: l10n.alertsAllow,
                  isLoading: _loading,
                  onPressed: _allow,
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: l10n.alertsLater,
                  enabled: !_loading,
                  onPressed: _later,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
