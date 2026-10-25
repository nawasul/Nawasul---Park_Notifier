import '../router/app_routes.dart';

/// `nawasul://alerts/<id>` opens alert details.
/// `nawasul://order/<id>` opens the payment result.
String? locationForDeepLink(Uri uri) {
  if (uri.scheme != 'nawasul') return null;
  final id = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
  if (uri.host == 'alerts') {
    if (id.isEmpty) return AppRoutes.alerts;
    return AppRoutes.alert(id);
  }
  if (uri.host == 'order') {
    if (id.isEmpty) return AppRoutes.orders;
    return AppRoutes.orderResult(id);
  }
  return null;
}
