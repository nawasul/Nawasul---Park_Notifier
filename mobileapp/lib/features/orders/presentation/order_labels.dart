import '../../../l10n/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../shared/widgets/status_pill.dart';

String orderStatusLabel(AppLocalizations l10n, OrderStatus status) {
  return switch (status) {
    OrderStatus.pendingPayment => l10n.orderWaiting,
    OrderStatus.paid => l10n.orderPaid,
    OrderStatus.printed => l10n.orderPrinted,
    OrderStatus.shipped => l10n.orderShipped,
    OrderStatus.delivered => l10n.orderDelivered,
    OrderStatus.paymentFailed => l10n.orderFailed,
    OrderStatus.cancelled => l10n.orderCancelled,
    OrderStatus.expired => l10n.orderExpired,
  };
}

StatusPillVariant orderStatusVariant(OrderStatus status) {
  return switch (status) {
    OrderStatus.delivered || OrderStatus.paid => StatusPillVariant.success,
    OrderStatus.printed ||
    OrderStatus.shipped ||
    OrderStatus.pendingPayment =>
      StatusPillVariant.warning,
    OrderStatus.paymentFailed ||
    OrderStatus.cancelled ||
    OrderStatus.expired =>
      StatusPillVariant.error,
  };
}
