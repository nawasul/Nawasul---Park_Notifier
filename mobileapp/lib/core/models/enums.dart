enum AlarmStyle { loud, normal }

enum OrderStatus {
  pendingPayment,
  paid,
  printed,
  shipped,
  delivered,
  paymentFailed,
  cancelled,
  expired,
}

extension OrderStatusPaid on OrderStatus {
  bool get isPaid => switch (this) {
        OrderStatus.paid ||
        OrderStatus.printed ||
        OrderStatus.shipped ||
        OrderStatus.delivered =>
          true,
        _ => false,
      };
}

enum AlertType { carAlert, orderUpdate, stickerExpiry }

enum AlertReason { blocking, lightsOn, doorOpen, flatTire, otherUrgent }

enum DeliveryChannel { push, whatsapp }

enum DeliveryState { sent, delivered, read, failed }

enum ProtectionState {
  noVehicle,
  noSticker,
  paymentPending,
  inTransit,
  active,
  expiring,
  expired,
}

enum LegalType { privacy, terms, shipping }

LegalType? legalTypeFromPath(String raw) => switch (raw) {
      'privacy' => LegalType.privacy,
      'terms' => LegalType.terms,
      'shipping' => LegalType.shipping,
      _ => null,
    };
