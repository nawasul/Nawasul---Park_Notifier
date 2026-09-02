class MockUser {
  const MockUser({
    required this.name,
    required this.phone,
    required this.maskedPhone,
    required this.city,
    required this.email,
    required this.memberSince,
  });

  final String name;
  final String phone;
  final String maskedPhone;
  final String city;
  final String email;
  final DateTime memberSince;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '';
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  MockUser copyWith({
    String? name,
    String? phone,
    String? maskedPhone,
    String? city,
    String? email,
    DateTime? memberSince,
  }) {
    return MockUser(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      maskedPhone: maskedPhone ?? this.maskedPhone,
      city: city ?? this.city,
      email: email ?? this.email,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}

class MockAuthData {
  MockAuthData._();

  static final primaryUser = MockUser(
    name: 'Ahmed Al-Rashid',
    phone: '+9665123454821',
    maskedPhone: '+966 5X XXX 4821',
    city: 'Riyadh',
    email: 'ahmed.alrashid@example.com',
    memberSince: DateTime(2024, 3, 15),
  );

  static final secondaryUser = MockUser(
    name: 'Fatima Al-Harbi',
    phone: '+9665987654321',
    maskedPhone: '+966 5X XXX 4321',
    city: 'Jeddah',
    email: 'fatima.alharbi@example.com',
    memberSince: DateTime(2024, 6, 1),
  );

  static final sampleUsers = [primaryUser, secondaryUser];

  static const saudiCities = [
    'Riyadh',
    'Jeddah',
    'Dammam',
    'Mecca',
    'Medina',
  ];
}
