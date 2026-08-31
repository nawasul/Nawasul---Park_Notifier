import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_subscription.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/billing_cycle_toggle.dart';
import '../../../shared/widgets/plan_card.dart';
import 'providers/subscription_provider.dart';

class SubscriptionPlansScreen extends ConsumerWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    final isYearly = subscription.billingCycle == BillingCycle.yearly;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Subscription Plans', style: AppTypography.headingM),
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
              BillingCycleToggle(
                value: subscription.billingCycle,
                onChanged: (cycle) => ref
                    .read(subscriptionProvider.notifier)
                    .setBillingCycle(cycle),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 400),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 16,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: MockSubscription.plans.map((plan) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: AppSpacing.lg,
                        ),
                        child: PlanCard(
                          name: plan.name,
                          price: plan.priceLabel(isYearly: isYearly),
                          features: plan.features,
                          isPopular: plan.isPopular,
                          isCurrent: subscription.currentPlan == plan.tier,
                          onSelect: () {
                            ref
                                .read(subscriptionProvider.notifier)
                                .selectPlanForCheckout(plan.tier);
                            context.push(AppRoutes.subscriptionCheckout);
                          },
                        ),
                      );
                    }).toList(),
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
