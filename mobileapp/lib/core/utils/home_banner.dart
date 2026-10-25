import '../models/enums.dart';

enum HomeBanner { notificationsBlocked, expiringOrExpired, paymentPending }

/// One banner, in the product priority order.
HomeBanner? pickHomeBanner({
  required bool notificationsBlocked,
  required ProtectionState state,
}) {
  if (notificationsBlocked) return HomeBanner.notificationsBlocked;
  if (state == ProtectionState.expiring || state == ProtectionState.expired) {
    return HomeBanner.expiringOrExpired;
  }
  if (state == ProtectionState.paymentPending) {
    return HomeBanner.paymentPending;
  }
  return null;
}
