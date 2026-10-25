import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/mock/mock_repositories.dart';
import '../../../core/models/alert_item.dart';
import '../../../core/network/live_repositories.dart';
import '../../../core/network/network_providers.dart';

abstract class AuthRepository {
  Future<SendOtpResult> sendOtp(String phoneE164);
  Future<VerifyResult> verifyOtp(String phoneE164, String code);

  /// Mock-only. Signs the phone in without a WhatsApp code.
  Future<VerifyResult> acceptPhone(String phoneE164);
  Future<void> logout();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (!AppConfig.useMock) {
    return LiveAuthRepository(
      ref.watch(apiClientProvider),
      ref.watch(tokenStoreProvider),
    );
  }
  return _AuthAdapter(MockAuthRepository(ref.watch(mockDatabaseProvider)));
});

class _AuthAdapter implements AuthRepository {
  _AuthAdapter(this._mock);

  final MockAuthRepository _mock;

  @override
  Future<SendOtpResult> sendOtp(String phoneE164) => _mock.sendOtp(phoneE164);

  @override
  Future<VerifyResult> verifyOtp(String phoneE164, String code) =>
      _mock.verifyOtp(phoneE164, code);

  @override
  Future<VerifyResult> acceptPhone(String phoneE164) => _mock.acceptPhone(phoneE164);

  @override
  Future<void> logout() => _mock.logout();
}
