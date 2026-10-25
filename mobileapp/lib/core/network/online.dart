import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'online_stub.dart' if (dart.library.io) 'online_io.dart' if (dart.library.js_interop) 'online_web.dart';

/// True when the device can reach the network. Tests stay online.
final onlineProvider = FutureProvider<bool>((ref) => deviceIsOnline());
