import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/order.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../shared/widgets/order_row.dart';
import '../../../shared/widgets/skeleton_box.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import 'order_labels.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final orders = ref.watch(ordersProvider);
    final vehicles = ref.watch(vehicleProvider).value ?? const [];

    return AppScaffold(
      title: l10n.ordersTitle,
      body: WithOfflineBanner(
        child: orders.when(
          loading: () => const ListSkeleton(),
          error: (_, _) => ErrorState(onRetry: () => ref.invalidate(ordersProvider)),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: AppIcons.packageIcon,
              heading: l10n.ordersEmpty,
            );
          }
          final newest = items.reversed.toList();
          return ListView.separated(
            itemCount: newest.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final order = newest[index];
              final vehicle = vehicles.where((item) => item.id == order.vehicleId);
              final title = vehicle.isEmpty ? order.number : vehicle.first.displayName;
              final when = _when(order);
              return OrderRow(
                title: title,
                subtitle: l10n.orderMonths(order.months),
                statusLabel: orderStatusLabel(l10n, order.status),
                statusVariant: orderStatusVariant(order.status),
                dateLabel: when == null ? '' : formatAppDate(when, locale),
                onTap: () => context.push(AppRoutes.order(order.id)),
              );
            },
          );
        },
        ),
      ),
    );
  }
}

DateTime? _when(Order order) {
  if (order.paidAt != null) return order.paidAt;
  for (final event in order.timeline.reversed) {
    if (event.at != null) return event.at;
  }
  return null;
}
