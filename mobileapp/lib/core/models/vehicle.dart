class Vehicle {
  const Vehicle({
    required this.id,
    required this.plate,
    required this.make,
    required this.model,
    this.color,
    required this.qrCode,
    required this.shortCode,
    this.protectedUntil,
  });

  final String id;
  final String plate;
  final String make;
  final String model;
  final String? color;
  final String qrCode;
  final String shortCode;
  final DateTime? protectedUntil;

  String get displayName => '$make $model';

  Vehicle copyWith({
    String? id,
    String? plate,
    String? make,
    String? model,
    String? color,
    String? qrCode,
    String? shortCode,
    DateTime? protectedUntil,
    bool clearProtectedUntil = false,
    bool clearColor = false,
  }) {
    return Vehicle(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      make: make ?? this.make,
      model: model ?? this.model,
      color: clearColor ? null : (color ?? this.color),
      qrCode: qrCode ?? this.qrCode,
      shortCode: shortCode ?? this.shortCode,
      protectedUntil: clearProtectedUntil
          ? null
          : (protectedUntil ?? this.protectedUntil),
    );
  }
}
