import '../models/enums.dart';
import '../models/order.dart';
import '../models/vehicle.dart';

/// Calendar months from [paidAt], then [bufferDays].
///
/// Day-of-month clamps to the last valid day (31 Jan + 1 month in 2026 is 28 Feb).
DateTime computeProtectedUntil(
  DateTime paidAt,
  int months, {
  int bufferDays = 0,
}) {
  final monthIndex = paidAt.month - 1 + months;
  final year = paidAt.year + monthIndex ~/ 12;
  final month = monthIndex % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = paidAt.day > lastDay ? lastDay : paidAt.day;
  final shifted = DateTime(
    year,
    month,
    day,
    paidAt.hour,
    paidAt.minute,
    paidAt.second,
    paidAt.millisecond,
    paidAt.microsecond,
  );
  return shifted.add(Duration(days: bufferDays));
}

class ProtectionSnapshot {
  const ProtectionSnapshot({
    required this.hasVehicle,
    required this.hasPaidOrder,
    required this.hasPendingPayment,
    required this.protectedUntil,
    required this.latestPaidOrderDelivered,
    required this.now,
  });

  final bool hasVehicle;
  final bool hasPaidOrder;
  final bool hasPendingPayment;
  final DateTime? protectedUntil;
  final bool latestPaidOrderDelivered;
  final DateTime now;
}

/// Single protection rule. Order of checks matches the product spec.
ProtectionState deriveProtectionState(ProtectionSnapshot snapshot) {
  if (!snapshot.hasVehicle) return ProtectionState.noVehicle;
  if (!snapshot.hasPaidOrder) {
    return snapshot.hasPendingPayment
        ? ProtectionState.paymentPending
        : ProtectionState.noSticker;
  }
  final until = snapshot.protectedUntil;
  if (until == null || snapshot.now.isAfter(until)) {
    return ProtectionState.expired;
  }
  if (!snapshot.latestPaidOrderDelivered) return ProtectionState.inTransit;
  final days = daysUntil(until, snapshot.now);
  if (days <= 14) return ProtectionState.expiring;
  return ProtectionState.active;
}

/// Whole calendar days from [now] until [until]. Negative when already past.
int daysUntil(DateTime until, DateTime now) {
  final untilDate = DateTime(until.year, until.month, until.day);
  final nowDate = DateTime(now.year, now.month, now.day);
  return untilDate.difference(nowDate).inDays;
}

double protectionProgress({
  required DateTime? until,
  required DateTime? paidAt,
  required DateTime now,
}) {
  if (until == null) return 0;
  final left = daysUntil(until, now);
  if (left <= 0) return 0;
  final start = paidAt ?? until.subtract(const Duration(days: 365));
  final total = daysUntil(until, start);
  if (total <= 0) return 1;
  return (left / total).clamp(0, 1).toDouble();
}

ProtectionState protectionForVehicle({
  required Vehicle? vehicle,
  required List<Order> orders,
  required DateTime now,
}) {
  if (vehicle == null) {
    return deriveProtectionState(
      ProtectionSnapshot(
        hasVehicle: false,
        hasPaidOrder: false,
        hasPendingPayment: false,
        protectedUntil: null,
        latestPaidOrderDelivered: false,
        now: now,
      ),
    );
  }
  final mine = orders.where((order) => order.vehicleId == vehicle.id).toList();
  final paid = mine.where((order) => order.status.isPaid).toList();
  final pending = mine.any(
    (order) => order.status == OrderStatus.pendingPayment,
  );
  final latestPaid = paid.isEmpty ? null : paid.last;
  return deriveProtectionState(
    ProtectionSnapshot(
      hasVehicle: true,
      hasPaidOrder: paid.isNotEmpty,
      hasPendingPayment: pending,
      protectedUntil: vehicle.protectedUntil,
      latestPaidOrderDelivered: latestPaid?.status == OrderStatus.delivered,
      now: now,
    ),
  );
}
