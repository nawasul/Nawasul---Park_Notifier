import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/enums.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../shared/widgets/skeleton_box.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../shared/widgets/vehicle_card.dart';
import '../../home/presentation/providers/garage_provider.dart';
import 'providers/vehicle_provider.dart';
import 'vehicle_protection.dart';

class VehiclesListScreen extends ConsumerWidget {
  const VehiclesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vehicles = ref.watch(vehicleProvider);
    final orders = ref.watch(ordersProvider);
    final now = ref.watch(clockProvider);

    return AppScaffold(
      title: l10n.vehiclesTitle,
      actions: [
        TextButton(
          onPressed: () => context.push(AppRoutes.vehiclesAdd),
          child: Text(l10n.vehiclesAdd),
        ),
      ],
      body: WithOfflineBanner(
        child: vehicles.when(
          loading: () => const ListSkeleton(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(vehicleProvider),
          ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: AppIcons.car,
              heading: l10n.vehiclesEmpty,
              actionLabel: l10n.homeAddVehicle,
              onAction: () => context.push(AppRoutes.vehiclesAdd),
            );
          }
          final orderList = orders.value ?? const [];
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final vehicle = items[index];
              final view = protectionView(
                vehicle: vehicle,
                orders: orderList,
                now: now,
              );
              final (label, variant) = _status(l10n, view.state);
              return VehicleCard(
                vehicle: vehicle,
                statusLabel: label,
                statusVariant: variant,
                onTap: () => context.push(AppRoutes.vehicle(vehicle.id)),
              );
            },
          );
        },
        ),
      ),
    );
  }
}

(String, StatusPillVariant) _status(AppLocalizations l10n, ProtectionState state) {
  return switch (state) {
    ProtectionState.noSticker => (l10n.homeNotProtected, StatusPillVariant.muted),
    ProtectionState.paymentPending => (
        l10n.homeWaitingPayment,
        StatusPillVariant.warning,
      ),
    ProtectionState.inTransit => (l10n.homeOnTheWay, StatusPillVariant.pending),
    ProtectionState.active => (l10n.homeProtected, StatusPillVariant.success),
    ProtectionState.expiring => (l10n.homeExpiresSoon, StatusPillVariant.warning),
    ProtectionState.expired => (l10n.homeNotProtectedNow, StatusPillVariant.error),
    ProtectionState.noVehicle => (l10n.homeAddFirst, StatusPillVariant.muted),
  };
}
