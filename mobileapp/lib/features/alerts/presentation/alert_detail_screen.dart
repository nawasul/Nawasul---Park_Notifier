import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/alert_item.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import '../data/alert_repository.dart';
import 'alert_groups.dart';
import 'alert_labels.dart';

class AlertDetailsScreen extends ConsumerStatefulWidget {
  const AlertDetailsScreen({super.key, required this.alertId});

  final String alertId;

  @override
  ConsumerState<AlertDetailsScreen> createState() => _AlertDetailsScreenState();
}

class _AlertDetailsScreenState extends ConsumerState<AlertDetailsScreen> {
  var _marked = false;
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final alerts = ref.watch(alertsProvider);
    final now = ref.watch(clockProvider);
    final stopped = ref.watch(stoppedAlarmsProvider);
    final vehicles = ref.watch(vehicleProvider).value ?? const <Vehicle>[];

    return AppScaffold(
      title: l10n.navAlerts,
      body: alerts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(onRetry: () => ref.invalidate(alertsProvider)),
        data: (items) {
          AlertItem? alert;
          for (final item in items) {
            if (item.id == widget.alertId) alert = item;
          }
          if (alert == null) {
            return Center(
              child: Text(l10n.alertNotFound, style: AppTypography.bodyL),
            );
          }
          final current = alert;
          _scheduleRead(current);
          final vehicleName = _vehicleName(vehicles, current.vehicleId);
          final canStop = showStopAlarm(current, now, stopped);
          return ListView(
            children: [
              Text(alertTitle(l10n, current), style: AppTypography.headingL),
              if (vehicleName.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  vehicleName,
                  style: AppTypography.bodyL.copyWith(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${formatAppDate(current.createdAt, locale)} · ${formatAppTime(current.createdAt, locale)}',
                style: AppTypography.bodyM,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  children: [
                    for (final delivery in current.deliveries)
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                alertChannelLabel(l10n, delivery.channel),
                                style: AppTypography.bodyL,
                              ),
                            ),
                            Text(
                              alertDeliveryLabel(l10n, delivery.status),
                              style: AppTypography.bodyM,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (canStop) ...[
                SecondaryButton(
                  label: l10n.alertStopAlarm,
                  enabled: !_busy,
                  onPressed: () => _stop(current.id),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              PrimaryButton(
                label: l10n.alertComing,
                enabled: current.ackAt == null && !_busy,
                onPressed: () => _ack(current.id),
              ),
              if (current.ackAt != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.alertComingDone,
                  style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: _busy ? null : () => _report(l10n, current.id),
                child: Text(
                  l10n.alertSpam,
                  style: AppTypography.link.copyWith(
                    decoration: TextDecoration.none,
                    color: AppColors.error,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
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

  void _scheduleRead(AlertItem alert) {
    if (_marked || alert.isRead) return;
    _marked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await ref.read(alertRepositoryProvider).markRead(alert.id);
      if (mounted) ref.invalidate(alertsProvider);
    });
  }

  Future<void> _stop(String id) async {
    setState(() => _busy = true);
    await ref.read(notificationServiceProvider).stopAlarm(id);
    ref.read(stoppedAlarmsProvider.notifier).update((ids) => {...ids, id});
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _ack(String id) async {
    setState(() => _busy = true);
    await ref.read(alertRepositoryProvider).acknowledge(id);
    ref.invalidate(alertsProvider);
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _report(AppLocalizations l10n, String id) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: l10n.alertSpamTitle,
      message: l10n.alertSpamBody,
      confirmLabel: l10n.alertSpamConfirm,
      cancelLabel: l10n.actionCancel,
      isDestructive: true,
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    await ref.read(alertRepositoryProvider).report(id);
    ref.invalidate(alertsProvider);
    if (mounted) context.pop();
  }
}

String _vehicleName(List<Vehicle> vehicles, String? id) {
  if (id == null) return '';
  for (final vehicle in vehicles) {
    if (vehicle.id == id) return vehicle.displayName;
  }
  return '';
}
