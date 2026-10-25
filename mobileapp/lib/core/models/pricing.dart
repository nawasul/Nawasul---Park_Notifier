class PricingItem {
  const PricingItem({required this.months, required this.priceSar});

  final int months;
  final int priceSar;
}

class Pricing {
  const Pricing({
    required this.items,
    required this.deliveryFeeSar,
    required this.vatRate,
    required this.pricesIncludeVat,
    required this.deliveryEta,
  });

  final List<PricingItem> items;
  final int deliveryFeeSar;
  final double vatRate;
  final bool pricesIncludeVat;
  final String deliveryEta;
}
