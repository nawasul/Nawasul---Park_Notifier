import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Access and refresh tokens. The mock session does not use this.
abstract class TokenStore {
  Future<String?> readAccess();
  Future<String?> readRefresh();
  Future<void> write({required String access, required String refresh});
  Future<void> clear();
}

class MemoryTokenStore implements TokenStore {
  String? access;
  String? refresh;

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
  }

  @override
  Future<String?> readAccess() async => access;

  @override
  Future<String?> readRefresh() async => refresh;

  @override
  Future<void> write({required String access, required String refresh}) async {
    this.access = access;
    this.refresh = refresh;
  }
}

class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _access = 'access_token';
  static const _refresh = 'refresh_token';

  final FlutterSecureStorage _storage;

  @override
  Future<void> clear() async {
    await _storage.delete(key: _access);
    await _storage.delete(key: _refresh);
  }

  @override
  Future<String?> readAccess() => _storage.read(key: _access);

  @override
  Future<String?> readRefresh() => _storage.read(key: _refresh);

  @override
  Future<void> write({required String access, required String refresh}) async {
    await _storage.write(key: _access, value: access);
    await _storage.write(key: _refresh, value: refresh);
  }
}
