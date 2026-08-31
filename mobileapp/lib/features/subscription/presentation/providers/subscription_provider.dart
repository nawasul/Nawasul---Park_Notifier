import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/mock/mock_alerts.dart';
import '../../../../core/mock/mock_subscription.dart';
import '../../../../shared/widgets/billing_cycle_toggle.dart';

class SubscriptionState {
  const SubscriptionState({
    required this.currentPlan,
    required this.billingCycle,
    this.checkoutPlan,
  });

  final PlanTier currentPlan;
  final BillingCycle billingCycle;
  final PlanTier? checkoutPlan;

  SubscriptionState copyWith({
    PlanTier? currentPlan,
    BillingCycle? billingCycle,
    PlanTier? checkoutPlan,
    bool clearCheckout = false,
  }) {
    return SubscriptionState(
      currentPlan: currentPlan ?? this.currentPlan,
      billingCycle: billingCycle ?? this.billingCycle,
      checkoutPlan: clearCheckout ? null : (checkoutPlan ?? this.checkoutPlan),
    );
  }
}

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() => const SubscriptionState(
        currentPlan: MockSubscription.defaultCurrentPlan,
        billingCycle: BillingCycle.monthly,
      );

  void setBillingCycle(BillingCycle cycle) {
    state = state.copyWith(billingCycle: cycle);
  }

  void selectPlanForCheckout(PlanTier tier) {
    state = state.copyWith(checkoutPlan: tier);
  }

  void confirmSubscription() {
    if (state.checkoutPlan != null) {
      state = state.copyWith(
        currentPlan: state.checkoutPlan!,
        clearCheckout: true,
      );
    }
  }
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, SubscriptionState>(
  SubscriptionNotifier.new,
);

final alertsProvider = Provider<List<Alert>>((ref) {
  return MockAlerts.initialAlerts;
});

final alertByIdProvider = Provider.family<Alert?, String>((ref, id) {
  final alerts = ref.watch(alertsProvider);
  try {
    return alerts.firstWhere((a) => a.id == id);
  } catch (_) {
    return null;
  }
});

final alertsForVehicleProvider =
    Provider.family<List<Alert>, String>((ref, vehicleId) {
  return ref
      .watch(alertsProvider)
      .where((a) => a.vehicleId == vehicleId)
      .toList();
});
