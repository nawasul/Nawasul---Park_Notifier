import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/saudi_cities.dart';
import '../../../core/mock/mock_payment_outcome.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/order_quote.dart';
import '../../../core/utils/protection.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_header.dart';
import '../../orders/data/order_repository.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import 'providers/order_draft.dart';
import 'providers/order_providers.dart';
import 'widgets/order_step_header.dart';

class OrderReviewScreen extends ConsumerStatefulWidget {
  const OrderReviewScreen({super.key});

  @override
  ConsumerState<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends ConsumerState<OrderReviewScreen> {
  var _paying = false;
  String? _orderId;
  String? _error;

  Future<void> _pay(OrderDraft draft) async {
    if (_paying || !draft.deliveryComplete || draft.vehicleId == null || draft.months == null) {
      return;
    }
    setState(() {
      _paying = true;
      _error = null;
    });
    try {
      final repo = ref.read(orderRepositoryProvider);
      final orderId = _orderId ??
          (await repo.createOrder(
            vehicleId: draft.vehicleId!,
            months: draft.months!,
            delivery: draft.toDetails(),
          ))
              .id;
      _orderId = orderId;
      final url = await repo.paymentUrl(orderId);
      if (!AppConfig.useMock) {
        final opened = await ref.read(urlOpenerProvider)(Uri.parse(url));
        if (!opened) {
          if (mounted) setState(() => _error = AppLocalizations.of(context).errorGenericBody);
          return;
        }
      }
      if (!mounted) return;
      context.go(AppRoutes.orderResult(orderId));
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).errorGenericBody);
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final draft = ref.watch(orderDraftProvider);
    final pricing = ref.watch(pricingProvider);
    final vehicles = ref.watch(vehicleProvider);

    if (pricing.isLoading || vehicles.isLoading) {
      return AppScaffold(
        title: l10n.orderReviewTitle,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (pricing.hasError || vehicles.hasError || draft.months == null) {
      return AppScaffold(
        title: l10n.orderReviewTitle,
        body: ErrorState(onRetry: () => ref.invalidate(pricingProvider)),
      );
    }

    final price = pricing.requireValue;
    final item = price.items.where((entry) => entry.months == draft.months);
    if (item.isEmpty) {
      return AppScaffold(
        title: l10n.orderReviewTitle,
        body: ErrorState(message: l10n.errorGenericBody),
      );
    }
    final amounts = quoteAmounts(
      stickerSar: item.first.priceSar,
      deliverySar: price.deliveryFeeSar,
      vatRate: price.vatRate,
      pricesIncludeVat: price.pricesIncludeVat,
    );
    final vehicle = vehicles.requireValue.where((entry) => entry.id == draft.vehicleId);
    final name = vehicle.isEmpty ? '' : vehicle.first.displayName;
    final until = _previewUntil(ref, draft.months!);

    return AppScaffold(
      title: l10n.orderReviewTitle,
      body: ListView(
        children: [
          const OrderStepHeader(step: 3),
          if (kDebugMode) ...[
            Text(l10n.debugPaySection, style: AppTypography.caption),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final outcome in MockPaymentOutcome.values)
                  ChoiceChip(
                    label: Text(_payLabel(l10n, outcome)),
                    selected: ref.read(mockDatabaseProvider).nextPayment == outcome,
                    onSelected: (_) {
                      ref.read(mockDatabaseProvider).nextPayment = outcome;
                      setState(() {});
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          SectionHeader(
            title: l10n.orderSummary,
            actionLabel: l10n.orderEdit,
            onAction: () => context.pop(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.headingM),
                const SizedBox(height: AppSpacing.xs),
                Text(l10n.orderMonths(draft.months!), style: AppTypography.bodyM),
                if (until != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.homeValidUntil(formatAppDate(until, locale)),
                    style: AppTypography.bodyM,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Text(_address(l10n, draft), style: AppTypography.bodyM),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Line(l10n.orderSticker, formatSar(amounts.stickerSar, locale)),
          _Line(l10n.orderDeliveryFee, formatSar(amounts.deliverySar, locale)),
          _Line(l10n.orderVat, formatSar(amounts.vatSar, locale)),
          _Line(l10n.orderTotal, formatSar(amounts.totalSar, locale), strong: true),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.orderMethods, style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),
          _Consent(l10n: l10n),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!, style: AppTypography.bodyM.copyWith(color: AppColors.error)),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            key: const Key('order-pay'),
            label: l10n.orderPay(formatSar(amounts.totalSar, locale)),
            isLoading: _paying,
            enabled: !_paying,
            onPressed: () => _pay(draft),
          ),
        ],
      ),
    );
  }
}

DateTime? _previewUntil(WidgetRef ref, int months) {
  return computeProtectedUntil(
    ref.read(mockDatabaseProvider).now,
    months,
    bufferDays: AppConfig.shippingBufferDays,
  );
}

String _payLabel(AppLocalizations l10n, MockPaymentOutcome outcome) {
  return switch (outcome) {
    MockPaymentOutcome.success => l10n.debugPaySucceeds,
    MockPaymentOutcome.failed => l10n.debugPayFails,
    MockPaymentOutcome.pending => l10n.debugPayPending,
  };
}

String _address(AppLocalizations l10n, OrderDraft draft) {
  final city = draft.city == null ? '' : saudiCityLabel(l10n, draft.city!);
  return [draft.toDetails().address, city].where((part) => part.isNotEmpty).join(', ');
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong ? AppTypography.headingM : AppTypography.bodyM;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _Consent extends StatelessWidget {
  const _Consent({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyM.copyWith(color: AppColors.textSecondary);
    final link = AppTypography.bodyM.copyWith(color: AppColors.primary);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: l10n.orderPayConsentBefore),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: _Link(
              label: l10n.orderPayTerms,
              style: link,
              onTap: () => context.push(AppRoutes.legalType('terms')),
            ),
          ),
          TextSpan(text: l10n.orderPayAnd),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: _Link(
              label: l10n.orderPayShipping,
              style: link,
              onTap: () => context.push(AppRoutes.legalType('shipping')),
            ),
          ),
          TextSpan(text: l10n.orderPayConsentAfter),
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({required this.label, required this.style, required this.onTap});

  final String label;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: style),
    );
  }
}
