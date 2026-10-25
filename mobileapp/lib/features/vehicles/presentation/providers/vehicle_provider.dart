import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vehicle_repository.dart';
import '../../../../core/models/vehicle.dart';

class VehicleNotifier extends AsyncNotifier<List<Vehicle>> {
  @override
  Future<List<Vehicle>> build() {
    return ref.read(vehicleRepositoryProvider).fetchVehicles();
  }

  Future<Vehicle> addVehicle(Vehicle vehicle) async {
    final repo = ref.read(vehicleRepositoryProvider);
    final created = await repo.addVehicle(vehicle);
    state = AsyncData(await repo.fetchVehicles());
    return created;
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    final repo = ref.read(vehicleRepositoryProvider);
    await repo.updateVehicle(vehicle);
    state = AsyncData(await repo.fetchVehicles());
  }

  Future<void> deleteVehicle(String id) async {
    final repo = ref.read(vehicleRepositoryProvider);
    await repo.deleteVehicle(id);
    state = AsyncData(await repo.fetchVehicles());
  }
}

final vehicleProvider =
    AsyncNotifierProvider<VehicleNotifier, List<Vehicle>>(VehicleNotifier.new);
