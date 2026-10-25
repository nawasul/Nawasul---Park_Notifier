import '../../../core/models/enums.dart';
import '../../../core/models/order.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/utils/protection.dart';

class VehicleProtectionView {
  const VehicleProtectionView({
    required this.state,
    required this.latestOrder,
    required this.progress,
    required this.daysLeft,
    required this.until,
  });

  final ProtectionState state;
  final Order? latestOrder;
  final double progress;
  final int? daysLeft;
  final DateTime? until;
}

VehicleProtectionView protectionView({
  required Vehicle? vehicle,
  required List<Order> orders,
  required DateTime now,
}) {
  final state = protectionForVehicle(
    vehicle: vehicle,
    orders: orders,
    now: now,
  );
  if (vehicle == null) {
    return VehicleProtectionView(
      state: state,
      latestOrder: null,
      progress: 0,
      daysLeft: null,
      until: null,
    );
  }
  final mine = orders.where((order) => order.vehicleId == vehicle.id).toList();
  final paid = mine.where((order) => order.status.isPaid).toList();
  final latestPaid = paid.isEmpty ? null : paid.last;
  final until = vehicle.protectedUntil;
  final days = until == null ? null : daysUntil(until, now);
  return VehicleProtectionView(
    state: state,
    latestOrder: mine.isEmpty ? null : mine.last,
    progress: protectionProgress(
      until: until,
      paidAt: latestPaid?.paidAt,
      now: now,
    ),
    daysLeft: days,
    until: until,
  );
}
