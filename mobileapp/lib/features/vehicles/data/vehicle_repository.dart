import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/mock/mock_repositories.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/network/live_repositories.dart';
import '../../../core/network/network_providers.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> fetchVehicles();
  Future<Vehicle> fetchVehicle(String id);
  Future<Vehicle> addVehicle(Vehicle vehicle);
  Future<Vehicle> updateVehicle(Vehicle vehicle);
  Future<void> deleteVehicle(String id);
}

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  if (!AppConfig.useMock) {
    return LiveVehicleRepository(ref.watch(apiClientProvider));
  }
  return _VehicleAdapter(MockVehicleRepository(ref.watch(mockDatabaseProvider)));
});

class _VehicleAdapter implements VehicleRepository {
  _VehicleAdapter(this._mock);

  final MockVehicleRepository _mock;

  @override
  Future<List<Vehicle>> fetchVehicles() => _mock.fetchVehicles();

  @override
  Future<Vehicle> fetchVehicle(String id) => _mock.fetchVehicle(id);

  @override
  Future<Vehicle> addVehicle(Vehicle vehicle) => _mock.addVehicle(vehicle);

  @override
  Future<Vehicle> updateVehicle(Vehicle vehicle) => _mock.updateVehicle(vehicle);

  @override
  Future<void> deleteVehicle(String id) => _mock.deleteVehicle(id);
}
