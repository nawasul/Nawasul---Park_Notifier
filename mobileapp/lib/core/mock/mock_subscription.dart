enum PlanTier { free, pro, premium }

class SubscriptionPlanData {
  const SubscriptionPlanData({
    required this.tier,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.isPopular = false,
  });

  final PlanTier tier;
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final bool isPopular;

  String priceLabel({required bool isYearly}) {
    final price = isYearly ? yearlyPrice : monthlyPrice;
    if (price == 0) return 'Free';
    return isYearly
        ? 'SAR ${price.toStringAsFixed(0)}/yr'
        : 'SAR ${price.toStringAsFixed(0)}/mo';
  }
}

class MockSubscription {
  MockSubscription._();

  static const defaultCurrentPlan = PlanTier.free;

  static const plans = [
    SubscriptionPlanData(
      tier: PlanTier.free,
      name: 'Free',
      monthlyPrice: 0,
      yearlyPrice: 0,
      features: [
        '1 vehicle',
        'Basic QR notifications',
        'Email support',
      ],
    ),
    SubscriptionPlanData(
      tier: PlanTier.pro,
      name: 'Pro',
      monthlyPrice: 29,
      yearlyPrice: 290,
      isPopular: true,
      features: [
        'Up to 5 vehicles',
        'Priority notifications',
        'Alert history',
        'QR sticker discount',
      ],
    ),
    SubscriptionPlanData(
      tier: PlanTier.premium,
      name: 'Premium',
      monthlyPrice: 49,
      yearlyPrice: 490,
      features: [
        'Unlimited vehicles',
        'Priority phone calls',
        'Full alert history',
        'Free sticker replacements',
        'Priority support',
      ],
    ),
  ];

  static SubscriptionPlanData planFor(PlanTier tier) {
    return plans.firstWhere((p) => p.tier == tier);
  }
}
