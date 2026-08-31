import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/mock/mock_vehicles.dart';

class VehicleNotifier extends Notifier<List<Vehicle>> {
  @override
  List<Vehicle> build() => List.of(MockVehicles.initialVehicles);

  void addVehicle(Vehicle vehicle) {
    state = [...state, vehicle];
  }

  void updateVehicle(Vehicle vehicle) {
    state = [
      for (final v in state)
        if (v.id == vehicle.id) vehicle else v,
    ];
  }

  void deleteVehicle(String id) {
    state = state.where((v) => v.id != id).toList();
  }

  Vehicle? getById(String id) {
    try {
      return state.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }
}

final vehicleProvider =
    NotifierProvider<VehicleNotifier, List<Vehicle>>(VehicleNotifier.new);

final selectedVehicleIdProvider = StateProvider<String?>((ref) {
  final vehicles = ref.watch(vehicleProvider);
  final active = vehicles.where((v) => v.qrStatus == QrStatus.active);
  if (active.isNotEmpty) return active.first.id;
  if (vehicles.isNotEmpty) return vehicles.first.id;
  return null;
});

final vehicleByIdProvider = Provider.family<Vehicle?, String>((ref, id) {
  return ref.watch(vehicleProvider.notifier).getById(id);
});
