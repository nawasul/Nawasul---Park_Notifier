import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/saudi_cities.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/order.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/plate_badge.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../shared/widgets/stepper_timeline.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import 'order_labels.dart';
import 'providers/order_providers.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final orders = ref.watch(ordersProvider);
    final vehicles = ref.watch(vehicleProvider);

    return AppScaffold(
      title: l10n.ordersTitle,
      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(onRetry: () => ref.invalidate(ordersProvider)),
        data: (items) {
          final match = items.where((order) => order.id == orderId);
          if (match.isEmpty) {
            return ErrorState(message: l10n.orderNotFound);
          }
          final order = match.first;
          final vehicle = (vehicles.value ?? const [])
              .where((item) => item.id == order.vehicleId);
          return ListView(
            children: [
              Text(l10n.orderLabel(order.number), style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.sm),
              StatusPill(
                label: orderStatusLabel(l10n, order.status),
                variant: orderStatusVariant(order.status),
              ),
              if (vehicle.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(vehicle.first.displayName, style: AppTypography.headingM),
                const SizedBox(height: AppSpacing.sm),
                PlateBadge(plate: vehicle.first.plate),
              ],
              if (order.protectedUntil != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.homeValidUntil(formatAppDate(order.protectedUntil!, locale)),
                  style: AppTypography.bodyL,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (order.status.isPaid)
                AppCard(
                  child: StepperTimeline(
                    steps: [
                      for (final status in const [
                        OrderStatus.paid,
                        OrderStatus.printed,
                        OrderStatus.shipped,
                        OrderStatus.delivered,
                      ])
                        TimelineStep(
                          label: orderStatusLabel(l10n, status),
                          done: _reached(order.status, status),
                          dateLabel: _dateFor(order, status, locale),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              Text(_deliveryLines(l10n, order), style: AppTypography.bodyM),
              if (order.trackingNumber != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.orderTracking, style: AppTypography.caption),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: Text(order.trackingNumber!, style: AppTypography.bodyL),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: order.trackingNumber!),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.orderCopied)),
                        );
                      },
                      child: Text(l10n.actionCopy),
                    ),
                  ],
                ),
              ],
              if (order.invoiceUrl != null) ...[
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: l10n.orderInvoice,
                  onPressed: () => ref.read(urlOpenerProvider)(Uri.parse(order.invoiceUrl!)),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: l10n.orderNeedHelp,
                onPressed: () => context.push(AppRoutes.help),
              ),
              if (kDebugMode &&
                  order.status.isPaid &&
                  order.status != OrderStatus.delivered) ...[
                const SizedBox(height: AppSpacing.lg),
                TextButton(
                  onPressed: () {
                    ref.read(mockDatabaseProvider).markDelivered(order.id);
                    ref.invalidate(ordersProvider);
                    ref.invalidate(vehicleProvider);
                  },
                  child: Text(l10n.debugMarkDelivered),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

bool _reached(OrderStatus current, OrderStatus step) {
  const rank = {
    OrderStatus.paid: 0,
    OrderStatus.printed: 1,
    OrderStatus.shipped: 2,
    OrderStatus.delivered: 3,
  };
  final currentRank = rank[current];
  final stepRank = rank[step];
  if (currentRank == null || stepRank == null) return false;
  return currentRank >= stepRank;
}

String? _dateFor(Order order, OrderStatus status, String locale) {
  for (final event in order.timeline) {
    if (event.status == status && event.at != null) {
      return formatAppDate(event.at!, locale);
    }
  }
  return null;
}

String _deliveryLines(AppLocalizations l10n, Order order) {
  final city = saudiCityLabel(l10n, order.delivery.city);
  return [
    order.delivery.name,
    order.delivery.phone,
    order.delivery.address,
    city,
    if (order.delivery.shortAddress != null) order.delivery.shortAddress!,
    if (order.delivery.notes != null) order.delivery.notes!,
  ].join('\n');
}
