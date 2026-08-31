import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/icon_badge.dart';
import '../../subscription/presentation/providers/subscription_provider.dart';

class AlertDetailScreen extends ConsumerWidget {
  const AlertDetailScreen({super.key, required this.alertId});

  final String alertId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alert = ref.watch(alertByIdProvider(alertId));

    if (alert == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Alert not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: IconBadge(icon: Icons.notifications_active_outlined),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(alert.reason, style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.sm),
              Text(alert.vehicleName, style: AppTypography.bodyL),
              Text(
                DateFormat.yMMMd().add_jm().format(alert.timestamp),
                style: AppTypography.bodyM,
              ),
              const SizedBox(height: AppSpacing.xxl),
              if (alert.locationLabel != null) ...[
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.primary, size: 40),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        alert.locationLabel!,
                        style: AppTypography.bodyM,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_in_talk_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Notified via',
                              style: AppTypography.caption),
                          Text(
                            alert.notificationMethod,
                            style: AppTypography.bodyL.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
