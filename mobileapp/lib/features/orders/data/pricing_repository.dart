import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/mock/mock_repositories.dart';
import '../../../core/models/pricing.dart';
import '../../../core/network/live_repositories.dart';
import '../../../core/network/network_providers.dart';

abstract class PricingRepository {
  Future<Pricing> fetchPricing();
}

final pricingRepositoryProvider = Provider<PricingRepository>((ref) {
  if (!AppConfig.useMock) {
    return LivePricingRepository(ref.watch(apiClientProvider));
  }
  return _PricingAdapter(MockPricingRepository(ref.watch(mockDatabaseProvider)));
});

class _PricingAdapter implements PricingRepository {
  _PricingAdapter(this._mock);

  final MockPricingRepository _mock;

  @override
  Future<Pricing> fetchPricing() => _mock.fetchPricing();
}
