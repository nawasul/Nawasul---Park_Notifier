enum QrStatus { active, stickerPending }

class Vehicle {
  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.plateNumber,
    required this.color,
    required this.qrStatus,
    this.photoSelected = false,
  });

  final String id;
  final String make;
  final String model;
  final String plateNumber;
  final String color;
  final QrStatus qrStatus;
  final bool photoSelected;

  String get displayName => '$make $model';

  Vehicle copyWith({
    String? id,
    String? make,
    String? model,
    String? plateNumber,
    String? color,
    QrStatus? qrStatus,
    bool? photoSelected,
  }) {
    return Vehicle(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      plateNumber: plateNumber ?? this.plateNumber,
      color: color ?? this.color,
      qrStatus: qrStatus ?? this.qrStatus,
      photoSelected: photoSelected ?? this.photoSelected,
    );
  }
}

class MockVehicles {
  MockVehicles._();

  static const initialVehicles = [
    Vehicle(
      id: 'veh-001',
      make: 'Toyota',
      model: 'Camry',
      plateNumber: 'ABC 1234',
      color: 'White',
      qrStatus: QrStatus.active,
      photoSelected: true,
    ),
    Vehicle(
      id: 'veh-002',
      make: 'Hyundai',
      model: 'Tucson',
      plateNumber: 'XYZ 5678',
      color: 'Silver',
      qrStatus: QrStatus.stickerPending,
    ),
    Vehicle(
      id: 'veh-003',
      make: 'BMW',
      model: 'X5',
      plateNumber: 'DEF 9012',
      color: 'Black',
      qrStatus: QrStatus.active,
    ),
  ];
}
