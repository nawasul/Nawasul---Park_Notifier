import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'host_env_stub.dart' if (dart.library.io) 'host_env_io.dart';

/// Reads `nawasul://` links from the host app.
/// Chrome has no host handler, so this returns null there.
class LinkBridge {
  LinkBridge._();

  static const _channel = MethodChannel('nawasul/links');

  static Future<Uri?> initial() async {
    if (kIsWeb || isFlutterTest) return null;
    try {
      final raw = await _channel.invokeMethod<String>('initialLink');
      if (raw == null || raw.isEmpty) return null;
      return Uri.tryParse(raw);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  static void listen(void Function(Uri uri) onLink) {
    if (kIsWeb || isFlutterTest) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'onLink' || call.arguments is! String) return;
      final uri = Uri.tryParse(call.arguments as String);
      if (uri != null) onLink(uri);
    });
  }
}
