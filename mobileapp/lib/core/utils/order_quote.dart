import '../models/order.dart';
import '../models/pricing.dart';

/// Sticker and delivery prices, with VAT added or extracted from config.
OrderAmounts quoteAmounts({
  required int stickerSar,
  required int deliverySar,
  required double vatRate,
  required bool pricesIncludeVat,
}) {
  if (pricesIncludeVat) {
    final gross = stickerSar + deliverySar;
    final vat = (gross - gross / (1 + vatRate)).round();
    return OrderAmounts(
      stickerSar: stickerSar,
      deliverySar: deliverySar,
      vatSar: vat,
      totalSar: gross,
    );
  }
  final net = stickerSar + deliverySar;
  final vat = (net * vatRate).round();
  return OrderAmounts(
    stickerSar: stickerSar,
    deliverySar: deliverySar,
    vatSar: vat,
    totalSar: net + vat,
  );
}

/// Months of the option with the lowest price per month.
int? bestValueMonths(Iterable<PricingItem> items) {
  PricingItem? best;
  for (final item in items) {
    if (item.months <= 0) continue;
    if (best == null || item.priceSar / item.months < best.priceSar / best.months) {
      best = item;
    }
  }
  return best?.months;
}
