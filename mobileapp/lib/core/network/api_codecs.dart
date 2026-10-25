import '../models/alert_item.dart';
import '../models/enums.dart';
import '../models/order.dart';
import '../models/pricing.dart';
import '../models/user.dart';
import '../models/vehicle.dart';

Map<String, dynamic> asJsonMap(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  throw const AppException(code: 'bad_response', message: 'Expected an object.');
}

List<dynamic> asJsonList(dynamic data) {
  if (data is List) return data;
  if (data is Map && data['items'] is List) return data['items'] as List;
  throw const AppException(code: 'bad_response', message: 'Expected a list.');
}

T enumByName<T extends Enum>(List<T> values, Object? raw) {
  if (raw is String) {
    for (final value in values) {
      if (value.name == raw) return value;
    }
  }
  throw const AppException(code: 'bad_response', message: 'Unknown value.');
}

DateTime? dateOrNull(Object? raw) {
  if (raw == null || raw == '') return null;
  if (raw is! String) {
    throw const AppException(code: 'bad_response', message: 'Expected a date.');
  }
  return DateTime.parse(raw);
}

DateTime dateRequired(Object? raw) =>
    dateOrNull(raw) ??
    (throw const AppException(code: 'bad_response', message: 'Expected a date.'));

Preferences preferencesFromJson(dynamic data) {
  final json = asJsonMap(data);
  return Preferences(
    whatsappAlerts: json['whatsappAlerts'] == true,
    pushAlerts: json['pushAlerts'] == true,
    alarmStyle: enumByName(AlarmStyle.values, json['alarmStyle']),
    marketing: json['marketing'] == true,
  );
}

Map<String, dynamic> preferencesToJson(Preferences preferences) => {
  'whatsappAlerts': preferences.whatsappAlerts,
  'pushAlerts': preferences.pushAlerts,
  'alarmStyle': preferences.alarmStyle.name,
  'marketing': preferences.marketing,
};

User userFromJson(dynamic data) {
  final json = asJsonMap(data);
  return User(
    id: json['id'].toString(),
    name: json['name']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    city: json['city']?.toString(),
    preferences: preferencesFromJson(json['preferences'] ?? const {}),
  );
}

Vehicle vehicleFromJson(dynamic data) {
  final json = asJsonMap(data);
  return Vehicle(
    id: json['id'].toString(),
    plate: json['plate']?.toString() ?? '',
    make: json['make']?.toString() ?? '',
    model: json['model']?.toString() ?? '',
    color: json['color']?.toString(),
    qrCode: json['qrCode']?.toString() ?? '',
    shortCode: json['shortCode']?.toString() ?? '',
    protectedUntil: dateOrNull(json['protectedUntil']),
  );
}

Map<String, dynamic> vehicleToJson(Vehicle vehicle) => {
  'plate': vehicle.plate,
  'make': vehicle.make,
  'model': vehicle.model,
  if (vehicle.color != null) 'color': vehicle.color,
};

Pricing pricingFromJson(dynamic data) {
  final json = asJsonMap(data);
  final items = asJsonList(json['items']).map((item) {
    final row = asJsonMap(item);
    return PricingItem(
      months: (row['months'] as num).toInt(),
      priceSar: (row['priceSar'] as num).toInt(),
    );
  }).toList();
  return Pricing(
    items: items,
    deliveryFeeSar: (json['deliveryFeeSar'] as num).toInt(),
    vatRate: (json['vatRate'] as num).toDouble(),
    pricesIncludeVat: json['pricesIncludeVat'] == true,
    deliveryEta: json['deliveryEta']?.toString() ?? '',
  );
}

DeliveryDetails deliveryFromJson(dynamic data) {
  final json = asJsonMap(data);
  return DeliveryDetails(
    name: json['name']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    city: json['city']?.toString() ?? '',
    address: json['address']?.toString() ?? '',
    shortAddress: json['shortAddress']?.toString(),
    notes: json['notes']?.toString(),
  );
}

Map<String, dynamic> deliveryToJson(DeliveryDetails delivery) => {
  'name': delivery.name,
  'phone': delivery.phone,
  'city': delivery.city,
  'address': delivery.address,
  if (delivery.shortAddress != null) 'shortAddress': delivery.shortAddress,
  if (delivery.notes != null) 'notes': delivery.notes,
};

Order orderFromJson(dynamic data) {
  final json = asJsonMap(data);
  final amounts = asJsonMap(json['amounts']);
  final timeline = asJsonList(json['timeline'] ?? const []).map((item) {
    final row = asJsonMap(item);
    return OrderTimelineEvent(
      status: enumByName(OrderStatus.values, row['status']),
      at: dateOrNull(row['at']),
    );
  }).toList();
  return Order(
    id: json['id'].toString(),
    number: json['number']?.toString() ?? '',
    vehicleId: json['vehicleId']?.toString() ?? '',
    months: (json['months'] as num).toInt(),
    status: enumByName(OrderStatus.values, json['status']),
    amounts: OrderAmounts(
      stickerSar: (amounts['stickerSar'] as num).toInt(),
      deliverySar: (amounts['deliverySar'] as num).toInt(),
      vatSar: (amounts['vatSar'] as num).toInt(),
      totalSar: (amounts['totalSar'] as num).toInt(),
    ),
    delivery: deliveryFromJson(json['delivery']),
    paidAt: dateOrNull(json['paidAt']),
    protectedUntil: dateOrNull(json['protectedUntil']),
    trackingNumber: json['trackingNumber']?.toString(),
    invoiceUrl: json['invoiceUrl']?.toString(),
    timeline: timeline,
  );
}

AlertItem alertFromJson(dynamic data) {
  final json = asJsonMap(data);
  final deliveries = asJsonList(json['deliveries'] ?? const []).map((item) {
    final row = asJsonMap(item);
    return DeliveryStatus(
      channel: enumByName(DeliveryChannel.values, row['channel']),
      status: enumByName(DeliveryState.values, row['status']),
    );
  }).toList();
  return AlertItem(
    id: json['id'].toString(),
    type: enumByName(AlertType.values, json['type']),
    vehicleId: json['vehicleId']?.toString(),
    reason: json['reason'] == null
        ? null
        : enumByName(AlertReason.values, json['reason']),
    createdAt: dateRequired(json['createdAt']),
    readAt: dateOrNull(json['readAt']),
    ackAt: dateOrNull(json['ackAt']),
    isTest: json['isTest'] == true,
    deliveries: deliveries,
  );
}
