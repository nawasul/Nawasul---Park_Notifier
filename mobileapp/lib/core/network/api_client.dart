import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../models/alert_item.dart';
import 'token_store.dart';

/// Live HTTP client for `/api/v1`.
///
/// JSON fields use the same camelCase names as the Dart models.
/// A 401 refreshes the access token once and retries. A failed refresh
/// clears the session tokens.
class ApiClient {
  ApiClient({
    required this.tokens,
    Dio? dio,
    String? baseUrl,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 20),
               headers: {'Accept': 'application/json'},
             ),
           ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['skipAuth'] == true) {
            handler.next(options);
            return;
          }
          final access = await tokens.readAccess();
          if (access != null && access.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $access';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final response = error.response;
          final options = error.requestOptions;
          final refreshing = options.extra['refresh'] == true;
          final retried = options.extra['retried'] == true;
          if (response?.statusCode != 401 || refreshing || retried) {
            handler.next(error);
            return;
          }
          try {
            await _refresh();
          } on Object {
            await tokens.clear();
            handler.next(error);
            return;
          }
          try {
            options.extra['retried'] = true;
            final access = await tokens.readAccess();
            options.headers['Authorization'] = 'Bearer $access';
            final result = await _dio.fetch(options);
            handler.resolve(result);
          } on DioException catch (retryError) {
            handler.next(retryError);
          }
        },
      ),
    );
  }

  final TokenStore tokens;
  final Dio _dio;
  Future<void>? _refreshing;

  Future<dynamic> get(String path) => _send('GET', path);

  Future<dynamic> post(
    String path, {
    Object? body,
    bool skipAuth = false,
  }) => _send('POST', path, body: body, skipAuth: skipAuth);

  Future<dynamic> patch(String path, {Object? body}) =>
      _send('PATCH', path, body: body);

  Future<dynamic> delete(String path, {Object? body}) =>
      _send('DELETE', path, body: body);

  Future<void> _refresh() {
    return _refreshing ??= _refreshOnce().whenComplete(() => _refreshing = null);
  }

  Future<void> _refreshOnce() async {
    final refresh = await tokens.readRefresh();
    if (refresh == null || refresh.isEmpty) {
      throw const AppException(code: 'session_expired', message: 'Sign in again.');
    }
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/refresh',
      data: {'refreshToken': refresh},
      options: Options(extra: {'skipAuth': true, 'refresh': true}),
    );
    final data = response.data;
    final access = data?['accessToken'];
    final nextRefresh = data?['refreshToken'];
    if (access is! String || nextRefresh is! String) {
      throw const AppException(code: 'bad_response', message: 'Refresh failed.');
    }
    await tokens.write(access: access, refresh: nextRefresh);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    bool skipAuth = false,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        options: Options(method: method, extra: {'skipAuth': skipAuth}),
      );
      return response.data;
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}

AppException mapDioError(DioException error) {
  final data = error.response?.data;
  if (data is Map) {
    final code = data['code'];
    if (code is String && code.isNotEmpty) {
      final attempts = data['attemptsLeft'];
      final retry = data['retryAfterSeconds'];
      return AppException(
        code: code,
        message: data['message']?.toString() ?? '',
        attemptsLeft: attempts is num ? attempts.toInt() : null,
        retryAfterSeconds: retry is num ? retry.toInt() : null,
      );
    }
  }
  final offline = error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout;
  if (offline) {
    return const AppException(code: 'offline', message: 'Offline.');
  }
  if (error.response?.statusCode == 401) {
    return const AppException(code: 'session_expired', message: 'Sign in again.');
  }
  return const AppException(code: 'unknown', message: 'Request failed.');
}
