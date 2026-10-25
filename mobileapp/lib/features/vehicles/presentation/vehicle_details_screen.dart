import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/enums.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/alert_list_item.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/plate_badge.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/thin_progress_bar.dart';
import '../../alerts/presentation/alert_labels.dart';
import '../../home/presentation/providers/garage_provider.dart';
import 'providers/vehicle_provider.dart';
import 'vehicle_protection.dart';

class VehicleDetailsScreen extends ConsumerWidget {
  const VehicleDetailsScreen({
    super.key,
    required this.id,
    this.justAdded = false,
  });

  final String id;
  final bool justAdded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vehicles = ref.watch(vehicleProvider);
    final orders = ref.watch(ordersProvider);
    final alerts = ref.watch(alertsProvider);
    final now = ref.watch(clockProvider);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.navVehicles, style: AppTypography.headingM),
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(AppIcons.caretLeft),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: l10n.actionMore,
            onSelected: (value) async {
              if (value == 'edit') {
                context.push(AppRoutes.vehicleEdit(id));
                return;
              }
              final confirmed = await ConfirmationDialog.show(
                context,
                title: l10n.vehicleDeleteTitle,
                message: l10n.vehicleDeleteBody,
                confirmLabel: l10n.vehicleDelete,
                cancelLabel: l10n.actionCancel,
                isDestructive: true,
              );
              if (confirmed != true || !context.mounted) return;
              await ref.read(vehicleProvider.notifier).deleteVehicle(id);
              refreshGarage(ref);
              if (context.mounted) context.pop();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(l10n.vehicleEdit)),
              PopupMenuItem(value: 'delete', child: Text(l10n.vehicleDelete)),
            ],
          ),
        ],
      ),
      body: vehicles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(onRetry: () => ref.invalidate(vehicleProvider)),
        data: (items) {
          final match = items.where((item) => item.id == id);
          if (match.isEmpty) {
            return ErrorState(message: l10n.vehicleNotFound);
          }
          final vehicle = match.first;
          final orderList = orders.value ?? const [];
          final view = protectionView(
            vehicle: vehicle,
            orders: orderList,
            now: now,
          );
          final related = [...(alerts.value ?? const [])]
              .where((alert) => alert.vehicleId == id)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final recentAlerts = related.take(5).toList();
          final renew = view.state == ProtectionState.expiring ||
              view.state == ProtectionState.expired;
          final statusColor = switch (view.state) {
            ProtectionState.active => AppColors.success,
            ProtectionState.expiring ||
            ProtectionState.paymentPending =>
              AppColors.warning,
            ProtectionState.expired => AppColors.error,
            _ => AppColors.textPrimary,
          };

          return ListView(
            padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
            children: [
              Text(vehicle.displayName, style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.sm),
              PlateBadge(plate: vehicle.plate),
              if (justAdded) ...[
                const SizedBox(height: AppSpacing.lg),
                InfoBanner(message: l10n.vehicleAddedBanner),
              ],
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _status(l10n, view.state),
                      style: AppTypography.headingM.copyWith(color: statusColor),
                    ),
                    if (view.daysLeft != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.homeDaysLeft(view.daysLeft!),
                        style: AppTypography.headingL.copyWith(color: statusColor),
                      ),
                    ],
                    if (view.until != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.homeValidUntil(formatAppDate(view.until!, locale)),
                        style: AppTypography.bodyM,
                      ),
                    ],
                    if (view.progress > 0) ...[
                      const SizedBox(height: AppSpacing.md),
                      ThinProgressBar(
                        value: view.progress,
                        color: statusColor,
                        track: AppColors.surfaceContainer,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: renew ? l10n.homeOrderNew : l10n.homeOrderSticker,
                onPressed: () => context.push(
                  '${AppRoutes.orderVehicle}?vehicleId=$id',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: l10n.vehicleViewQr,
                onPressed: () => context.push(AppRoutes.vehicleQr(id)),
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: l10n.vehicleAlerts),
              const SizedBox(height: AppSpacing.md),
              if (recentAlerts.isEmpty)
                Text(l10n.homeNoAlerts, style: AppTypography.bodyL)
              else
                for (final alert in recentAlerts) ...[
                  AlertListItem(
                    title: alertTitle(l10n, alert),
                    subtitle: vehicle.displayName,
                    timeLabel: alertTimeLabel(l10n, alert.createdAt, now),
                    unread: !alert.isRead,
                    onTap: () => context.push(AppRoutes.alert(alert.id)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              if (view.latestOrder != null) ...[
                const SizedBox(height: AppSpacing.lg),
                SectionHeader(title: l10n.vehicleOrders),
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  title: Text(
                    l10n.orderLabel(view.latestOrder!.number),
                    style: AppTypography.bodyL,
                  ),
                  trailing: const Icon(AppIcons.caretRight),
                  onTap: () => context.push(AppRoutes.order(view.latestOrder!.id)),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

String _status(AppLocalizations l10n, ProtectionState state) {
  return switch (state) {
    ProtectionState.noVehicle => l10n.homeAddFirst,
    ProtectionState.noSticker => l10n.homeNotProtected,
    ProtectionState.paymentPending => l10n.homeWaitingPayment,
    ProtectionState.inTransit => l10n.homeOnTheWay,
    ProtectionState.active => l10n.homeProtected,
    ProtectionState.expiring => l10n.homeExpiresSoon,
    ProtectionState.expired => l10n.homeNotProtectedNow,
  };
}
