import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/online.dart';
import '../../../core/mock/mock_home_state.dart';
import '../../../core/mock/mock_payment_outcome.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/home_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/alert_list_item.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/skeleton_box.dart';
import '../../alerts/presentation/alert_labels.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import '../../vehicles/presentation/vehicle_protection.dart';
import 'providers/garage_provider.dart';
import 'widgets/protection_hero.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _page = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vehicles = ref.watch(vehicleProvider);
    final orders = ref.watch(ordersProvider);
    final alerts = ref.watch(alertsProvider);
    final user = ref.watch(currentUserProvider);
    final blocked = ref.watch(notificationsAllowedProvider).value == false;

    final waiting = vehicles.isLoading ||
        orders.isLoading ||
        alerts.isLoading ||
        user.isLoading;
    final failed = vehicles.hasError ||
        orders.hasError ||
        alerts.hasError ||
        user.hasError;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: waiting
            ? const Padding(
                padding: EdgeInsetsDirectional.all(AppSpacing.screen),
                child: ListSkeleton(),
              )
            : failed
                ? ErrorState(onRetry: () {
                    ref.invalidate(vehicleProvider);
                    refreshGarage(ref);
                  })
                : _body(
                    context,
                    l10n,
                    vehicles.requireValue,
                    user.requireValue.name,
                    blocked,
                  ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l10n,
    List<Vehicle> vehicles,
    String name,
    bool notificationsBlocked,
  ) {
    final orders = ref.watch(ordersProvider).requireValue;
    final alerts = ref.watch(alertsProvider).requireValue;
    final now = ref.watch(clockProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final shown = vehicles.isEmpty
        ? null
        : vehicles[_page.clamp(0, vehicles.length - 1)];
    final view = protectionView(vehicle: shown, orders: orders, now: now);
    final banner = pickHomeBanner(
      notificationsBlocked: notificationsBlocked,
      state: view.state,
    );
    final recent = [...alerts]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latest = recent.take(3).toList();
    final unread = alerts.any((alert) => !alert.isRead);

    final offline = ref.watch(onlineProvider).asData?.value == false;

    return ListView(
      padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
      children: [
        if (offline) ...[
          const OfflineBanner(),
          const SizedBox(height: AppSpacing.md),
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                _greeting(l10n, now, name),
                style: AppTypography.headingL,
              ),
            ),
            if (kDebugMode)
              IconButton(
                tooltip: l10n.debugStates,
                onPressed: () => _openStates(context, l10n),
                icon: const Icon(AppIcons.dotsThree),
              ),
            IconButton(
              tooltip: l10n.navAlerts,
              onPressed: () => context.go(AppRoutes.alerts),
              icon: Badge(
                isLabelVisible: unread,
                smallSize: 8,
                backgroundColor: AppColors.primary,
                child: const Icon(AppIcons.bell),
              ),
            ),
          ],
        ),
        if (banner != null) ...[
          const SizedBox(height: AppSpacing.md),
          InfoBanner(
            message: _bannerText(l10n, banner, view.state),
            tone: banner == HomeBanner.notificationsBlocked ||
                    view.state == ProtectionState.expired
                ? InfoBannerTone.error
                : InfoBannerTone.warning,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (vehicles.length < 2)
          _hero(context, l10n, shown, view, locale)
        else
          SizedBox(
            height: 440,
            child: PageView.builder(
              itemCount: vehicles.length,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                final item = protectionView(
                  vehicle: vehicle,
                  orders: orders,
                  now: now,
                );
                return _hero(context, l10n, vehicle, item, locale);
              },
            ),
          ),
        if (vehicles.length > 1) ...[
          const SizedBox(height: AppSpacing.md),
          _dots(vehicles.length),
        ],
        const SizedBox(height: AppSpacing.lg),
        _actions(context, l10n, shown),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: l10n.homeRecentAlerts,
          actionLabel: l10n.homeSeeAll,
          onAction: () => context.go(AppRoutes.alerts),
        ),
        const SizedBox(height: AppSpacing.md),
        if (latest.isEmpty)
          Text(l10n.homeNoAlerts, style: AppTypography.bodyL)
        else
          for (final alert in latest) ...[
            AlertListItem(
              title: alertTitle(l10n, alert),
              subtitle: _vehicleName(vehicles, alert.vehicleId),
              timeLabel: alertTimeLabel(l10n, alert.createdAt, now),
              unread: !alert.isRead,
              onTap: () => context.push(AppRoutes.alert(alert.id)),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }

  Widget _hero(
    BuildContext context,
    AppLocalizations l10n,
    Vehicle? vehicle,
    VehicleProtectionView view,
    String locale,
  ) {
    final showDays = view.daysLeft != null &&
        (view.state == ProtectionState.active ||
            view.state == ProtectionState.expiring ||
            view.state == ProtectionState.expired);
    final showUntil = view.until != null &&
        (view.state == ProtectionState.inTransit ||
            view.state == ProtectionState.active ||
            view.state == ProtectionState.expiring);
    final action = _action(l10n, view.state);
    return ProtectionHero(
      vehicle: vehicle,
      state: view.state,
      status: _status(l10n, view.state),
      daysLabel: showDays ? l10n.homeDaysLeft(view.daysLeft!) : null,
      validUntilLabel: showUntil
          ? l10n.homeValidUntil(formatAppDate(view.until!, locale))
          : null,
      progress: view.state == ProtectionState.active ||
              view.state == ProtectionState.expiring ||
              view.state == ProtectionState.inTransit
          ? view.progress
          : 0,
      actionLabel: action,
      onAction: action == null ? null : () => _onHeroAction(context, view, vehicle),
    );
  }

  Widget _actions(BuildContext context, AppLocalizations l10n, Vehicle? shown) {
    return Row(
      children: [
        _Action(
          icon: AppIcons.plus,
          label: l10n.homeAddVehicle,
          onTap: () => context.push(AppRoutes.vehiclesAdd),
        ),
        const SizedBox(width: AppSpacing.sm),
        _Action(
          icon: AppIcons.packageIcon,
          label: l10n.homeOrderSticker,
          onTap: () => context.push(_orderLocation(shown?.id)),
        ),
        const SizedBox(width: AppSpacing.sm),
        _Action(
          icon: AppIcons.qrCode,
          label: l10n.homeMyQr,
          onTap: shown == null
              ? null
              : () => context.push(AppRoutes.vehicleQr(shown.id)),
        ),
      ],
    );
  }

  Widget _dots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == _page ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == _page ? AppColors.primary : AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openStates(BuildContext context, AppLocalizations l10n) async {
    final selected = await showModalBottomSheet<MockHomeState>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final state in MockHomeState.values)
                  ListTile(
                    key: ValueKey(state),
                    title: Text(_debugLabel(l10n, state)),
                    onTap: () => Navigator.pop(context, state),
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(l10n.debugPaySection, style: AppTypography.headingM),
                  ),
                ),
                for (final outcome in MockPaymentOutcome.values)
                  ListTile(
                    key: ValueKey(outcome),
                    title: Text(_debugPayLabel(l10n, outcome)),
                    onTap: () {
                      ref.read(mockDatabaseProvider).nextPayment = outcome;
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (selected == null) return;
    ref.read(mockDatabaseProvider).applyHomeState(selected);
    ref.invalidate(vehicleProvider);
    refreshGarage(ref);
    setState(() => _page = 0);
  }

  void _onHeroAction(
    BuildContext context,
    VehicleProtectionView view,
    Vehicle? vehicle,
  ) {
    switch (view.state) {
      case ProtectionState.noVehicle:
        context.push(AppRoutes.vehiclesAdd);
      case ProtectionState.noSticker:
      case ProtectionState.expiring:
      case ProtectionState.expired:
        context.push(_orderLocation(vehicle?.id));
      case ProtectionState.paymentPending:
      case ProtectionState.inTransit:
        final order = view.latestOrder;
        if (order != null) context.push(AppRoutes.order(order.id));
      case ProtectionState.active:
        break;
    }
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Expanded(
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  style: AppTypography.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _orderLocation(String? vehicleId) {
  if (vehicleId == null) return AppRoutes.orderVehicle;
  return '${AppRoutes.orderVehicle}?vehicleId=$vehicleId';
}

String _greeting(AppLocalizations l10n, DateTime now, String name) {
  if (now.hour < 12) return l10n.homeGreetingMorning(name);
  if (now.hour < 17) return l10n.homeGreetingAfternoon(name);
  return l10n.homeGreetingEvening(name);
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

String? _action(AppLocalizations l10n, ProtectionState state) {
  return switch (state) {
    ProtectionState.noVehicle => l10n.homeAddVehicle,
    ProtectionState.noSticker => l10n.homeOrderSticker,
    ProtectionState.paymentPending || ProtectionState.inTransit => l10n.homeViewOrder,
    ProtectionState.expiring || ProtectionState.expired => l10n.homeOrderNew,
    ProtectionState.active => null,
  };
}

String _bannerText(AppLocalizations l10n, HomeBanner banner, ProtectionState state) {
  return switch (banner) {
    HomeBanner.notificationsBlocked => l10n.homeBannerBlocked,
    HomeBanner.paymentPending => l10n.homeBannerPayment,
    HomeBanner.expiringOrExpired => state == ProtectionState.expired
        ? l10n.homeBannerExpired
        : l10n.homeBannerExpiring,
  };
}

String _debugLabel(AppLocalizations l10n, MockHomeState state) {
  return switch (state) {
    MockHomeState.noVehicle => l10n.debugNoVehicle,
    MockHomeState.noSticker => l10n.debugNoSticker,
    MockHomeState.paymentPending => l10n.debugPaymentPending,
    MockHomeState.inTransit => l10n.debugInTransit,
    MockHomeState.active => l10n.debugActive,
    MockHomeState.expiring => l10n.debugExpiring,
    MockHomeState.expired => l10n.debugExpired,
    MockHomeState.failedPayment => l10n.debugFailedPayment,
    MockHomeState.emptyAlerts => l10n.debugEmptyAlerts,
  };
}

String _debugPayLabel(AppLocalizations l10n, MockPaymentOutcome outcome) {
  return switch (outcome) {
    MockPaymentOutcome.success => l10n.debugPaySucceeds,
    MockPaymentOutcome.failed => l10n.debugPayFails,
    MockPaymentOutcome.pending => l10n.debugPayPending,
  };
}

String _vehicleName(List<Vehicle> vehicles, String? id) {
  for (final vehicle in vehicles) {
    if (vehicle.id == id) return vehicle.displayName;
  }
  return '';
}
