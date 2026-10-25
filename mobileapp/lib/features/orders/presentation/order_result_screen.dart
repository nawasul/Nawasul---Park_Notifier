import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/order.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import '../data/order_repository.dart';
import 'providers/order_draft.dart';
import 'providers/order_providers.dart';

class OrderResultScreen extends ConsumerStatefulWidget {
  const OrderResultScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderResultScreen> createState() => _OrderResultScreenState();
}

class _OrderResultScreenState extends ConsumerState<OrderResultScreen> {
  Order? _order;
  var _settled = false;
  var _attempts = 0;
  String? _error;
  Timer? _timer;
  var _retrying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _poll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _poll() async {
    final poll = ref.read(paymentPollProvider);
    try {
      final order = await ref.read(orderRepositoryProvider).fetchOrder(widget.orderId);
      if (!mounted) return;
      final pending = order.status == OrderStatus.pendingPayment;
      if (pending && _attempts < poll.maxAttempts) {
        _attempts += 1;
        _timer?.cancel();
        _timer = Timer(poll.interval, _poll);
        setState(() {
          _order = order;
          _settled = false;
          _error = null;
        });
        return;
      }
      if (order.status.isPaid) {
        ref.invalidate(vehicleProvider);
        ref.invalidate(ordersProvider);
        ref.read(orderDraftProvider.notifier).clear();
      }
      setState(() {
        _order = order;
        _settled = true;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = AppLocalizations.of(context).errorGenericBody);
    }
  }

  Future<void> _tryAgain() async {
    if (_retrying) return;
    setState(() {
      _retrying = true;
      _settled = false;
      _attempts = 0;
      _error = null;
    });
    try {
      final repo = ref.read(orderRepositoryProvider);
      final url = await repo.paymentUrl(widget.orderId);
      if (!AppConfig.useMock) {
        final opened = await ref.read(urlOpenerProvider)(Uri.parse(url));
        if (!opened) {
          if (mounted) {
            setState(() {
              _error = AppLocalizations.of(context).errorGenericBody;
              _settled = true;
            });
          }
          return;
        }
      }
      await _poll();
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).errorGenericBody);
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final order = _order;

    return AppScaffold(
      title: l10n.orderReviewTitle,
      body: _error != null
          ? ErrorState(message: _error, onRetry: _poll)
          : !_settled || order == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: AppSpacing.lg),
                      Text(l10n.orderConfirming, style: AppTypography.bodyL),
                    ],
                  ),
                )
              : order.status == OrderStatus.paymentFailed
                  ? _Failed(onRetry: _tryAgain, retrying: _retrying)
                  : order.status.isPaid
                      ? _Success(order: order, locale: locale)
                      : _Pending(),
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({required this.order, required this.locale});

  final Order order;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final until = order.protectedUntil;
    return ListView(
      children: [
        Text(l10n.orderLabel(order.number), style: AppTypography.headingL),
        if (until != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.homeValidUntil(formatAppDate(until, locale)),
            style: AppTypography.bodyL,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: l10n.homeViewOrder,
          onPressed: () => context.push(AppRoutes.order(order.id)),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: l10n.orderBackHome,
          onPressed: () => context.go(AppRoutes.home),
        ),
      ],
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.onRetry, required this.retrying});

  final VoidCallback onRetry;
  final bool retrying;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      children: [
        Text(l10n.orderFailed, style: AppTypography.headingL),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: l10n.actionRetry,
          isLoading: retrying,
          enabled: !retrying,
          onPressed: onRetry,
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: l10n.orderBackHome,
          onPressed: () => context.go(AppRoutes.home),
        ),
      ],
    );
  }
}

class _Pending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      children: [
        Text(l10n.orderPending, style: AppTypography.bodyL),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: l10n.orderBackHome,
          onPressed: () => context.go(AppRoutes.home),
        ),
      ],
    );
  }
}
