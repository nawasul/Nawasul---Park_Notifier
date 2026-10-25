import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/pricing.dart';
import '../../data/pricing_repository.dart';

typedef UrlOpener = Future<bool> Function(Uri uri);

final urlOpenerProvider = Provider<UrlOpener>((ref) {
  return (uri) {
    return launchUrl(
      uri,
      mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.inAppBrowserView,
    );
  };
});

class PaymentPoll {
  const PaymentPoll({
    this.interval = const Duration(seconds: 2),
    this.maxAttempts = 30,
  });

  final Duration interval;
  final int maxAttempts;
}

final paymentPollProvider = Provider<PaymentPoll>((ref) => const PaymentPoll());

final pricingProvider = FutureProvider<Pricing>((ref) {
  return ref.watch(pricingRepositoryProvider).fetchPricing();
});
