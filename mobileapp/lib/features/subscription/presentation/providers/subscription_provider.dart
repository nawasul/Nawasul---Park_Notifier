import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/mock/mock_alerts.dart';
import '../../../../core/mock/mock_subscription.dart';
import '../../../../shared/widgets/billing_cycle_toggle.dart';

class SubscriptionState {
  const SubscriptionState({
    required this.currentPlan,
    required this.billingCycle,
    this.checkoutPlan,
    required this.periodEndsAt,
    this.isActive = true,
  });

  final PlanTier currentPlan;
  final BillingCycle billingCycle;
  final PlanTier? checkoutPlan;
  final DateTime periodEndsAt;
  final bool isActive;

  int get daysRemaining {
    final days = periodEndsAt.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  String get billingCycleLabel =>
      billingCycle == BillingCycle.yearly ? 'Yearly' : 'Monthly';

  SubscriptionState copyWith({
    PlanTier? currentPlan,
    BillingCycle? billingCycle,
    PlanTier? checkoutPlan,
    DateTime? periodEndsAt,
    bool? isActive,
    bool clearCheckout = false,
  }) {
    return SubscriptionState(
      currentPlan: currentPlan ?? this.currentPlan,
      billingCycle: billingCycle ?? this.billingCycle,
      checkoutPlan: clearCheckout ? null : (checkoutPlan ?? this.checkoutPlan),
      periodEndsAt: periodEndsAt ?? this.periodEndsAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() => SubscriptionState(
        currentPlan: MockSubscription.defaultCurrentPlan,
        billingCycle: BillingCycle.monthly,
        periodEndsAt: DateTime.now().add(const Duration(days: 23)),
      );

  void setBillingCycle(BillingCycle cycle) {
    state = state.copyWith(billingCycle: cycle);
  }

  void selectPlanForCheckout(PlanTier tier) {
    state = state.copyWith(checkoutPlan: tier);
  }

  void confirmSubscription() {
    if (state.checkoutPlan != null) {
      final duration = state.billingCycle == BillingCycle.yearly
          ? const Duration(days: 365)
          : const Duration(days: 30);
      state = state.copyWith(
        currentPlan: state.checkoutPlan!,
        periodEndsAt: DateTime.now().add(duration),
        isActive: true,
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
