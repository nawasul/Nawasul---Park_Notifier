import 'package:flutter/material.dart';

import '../../../../core/mock/mock_subscription.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

class DashboardHero extends StatelessWidget {
  const DashboardHero({
    super.key,
    required this.userName,
    required this.subscription,
    required this.topInset,
  });

  final String userName;
  final SubscriptionState subscription;
  final double topInset;

  static String greetingForTime(DateTime time) {
    final hour = time.hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static String firstName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : fullName;
  }

  @override
  Widget build(BuildContext context) {
    final plan = MockSubscription.planFor(subscription.currentPlan);
    final greeting = greetingForTime(DateTime.now());
    final name = firstName(userName);
    final planLabel =
        '${plan.name.toUpperCase()} · ${subscription.billingCycleLabel.toUpperCase()}';

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsetsDirectional.fromSTEB(
        20,
        topInset + AppSpacing.md,
        20,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $name',
            style: AppTypography.headingL.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 23,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subscription.isActive
                ? 'Your vehicles are protected'
                : 'Subscription inactive',
            style: AppTypography.bodyM.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.82),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planLabel,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _StatusDot(isActive: subscription.isActive),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      subscription.isActive ? 'Active' : 'Inactive',
                      style: AppTypography.bodyM.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (subscription.currentPlan != PlanTier.free)
                      Text(
                        '${subscription.daysRemaining} days left',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      Text(
                        'No renewal required',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.75),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.success : AppColors.error,
        shape: BoxShape.circle,
      ),
    );
  }
}
