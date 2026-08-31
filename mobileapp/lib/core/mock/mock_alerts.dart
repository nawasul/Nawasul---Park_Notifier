class Alert {
  const Alert({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.reason,
    required this.timestamp,
    required this.notificationMethod,
    this.locationLabel,
  });

  final String id;
  final String vehicleId;
  final String vehicleName;
  final String reason;
  final DateTime timestamp;
  final String notificationMethod;
  final String? locationLabel;
}

class MockAlerts {
  MockAlerts._();

  static final initialAlerts = [
    Alert(
      id: 'alert-001',
      vehicleId: 'veh-001',
      vehicleName: 'Toyota Camry',
      reason: 'QR scanned — blocked driveway',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      notificationMethod: 'Phone Call',
      locationLabel: 'King Fahd Road, Riyadh',
    ),
    Alert(
      id: 'alert-002',
      vehicleId: 'veh-003',
      vehicleName: 'BMW X5',
      reason: 'QR scanned — vehicle blocking exit',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      notificationMethod: 'Push Notification',
      locationLabel: 'Olaya District, Riyadh',
    ),
    Alert(
      id: 'alert-003',
      vehicleId: 'veh-001',
      vehicleName: 'Toyota Camry',
      reason: 'QR scanned — parking issue',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      notificationMethod: 'Phone Call',
      locationLabel: 'Al Malaz, Riyadh',
    ),
  ];
}
