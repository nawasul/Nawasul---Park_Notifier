import 'package:url_launcher/url_launcher.dart';

/// Parses and handles QR payload content safely.
class QrPayloadHandler {
  QrPayloadHandler._();

  /// Returns a safe HTTP/HTTPS [Uri] or null if the payload is not a web URL.
  static Uri? safeWebUri(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    Uri? uri = Uri.tryParse(trimmed);
    if (uri == null) return null;

    if (!uri.hasScheme) {
      uri = Uri.tryParse('https://$trimmed');
      if (uri == null) return null;
    }

    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') return null;

    if (uri.host.isEmpty) return null;

    return uri;
  }

  static Future<bool> openWebUrl(Uri uri) async {
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
