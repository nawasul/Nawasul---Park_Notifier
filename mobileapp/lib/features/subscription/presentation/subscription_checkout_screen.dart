import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_auth_data.dart';
import '../../../core/mock/mock_subscription.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/billing_cycle_toggle.dart';
import '../../../shared/widgets/primary_button.dart';
import 'providers/subscription_provider.dart';

class SubscriptionCheckoutScreen extends ConsumerStatefulWidget {
  const SubscriptionCheckoutScreen({super.key});

  @override
  ConsumerState<SubscriptionCheckoutScreen> createState() =>
      _SubscriptionCheckoutScreenState();
}

class _SubscriptionCheckoutScreenState
    extends ConsumerState<SubscriptionCheckoutScreen> {
  int _selectedPayment = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final subscription = ref.watch(subscriptionProvider);
    final planTier = subscription.checkoutPlan ?? PlanTier.pro;
    final plan = MockSubscription.planFor(planTier);
    final isYearly = subscription.billingCycle == BillingCycle.yearly;
    final price = isYearly ? plan.yearlyPrice : plan.monthlyPrice;
    final user = MockAuthData.primaryUser;

    const paymentMethods = ['Credit Card', 'Apple Pay', 'Mada'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Checkout', style: AppTypography.headingM),
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
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Summary', style: AppTypography.headingM),
                    const SizedBox(height: AppSpacing.md),
                    Text('${plan.name} Plan', style: AppTypography.bodyL),
                    Text(
                      isYearly ? 'Billed yearly' : 'Billed monthly',
                      style: AppTypography.bodyM,
                    ),
                    Text(user.name, style: AppTypography.bodyM),
                    const Divider(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTypography.headingM),
                        Text(
                          price == 0
                              ? 'Free'
                              : 'SAR ${price.toStringAsFixed(0)}',
                          style: AppTypography.headingM.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Payment Method', style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(paymentMethods.length, (i) {
                final selected = _selectedPayment == i;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(
                    bottom: AppSpacing.sm,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPayment = i),
                    child: Container(
                      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.accentSoft
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.borderSubtle,
                          width: selected ? 2 : 1,
                        ),
                        boxShadow: AppShadows.input,
                      ),
                      child: Text(
                        paymentMethods[i],
                        style: AppTypography.bodyL.copyWith(
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Confirm & Pay',
                isLoading: _isLoading,
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        await Future<void>.delayed(
                          const Duration(milliseconds: 800),
                        );
                        ref
                            .read(subscriptionProvider.notifier)
                            .confirmSubscription();
                        if (!context.mounted) return;
                        setState(() => _isLoading = false);
                        context.push(AppRoutes.subscriptionSuccess);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
