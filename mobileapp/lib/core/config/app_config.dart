import '../mock/mock_home_state.dart';

/// Non-secret app configuration.
///
/// Override at build time with `--dart-define`. Never put API keys or tokens here.
class AppConfig {
  AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.nawasul.app',
  );

  /// Debug and profile builds use the mock repositories.
  /// A release build talks to [apiBaseUrl] unless `--dart-define=USE_MOCK=true`.
  static const useMock = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: !bool.fromEnvironment('dart.vm.product'),
  );

  /// Debug-only seed selector. Hidden in the UI until Phase M3.
  /// Example: `--dart-define=MOCK_HOME_STATE=expired`
  static const mockHomeStateName = String.fromEnvironment(
    'MOCK_HOME_STATE',
    defaultValue: 'active',
  );

  static MockHomeState get mockHomeState {
    for (final state in MockHomeState.values) {
      if (state.name == mockHomeStateName) return state;
    }
    return MockHomeState.active;
  }

  /// Placeholder until a real support number is provided.
  static const supportWhatsAppE164 = '+966500000000';

  /// Placeholder until a real support address is provided.
  static const supportEmail = 'support@nawasul.app';

  /// Shown on Account. Matches pubspec.yaml until a later phase reads it from the build.
  static const appVersion = '1.0.0';

  static const shippingBufferDays = 0;

  /// Public sticker QR host. The owner app only displays this.
  static const qrHost = 'https://nawasul.app';
}
