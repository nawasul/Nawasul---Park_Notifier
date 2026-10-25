import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/user.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/radio_option_list.dart';
import '../../../shared/widgets/toggle_setting_row.dart';
import '../../alerts/data/alert_repository.dart';
import '../../alerts/presentation/alert_labels.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../data/account_repository.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  var _sending = false;
  List<({String channel, String status})>? _result;

  Future<void> _save(Preferences next) async {
    if (!next.whatsappAlerts && !next.pushAlerts) {
      _note(AppLocalizations.of(context).accountOneChannel);
      return;
    }
    await ref.read(accountRepositoryProvider).updatePreferences(next);
    ref.invalidate(currentUserProvider);
  }

  Future<void> _test() async {
    if (_sending) return;
    setState(() => _sending = true);
    final l10n = AppLocalizations.of(context);
    final alert = await ref.read(alertRepositoryProvider).sendTest();
    ref.invalidate(alertsProvider);
    if (!mounted) return;
    setState(() {
      _sending = false;
      _result = [
        for (final delivery in alert.deliveries)
          (
            channel: alertChannelLabel(l10n, delivery.channel),
            status: alertDeliveryLabel(l10n, delivery.status),
          ),
      ];
    });
  }

  Future<void> _fix() async {
    final opened = await ref.read(notificationServiceProvider).openSystemSettings();
    if (!opened && mounted) {
      _note(AppLocalizations.of(context).accountSettingsPhone);
    }
  }

  void _note(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final allowed = ref.watch(notificationsAllowedProvider).value;
    final loud = ref.watch(loudAlertsReadyProvider).value ?? false;

    return AppScaffold(
      title: l10n.accountNotifications,
      body: user.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(
          onRetry: () => ref.invalidate(currentUserProvider),
        ),
        data: (me) {
          final prefs = me.preferences;
          final loudLabel = prefs.alarmStyle == AlarmStyle.loud
              ? l10n.accountAlarmLoud
              : l10n.accountAlarmNormal;
          return ListView(
            children: [
              ToggleSettingRow(
                label: l10n.accountWhatsapp,
                value: prefs.whatsappAlerts,
                onChanged: (value) => _save(prefs.copyWith(whatsappAlerts: value)),
              ),
              ToggleSettingRow(
                label: l10n.accountPush,
                value: prefs.pushAlerts,
                onChanged: (value) => _save(prefs.copyWith(pushAlerts: value)),
              ),
              Text(
                l10n.accountOneChannel,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              RadioOptionList(
                label: l10n.accountAlarmStyle,
                options: [l10n.accountAlarmLoud, l10n.accountAlarmNormal],
                selectedValue: loudLabel,
                onChanged: (value) {
                  final style = value == l10n.accountAlarmNormal
                      ? AlarmStyle.normal
                      : AlarmStyle.loud;
                  _save(prefs.copyWith(alarmStyle: style));
                },
              ),
              ToggleSettingRow(
                key: const Key('pref-marketing'),
                label: l10n.accountMarketing,
                value: prefs.marketing,
                showDivider: false,
                onChanged: (value) => _save(prefs.copyWith(marketing: value)),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: l10n.accountTestAlert,
                isLoading: _sending,
                onPressed: _test,
              ),
              if (_result != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(l10n.alertTestTitle, style: AppTypography.headingM),
                for (final row in _result!)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: AppSpacing.sm),
                    child: Text(
                      '${row.channel}: ${row.status}',
                      style: AppTypography.bodyL,
                    ),
                  ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.accountChecklist, style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.sm),
              _CheckRow(
                title: l10n.accountNotifAllowed,
                status: allowed == true ? l10n.accountStatusOn : l10n.accountStatusOff,
                fixLabel: l10n.accountFix,
                onFix: _fix,
              ),
              _CheckRow(
                title: l10n.accountLoudReady,
                status: loud ? l10n.accountStatusOn : l10n.accountStatusOff,
                fixLabel: l10n.accountFix,
                onFix: _fix,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.alertDisclaimer,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.title,
    required this.status,
    required this.fixLabel,
    required this.onFix,
  });

  final String title;
  final String status;
  final String fixLabel;
  final VoidCallback onFix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyL),
                Text(
                  status,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onFix, child: Text(fixLabel)),
        ],
      ),
    );
  }
}

final loudAlertsReadyProvider = FutureProvider<bool>((ref) {
  return ref.watch(notificationServiceProvider).loudAlertsReady();
});
