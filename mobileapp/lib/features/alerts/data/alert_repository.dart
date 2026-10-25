import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/mock/mock_repositories.dart';
import '../../../core/models/alert_item.dart';
import '../../../core/network/live_repositories.dart';
import '../../../core/network/network_providers.dart';

abstract class AlertRepository {
  Future<List<AlertItem>> fetchAlerts();
  Future<AlertItem> fetchAlert(String id);
  Future<AlertItem> markRead(String id);
  Future<AlertItem> acknowledge(String id);
  Future<void> report(String id);
  Future<AlertItem> simulateAlert();
  Future<AlertItem> sendTest();
}

final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  if (!AppConfig.useMock) {
    return LiveAlertRepository(ref.watch(apiClientProvider));
  }
  return _AlertAdapter(MockAlertRepository(ref.watch(mockDatabaseProvider)));
});

class _AlertAdapter implements AlertRepository {
  _AlertAdapter(this._mock);

  final MockAlertRepository _mock;

  @override
  Future<List<AlertItem>> fetchAlerts() => _mock.fetchAlerts();

  @override
  Future<AlertItem> fetchAlert(String id) => _mock.fetchAlert(id);

  @override
  Future<AlertItem> markRead(String id) => _mock.markRead(id);

  @override
  Future<AlertItem> acknowledge(String id) => _mock.acknowledge(id);

  @override
  Future<void> report(String id) => _mock.report(id);

  @override
  Future<AlertItem> simulateAlert() => _mock.simulateAlert();

  @override
  Future<AlertItem> sendTest() => _mock.sendTest();
}
