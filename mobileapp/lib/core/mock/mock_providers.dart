import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'mock_database.dart';

final mockDatabaseProvider = Provider<MockDatabase>((ref) {
  if (!AppConfig.useMock) {
    throw StateError('MockDatabase is only available when AppConfig.useMock is true.');
  }
  return MockDatabase();
});
