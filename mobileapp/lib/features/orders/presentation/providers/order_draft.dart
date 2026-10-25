import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/saudi_cities.dart';
import '../../../../core/mock/mock_database.dart';
import '../../../../core/models/order.dart';
import '../../../../core/models/user.dart';
import '../../../../core/utils/validators.dart';

class OrderDraft {
  const OrderDraft({
    this.vehicleId,
    this.months,
    this.name = '',
    this.phone = '',
    this.city,
    this.street = '',
    this.district = '',
    this.building = '',
    this.shortAddress = '',
    this.notes = '',
    this.saveAddress = true,
  });

  final String? vehicleId;
  final int? months;
  final String name;
  final String phone;
  final String? city;
  final String street;
  final String district;
  final String building;
  final String shortAddress;
  final String notes;
  final bool saveAddress;

  bool get deliveryComplete {
    return name.trim().length >= 2 &&
        name.trim().length <= 50 &&
        validDeliveryPhone(phone) &&
        city != null &&
        street.trim().isNotEmpty &&
        district.trim().isNotEmpty &&
        building.trim().isNotEmpty;
  }

  DeliveryDetails toDetails() {
    final address = [street, district, building]
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .join(', ');
    final short = shortAddress.trim();
    final note = notes.trim();
    return DeliveryDetails(
      name: name.trim(),
      phone: normalizeDeliveryPhone(phone),
      city: city!,
      address: address,
      shortAddress: short.isEmpty ? null : short,
      notes: note.isEmpty ? null : note,
    );
  }

  OrderDraft copyWith({
    String? vehicleId,
    int? months,
    String? name,
    String? phone,
    String? city,
    String? street,
    String? district,
    String? building,
    String? shortAddress,
    String? notes,
    bool? saveAddress,
    bool clearCity = false,
  }) {
    return OrderDraft(
      vehicleId: vehicleId ?? this.vehicleId,
      months: months ?? this.months,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: clearCity ? null : (city ?? this.city),
      street: street ?? this.street,
      district: district ?? this.district,
      building: building ?? this.building,
      shortAddress: shortAddress ?? this.shortAddress,
      notes: notes ?? this.notes,
      saveAddress: saveAddress ?? this.saveAddress,
    );
  }
}

class OrderDraftNotifier extends Notifier<OrderDraft> {
  @override
  OrderDraft build() => const OrderDraft();

  void selectVehicle(String id) => state = state.copyWith(vehicleId: id);

  void selectMonths(int months) => state = state.copyWith(months: months);

  void prefillFromUser(User user) {
    state = state.copyWith(
      name: user.name,
      phone: user.phone,
      city: cityIdFor(user.city),
      clearCity: cityIdFor(user.city) == null,
    );
  }

  void applySaved(DeliveryDetails details) {
    final parts = details.address.split(', ');
    state = state.copyWith(
      name: details.name,
      phone: details.phone,
      city: cityIdFor(details.city),
      clearCity: cityIdFor(details.city) == null,
      street: parts.isNotEmpty ? parts.first : '',
      district: parts.length > 1 ? parts[1] : '',
      building: parts.length > 2 ? parts.sublist(2).join(', ') : '',
      shortAddress: details.shortAddress ?? '',
      notes: details.notes ?? '',
    );
  }

  void setName(String value) => _set(state.copyWith(name: value), state.name == value);

  void setPhone(String value) => _set(state.copyWith(phone: value), state.phone == value);

  void setCity(String? value) {
    if (value == null) {
      state = state.copyWith(clearCity: true);
      return;
    }
    if (state.city == value) return;
    state = state.copyWith(city: value);
  }

  void setStreet(String value) => _set(state.copyWith(street: value), state.street == value);

  void setDistrict(String value) =>
      _set(state.copyWith(district: value), state.district == value);

  void setBuilding(String value) =>
      _set(state.copyWith(building: value), state.building == value);

  void setShortAddress(String value) =>
      _set(state.copyWith(shortAddress: value), state.shortAddress == value);

  void setNotes(String value) => _set(state.copyWith(notes: value), state.notes == value);

  void setSaveAddress(bool value) {
    if (state.saveAddress == value) return;
    state = state.copyWith(saveAddress: value);
  }

  void clear() => state = const OrderDraft();

  void _set(OrderDraft next, bool unchanged) {
    if (unchanged) return;
    state = next;
  }
}

final orderDraftProvider = NotifierProvider<OrderDraftNotifier, OrderDraft>(
  OrderDraftNotifier.new,
);

bool validDeliveryPhone(String input) {
  final compact = input.replaceAll(' ', '');
  if (PhoneValidator.isValidE164(compact)) return true;
  return PhoneValidator.nationalError(input) == null;
}

String normalizeDeliveryPhone(String input) {
  final compact = input.replaceAll(' ', '');
  if (PhoneValidator.isValidE164(compact)) return compact;
  return PhoneValidator.toE164(input) ?? compact;
}

String? cityIdFor(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final lower = raw.trim().toLowerCase();
  if (saudiCityIds.contains(lower)) return lower;
  return null;
}

void rememberDelivery(MockDatabase db, OrderDraft draft) {
  if (!draft.saveAddress || !draft.deliveryComplete) return;
  db.savedDelivery = draft.toDetails();
}
