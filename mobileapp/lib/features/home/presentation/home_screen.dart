import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../account/presentation/providers/profile_provider.dart';
import '../../subscription/presentation/providers/subscription_provider.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';
import 'widgets/dashboard_alert_tile.dart';
import 'widgets/dashboard_hero.dart';
import 'widgets/dashboard_vehicle_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehicleProvider);
    final subscription = ref.watch(subscriptionProvider);
    final alerts = ref.watch(alertsProvider);
    final user = ref.watch(profileProvider);
    final topInset = MediaQuery.paddingOf(context).top;
    final recentAlerts = alerts.take(3).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.brandDark,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardHero(
              userName: user.name,
              subscription: subscription,
              topInset: topInset,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'My Vehicles',
                      style: AppTypography.headingM.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (vehicles.isEmpty)
                      Text(
                        'No vehicles registered yet',
                        style: AppTypography.bodyM.copyWith(
                          color: AppColors.textOnDarkSecondary,
                        ),
                      )
                    else
                      ...vehicles.take(3).map(
                            (v) => Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: DashboardVehicleCard(
                                vehicle: v,
                                onTap: () => context.push(
                                  AppRoutes.vehicleDetails(v.id),
                                ),
                              ),
                            ),
                          ),
                    if (vehicles.length > 3) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: () => context.push(AppRoutes.vehicles),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'View all ${vehicles.length} vehicles',
                            style: AppTypography.link.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.none,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Recent Alerts',
                      style: AppTypography.headingM.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (recentAlerts.isEmpty)
                      Container(
                        padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDarkElevated,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: AppColors.onPrimary.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              color: AppColors.textOnDarkSecondary,
                              size: 28,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'No recent alerts',
                              style: AppTypography.bodyM.copyWith(
                                color: AppColors.textOnDarkSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      ...recentAlerts.map(
                        (a) => Padding(
                          padding: const EdgeInsetsDirectional.only(
                            bottom: 12,
                          ),
                          child: DashboardAlertTile(
                            alert: a,
                            onTap: () => context.push(
                              AppRoutes.alertDetail(a.id),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
