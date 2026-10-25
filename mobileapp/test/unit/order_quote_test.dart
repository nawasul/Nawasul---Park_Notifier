import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/config/mock_config.dart';
import 'package:mobileapp/core/utils/order_quote.dart';
import 'package:mobileapp/core/models/pricing.dart';

void main() {
  test('VAT is added on top when prices exclude it', () {
    final quote = quoteAmounts(
      stickerSar: MockConfig.price12MonthsSar,
      deliverySar: MockConfig.deliveryFeeSar,
      vatRate: MockConfig.vatRate,
      pricesIncludeVat: false,
    );
    expect(quote.vatSar, 49);
    expect(quote.totalSar, 373);

    final three = quoteAmounts(
      stickerSar: 99,
      deliverySar: 25,
      vatRate: 0.15,
      pricesIncludeVat: false,
    );
    expect(three.vatSar, 19);
    expect(three.totalSar, 143);
  });

  test('VAT is extracted when prices already include it', () {
    final quote = quoteAmounts(
      stickerSar: 115,
      deliverySar: 0,
      vatRate: 0.15,
      pricesIncludeVat: true,
    );
    expect(quote.totalSar, 115);
    expect(quote.vatSar, 15);
  });

  test('the longest sticker is the best value', () {
    expect(
      bestValueMonths(const [
        PricingItem(months: 3, priceSar: 99),
        PricingItem(months: 6, priceSar: 179),
        PricingItem(months: 12, priceSar: 299),
      ]),
      12,
    );
  });
}
