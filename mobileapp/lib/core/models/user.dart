import 'enums.dart';

class Preferences {
  const Preferences({
    required this.whatsappAlerts,
    required this.pushAlerts,
    required this.alarmStyle,
    required this.marketing,
  });

  final bool whatsappAlerts;
  final bool pushAlerts;
  final AlarmStyle alarmStyle;
  final bool marketing;

  Preferences copyWith({
    bool? whatsappAlerts,
    bool? pushAlerts,
    AlarmStyle? alarmStyle,
    bool? marketing,
  }) {
    return Preferences(
      whatsappAlerts: whatsappAlerts ?? this.whatsappAlerts,
      pushAlerts: pushAlerts ?? this.pushAlerts,
      alarmStyle: alarmStyle ?? this.alarmStyle,
      marketing: marketing ?? this.marketing,
    );
  }
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.phone,
    this.city,
    required this.preferences,
  });

  final String id;
  final String name;
  final String phone;
  final String? city;
  final Preferences preferences;

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? city,
    Preferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      preferences: preferences ?? this.preferences,
    );
  }
}
