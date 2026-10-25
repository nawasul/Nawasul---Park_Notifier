import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/order_quote.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/plate_badge.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/validity_option_card.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import 'providers/order_draft.dart';
import 'providers/order_providers.dart';
import 'widgets/add_vehicle_sheet.dart';
import 'widgets/order_step_header.dart';

class OrderVehicleScreen extends ConsumerStatefulWidget {
  const OrderVehicleScreen({super.key, this.initialVehicleId});

  final String? initialVehicleId;

  @override
  ConsumerState<OrderVehicleScreen> createState() => _OrderVehicleScreenState();
}

class _OrderVehicleScreenState extends ConsumerState<OrderVehicleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectInitial());
  }

  void _selectInitial() {
    final id = widget.initialVehicleId;
    if (id == null || !mounted) return;
    final vehicles = ref.read(vehicleProvider).value;
    if (vehicles == null || !vehicles.any((item) => item.id == id)) return;
    ref.read(orderDraftProvider.notifier).selectVehicle(id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final vehicles = ref.watch(vehicleProvider);
    final pricing = ref.watch(pricingProvider);
    final draft = ref.watch(orderDraftProvider);
    final now = ref.watch(clockProvider);

    ref.listen(pricingProvider, (_, next) {
      final items = next.value?.items;
      if (items == null || ref.read(orderDraftProvider).months != null) return;
      final best = bestValueMonths(items);
      if (best != null) ref.read(orderDraftProvider.notifier).selectMonths(best);
    });

    final waiting = vehicles.isLoading || pricing.isLoading;
    final failed = vehicles.hasError || pricing.hasError;

    return AppScaffold(
      title: l10n.orderVehicleTitle,
      body: waiting
          ? const Center(child: CircularProgressIndicator())
          : failed
              ? ErrorState(onRetry: () {
                  ref.invalidate(vehicleProvider);
                  ref.invalidate(pricingProvider);
                })
              : _body(context, l10n, locale, draft, now),
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l10n,
    String locale,
    OrderDraft draft,
    DateTime now,
  ) {
    final vehicles = ref.watch(vehicleProvider).requireValue;
    final pricing = ref.watch(pricingProvider).requireValue;
    final best = bestValueMonths(pricing.items);
    final selected = vehicles.where((item) => item.id == draft.vehicleId);
    final current = selected.isEmpty ? null : selected.first;
    final until = current?.protectedUntil;
    final startsLater = until != null && until.isAfter(now);

    if (vehicles.isEmpty) {
      return Column(
        children: [
          const OrderStepHeader(step: 1),
          Expanded(
            child: EmptyState(
              icon: AppIcons.car,
              heading: l10n.orderNoVehicle,
              actionLabel: l10n.orderAddVehicle,
              onAction: () => _add(context),
            ),
          ),
        ],
      );
    }

    return ListView(
      children: [
        const OrderStepHeader(step: 1),
        for (final vehicle in vehicles) ...[
          _VehicleChoice(
            name: vehicle.displayName,
            plate: vehicle.plate,
            selected: vehicle.id == draft.vehicleId,
            onTap: () => ref.read(orderDraftProvider.notifier).selectVehicle(vehicle.id),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => _add(context),
            child: Text(l10n.orderAddVehicle),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final item in pricing.items) ...[
          ValidityOptionCard(
            key: Key('validity-${item.months}'),
            monthsLabel: l10n.orderMonths(item.months),
            priceLabel: formatSar(item.priceSar, locale),
            selected: draft.months == item.months,
            bestValueLabel: item.months == best ? l10n.orderBestValue : null,
            onTap: () => ref.read(orderDraftProvider.notifier).selectMonths(item.months),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (draft.months != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.orderValidFor(draft.months!)),
        ],
        if (startsLater) ...[
          const SizedBox(height: AppSpacing.md),
          InfoBanner(message: l10n.orderValidityStarts),
        ],
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          key: const Key('order-continue'),
          label: l10n.actionContinue,
          enabled: draft.vehicleId != null && draft.months != null,
          onPressed: () => context.push(AppRoutes.orderDelivery),
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context) async {
    final created = await showAddVehicleSheet(context);
    if (created == null) return;
    ref.read(orderDraftProvider.notifier).selectVehicle(created.id);
  }
}

class _VehicleChoice extends StatelessWidget {
  const _VehicleChoice({
    required this.name,
    required this.plate,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String plate;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.sm),
              PlateBadge(plate: plate),
            ],
          ),
        ),
      ),
    );
  }
}
