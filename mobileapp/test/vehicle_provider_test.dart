import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_home_state.dart';
import 'package:mobileapp/core/mock/mock_providers.dart';
import 'package:mobileapp/core/mock/mock_seed.dart';
import 'package:mobileapp/core/models/vehicle.dart';
import 'package:mobileapp/features/vehicles/presentation/providers/vehicle_provider.dart';

void main() {
  final clock = DateTime(2026, 6, 15);
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        mockDatabaseProvider.overrideWithValue(
          MockDatabase(
            homeState: MockHomeState.active,
            delay: Duration.zero,
            now: clock,
          ),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('starts with the active mock seed', () async {
    final vehicles = await container.read(vehicleProvider.future);
    final seed = MockSeed.forState(MockHomeState.active, now: clock);
    expect(vehicles.length, seed.vehicles.length);
    expect(vehicles.first.id, 'veh-001');
  });

  test('add, update, and delete go through the repository', () async {
    final notifier = container.read(vehicleProvider.notifier);
    await container.read(vehicleProvider.future);

    await notifier.addVehicle(
      const Vehicle(
        id: 'veh-test',
        plate: 'TST 9999',
        make: 'Kia',
        model: 'Sportage',
        color: 'Blue',
        qrCode: 'tok',
        shortCode: 'NW-9999',
      ),
    );

    var vehicles = container.read(vehicleProvider).requireValue;
    expect(vehicles.length, 2);

    await notifier.updateVehicle(vehicles.last.copyWith(model: 'Cerato'));
    vehicles = container.read(vehicleProvider).requireValue;
    expect(vehicles.last.model, 'Cerato');

    await notifier.deleteVehicle('veh-test');
    vehicles = container.read(vehicleProvider).requireValue;
    expect(vehicles.any((vehicle) => vehicle.id == 'veh-test'), isFalse);
  });
}
