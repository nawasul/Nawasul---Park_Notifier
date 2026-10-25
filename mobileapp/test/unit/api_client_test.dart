import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/models/alert_item.dart';
import 'package:mobileapp/core/network/api_client.dart';
import 'package:mobileapp/core/network/live_repositories.dart';
import 'package:mobileapp/core/network/token_store.dart';

void main() {
  test('a 401 refreshes the token and retries the order list', () async {
    final tokens = MemoryTokenStore()
      ..access = 'old'
      ..refresh = 'refresh-1';
    final calls = <String>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://api.nawasul.app'));
    dio.httpClientAdapter = _Script(_handler(calls, tokens));
    final api = ApiClient(tokens: tokens, dio: dio);
    final orders = await LiveOrderRepository(api).fetchOrders();

    expect(calls, [
      'GET /api/v1/orders',
      'POST /api/v1/auth/refresh',
      'GET /api/v1/orders',
    ]);
    expect(tokens.access, 'new-access');
    expect(orders, hasLength(1));
    expect(orders.single.number, 'NW-1001');
    expect(orders.single.invoiceUrl, 'https://nawasul.app/invoices/1001');
  });

  test('a server error code is kept for the screen to translate', () async {
    final tokens = MemoryTokenStore();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.nawasul.app'));
    dio.httpClientAdapter = _Script((options) async {
      return _json(401, {'code': 'invalid_otp', 'message': 'Wrong', 'attemptsLeft': 2});
    });
    final api = ApiClient(tokens: tokens, dio: dio);

    expect(
      () => LiveAuthRepository(api, tokens).verifyOtp('+966512345678', '000000'),
      throwsA(
        isA<AppException>()
            .having((error) => error.code, 'code', 'invalid_otp')
            .having((error) => error.attemptsLeft, 'attemptsLeft', 2),
      ),
    );
  });
}

Future<ResponseBody> Function(RequestOptions) _handler(
  List<String> calls,
  MemoryTokenStore tokens,
) {
  var orders = 0;
  return (options) async {
    calls.add('${options.method} ${options.uri.path}');
    if (options.uri.path.endsWith('/auth/refresh')) {
      return _json(200, {
        'accessToken': 'new-access',
        'refreshToken': 'refresh-2',
      });
    }
    orders += 1;
    if (orders == 1) return _json(401, {'code': 'session_expired', 'message': 'Sign in again.'});
    final auth = options.headers['Authorization'];
    if (auth != 'Bearer new-access' && tokens.access != 'new-access') {
      return _json(401, {'code': 'session_expired', 'message': 'Sign in again.'});
    }
    return _json(200, {
      'items': [
        {
          'id': 'order-1',
          'number': 'NW-1001',
          'vehicleId': 'veh-1',
          'months': 12,
          'status': 'paid',
          'amounts': {
            'stickerSar': 299,
            'deliverySar': 25,
            'vatSar': 49,
            'totalSar': 373,
          },
          'delivery': {
            'name': 'Ahmed',
            'phone': '+966512345678',
            'city': 'riyadh',
            'address': 'Olaya',
          },
          'invoiceUrl': 'https://nawasul.app/invoices/1001',
          'timeline': [
            {'status': 'paid', 'at': '2026-06-15T09:00:00Z'},
          ],
        },
      ],
    });
  };
}

class _Script implements HttpClientAdapter {
  _Script(this._next);

  final Future<ResponseBody> Function(RequestOptions options) _next;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _next(options);
  }
}

ResponseBody _json(int status, Object body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}
