import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../core/network/online.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/alert_list_item.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../shared/widgets/skeleton_box.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import '../data/alert_repository.dart';
import 'alert_groups.dart';
import 'alert_labels.dart';

class AlertsListScreen extends ConsumerWidget {
  const AlertsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final alerts = ref.watch(alertsProvider);
    final vehicles = ref.watch(vehicleProvider).value ?? const <Vehicle>[];
    final now = ref.watch(clockProvider);
    final locale = Localizations.localeOf(context).languageCode;

    return AppScaffold(
      title: l10n.navAlerts,
      padding: false,
      actions: [
        if (kDebugMode)
          IconButton(
            tooltip: l10n.debugSimulateAlert,
            onPressed: () => _simulate(context, ref, l10n),
            icon: const Icon(AppIcons.alarm),
          ),
      ],
      body: WithOfflineBanner(
        child: alerts.when(
          loading: () => const ListSkeleton(),
          error: (_, _) => ErrorState(onRetry: () => ref.invalidate(alertsProvider)),
        data: (items) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(onlineProvider);
              ref.invalidate(alertsProvider);
              await ref.read(alertsProvider.future);
            },
            child: items.isEmpty
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: constraints.maxHeight,
                            child: EmptyState(
                              icon: AppIcons.bell,
                              heading: l10n.homeNoAlerts,
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
                    children: [
                      for (final group in groupAlertsByDay(items)) ...[
                        Text(
                          alertDayLabel(
                            l10n,
                            group.day,
                            now,
                            formatAppDate(group.day, locale),
                          ),
                          style: AppTypography.headingM,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (final alert in group.items) ...[
                          AlertListItem(
                            key: Key('alert-${alert.id}'),
                            title: alertTitle(l10n, alert),
                            subtitle: _vehicleName(vehicles, alert.vehicleId),
                            timeLabel: alertTimeLabel(l10n, alert.createdAt, now),
                            unread: !alert.isRead,
                            icon: _icon(alert.type),
                            chips: [
                              for (final delivery in alert.deliveries)
                                '${alertChannelLabel(l10n, delivery.channel)} · ${alertDeliveryLabel(l10n, delivery.status)}',
                            ],
                            onTap: () => context.push(AppRoutes.alert(alert.id)),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  ),
          );
        },
        ),
      ),
    );
  }
}

IconData _icon(AlertType type) {
  return switch (type) {
    AlertType.carAlert => AppIcons.alarm,
    AlertType.orderUpdate => AppIcons.packageIcon,
    AlertType.stickerExpiry => AppIcons.warningCircle,
  };
}

String _vehicleName(List<Vehicle> vehicles, String? id) {
  if (id == null) return '';
  for (final vehicle in vehicles) {
    if (vehicle.id == id) return vehicle.displayName;
  }
  return '';
}

Future<void> _simulate(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) async {
  final alert = await ref.read(alertRepositoryProvider).simulateAlert();
  await ref.read(notificationServiceProvider).showAlarmAlert(
        AlertPayload(
          alertId: alert.id,
          title: l10n.alertLights,
          body: l10n.navAlerts,
        ),
      );
  ref.invalidate(alertsProvider);
  if (context.mounted) context.push(AppRoutes.alert(alert.id));
}
