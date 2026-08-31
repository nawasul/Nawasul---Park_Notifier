class MockUser {
  const MockUser({
    required this.name,
    required this.phone,
    required this.maskedPhone,
    required this.city,
    required this.email,
  });

  final String name;
  final String phone;
  final String maskedPhone;
  final String city;
  final String email;
}

class MockAuthData {
  MockAuthData._();

  static const primaryUser = MockUser(
    name: 'Ahmed Al-Rashid',
    phone: '+9665123454821',
    maskedPhone: '+966 5X XXX 4821',
    city: 'Riyadh',
    email: 'ahmed.alrashid@example.com',
  );

  static const secondaryUser = MockUser(
    name: 'Fatima Al-Harbi',
    phone: '+9665987654321',
    maskedPhone: '+966 5X XXX 4321',
    city: 'Jeddah',
    email: 'fatima.alharbi@example.com',
  );

  static const sampleUsers = [primaryUser, secondaryUser];

  static const saudiCities = [
    'Riyadh',
    'Jeddah',
    'Dammam',
    'Mecca',
    'Medina',
  ];
}
