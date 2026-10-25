import 'dart:js_interop';

@JS('navigator.onLine')
external JSBoolean get _navigatorOnLine;

Future<bool> deviceIsOnline() async => _navigatorOnLine.toDart;
