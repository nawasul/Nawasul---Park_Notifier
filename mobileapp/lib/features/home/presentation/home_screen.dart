import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_subscription.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/alert_list_item.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../shared/widgets/vehicle_card.dart';
import '../../subscription/presentation/providers/subscription_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehicleProvider);
    final subscription = ref.watch(subscriptionProvider);
    final alerts = ref.watch(alertsProvider);
    final planName = MockSubscription.planFor(subscription.currentPlan).name;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Dashboard', style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.button,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicles.length} vehicles registered',
                      style: AppTypography.headingM.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    StatusPill(
                      label: '$planName Plan',
                      variant: StatusPillVariant.active,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        _QuickAction(
                          icon: Icons.add_circle_outline,
                          label: 'Add Vehicle',
                          onTap: () => context.push(AppRoutes.vehiclesAdd),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _QuickAction(
                          icon: Icons.qr_code_2_outlined,
                          label: 'My QR Code',
                          onTap: () => context.go(AppRoutes.myQr),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _QuickAction(
                          icon: Icons.upgrade_outlined,
                          label: 'Upgrade',
                          onTap: () =>
                              context.push(AppRoutes.subscriptionPlans),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('My Vehicles', style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.md),
              ...vehicles.take(3).map(
                    (v) => Padding(
                      padding: const EdgeInsetsDirectional.only(
                        bottom: AppSpacing.md,
                      ),
                      child: VehicleCard(
                        vehicle: v,
                        compact: true,
                        onTap: () =>
                            context.push(AppRoutes.vehicleDetails(v.id)),
                      ),
                    ),
                  ),
              const SizedBox(height: AppSpacing.lg),
              Text('Recent Alerts', style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.md),
              ...alerts.take(3).map(
                    (a) => Padding(
                      padding: const EdgeInsetsDirectional.only(
                        bottom: AppSpacing.md,
                      ),
                      child: AlertListItem(
                        alert: a,
                        onTap: () =>
                            context.push(AppRoutes.alertDetail(a.id)),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.surface, size: 22),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
