import 'dart:io';

Future<bool> deviceIsOnline() async {
  if (Platform.environment['FLUTTER_TEST'] == 'true') return true;
  try {
    final result = await InternetAddress.lookup(
      'nawasul.app',
    ).timeout(const Duration(seconds: 3));
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  } on OSError {
    return false;
  }
}
