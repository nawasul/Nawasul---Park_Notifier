import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/mock/mock_repositories.dart';
import '../../../core/models/user.dart';
import '../../../core/network/live_repositories.dart';
import '../../../core/network/network_providers.dart';

abstract class AccountRepository {
  Future<User> fetchMe();
  Future<User> updateMe({required String name, String? city});
  Future<void> deleteMe({String? reason});
  Future<Preferences> fetchPreferences();
  Future<Preferences> updatePreferences(Preferences preferences);
}

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  if (!AppConfig.useMock) {
    return LiveAccountRepository(ref.watch(apiClientProvider));
  }
  return _AccountAdapter(MockAccountRepository(ref.watch(mockDatabaseProvider)));
});

class _AccountAdapter implements AccountRepository {
  _AccountAdapter(this._mock);

  final MockAccountRepository _mock;

  @override
  Future<User> fetchMe() => _mock.fetchMe();

  @override
  Future<User> updateMe({required String name, String? city}) =>
      _mock.updateMe(name: name, city: city);

  @override
  Future<void> deleteMe({String? reason}) => _mock.deleteMe(reason: reason);

  @override
  Future<Preferences> fetchPreferences() => _mock.fetchPreferences();

  @override
  Future<Preferences> updatePreferences(Preferences preferences) =>
      _mock.updatePreferences(preferences);
}
