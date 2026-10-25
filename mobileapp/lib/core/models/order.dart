import 'enums.dart';

class OrderAmounts {
  const OrderAmounts({
    required this.stickerSar,
    required this.deliverySar,
    required this.vatSar,
    required this.totalSar,
  });

  final int stickerSar;
  final int deliverySar;
  final int vatSar;
  final int totalSar;
}

class DeliveryDetails {
  const DeliveryDetails({
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
    this.shortAddress,
    this.notes,
  });

  final String name;
  final String phone;
  final String city;
  final String address;
  final String? shortAddress;
  final String? notes;
}

class OrderTimelineEvent {
  const OrderTimelineEvent({required this.status, this.at});

  final OrderStatus status;
  final DateTime? at;
}

class Order {
  const Order({
    required this.id,
    required this.number,
    required this.vehicleId,
    required this.months,
    required this.status,
    required this.amounts,
    required this.delivery,
    this.paidAt,
    this.protectedUntil,
    this.trackingNumber,
    this.invoiceUrl,
    required this.timeline,
  });

  final String id;
  final String number;
  final String vehicleId;
  final int months;
  final OrderStatus status;
  final OrderAmounts amounts;
  final DeliveryDetails delivery;
  final DateTime? paidAt;
  final DateTime? protectedUntil;
  final String? trackingNumber;
  final String? invoiceUrl;
  final List<OrderTimelineEvent> timeline;

  Order copyWith({
    OrderStatus? status,
    DateTime? paidAt,
    DateTime? protectedUntil,
    String? trackingNumber,
    String? invoiceUrl,
    List<OrderTimelineEvent>? timeline,
  }) {
    return Order(
      id: id,
      number: number,
      vehicleId: vehicleId,
      months: months,
      status: status ?? this.status,
      amounts: amounts,
      delivery: delivery,
      paidAt: paidAt ?? this.paidAt,
      protectedUntil: protectedUntil ?? this.protectedUntil,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      timeline: timeline ?? this.timeline,
    );
  }
}
