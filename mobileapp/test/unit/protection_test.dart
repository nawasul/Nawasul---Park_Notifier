import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/mock/mock_home_state.dart';
import 'package:mobileapp/core/mock/mock_seed.dart';
import 'package:mobileapp/core/models/enums.dart';
import 'package:mobileapp/core/utils/protection.dart';

void main() {
  final now = DateTime(2026, 6, 15, 12);

  test('adds calendar months and clamps the day', () {
    expect(
      computeProtectedUntil(DateTime(2026, 1, 15), 3),
      DateTime(2026, 4, 15),
    );
    expect(
      computeProtectedUntil(DateTime(2026, 1, 31), 1),
      DateTime(2026, 2, 28),
    );
    expect(
      computeProtectedUntil(DateTime(2024, 1, 31), 1),
      DateTime(2024, 2, 29),
    );
    expect(
      computeProtectedUntil(DateTime(2026, 3, 10), 12, bufferDays: 2),
      DateTime(2027, 3, 12),
    );
  });

  test('12 months from March lands in the next March', () {
    expect(
      computeProtectedUntil(DateTime(2026, 3, 10, 8), 12),
      DateTime(2027, 3, 10, 8),
    );
  });

  ProtectionSnapshot snap({
    bool hasVehicle = true,
    bool hasPaidOrder = true,
    bool hasPendingPayment = false,
    DateTime? protectedUntil,
    bool delivered = true,
    DateTime? clock,
  }) {
    return ProtectionSnapshot(
      hasVehicle: hasVehicle,
      hasPaidOrder: hasPaidOrder,
      hasPendingPayment: hasPendingPayment,
      protectedUntil: protectedUntil,
      latestPaidOrderDelivered: delivered,
      now: clock ?? now,
    );
  }

  test('derives each protection state in spec order', () {
    expect(
      deriveProtectionState(snap(hasVehicle: false, hasPaidOrder: false)),
      ProtectionState.noVehicle,
    );
    expect(
      deriveProtectionState(snap(hasPaidOrder: false)),
      ProtectionState.noSticker,
    );
    expect(
      deriveProtectionState(snap(hasPaidOrder: false, hasPendingPayment: true)),
      ProtectionState.paymentPending,
    );
    expect(
      deriveProtectionState(snap(protectedUntil: now.subtract(const Duration(hours: 1)))),
      ProtectionState.expired,
    );
    expect(
      deriveProtectionState(
        snap(
          protectedUntil: now.add(const Duration(days: 10)),
          delivered: false,
        ),
      ),
      ProtectionState.inTransit,
    );
    expect(
      deriveProtectionState(snap(protectedUntil: now.add(const Duration(days: 14)))),
      ProtectionState.expiring,
    );
    expect(
      deriveProtectionState(snap(protectedUntil: now.add(const Duration(days: 15)))),
      ProtectionState.active,
    );
    expect(
      deriveProtectionState(snap(protectedUntil: now)),
      ProtectionState.expiring,
    );
  });

  test('mock seeds match the protection rule', () {
    for (final state in MockHomeState.values) {
      final seed = MockSeed.forState(state, now: now);
      expect(seed.protectionAt(now), seed.expectedProtection, reason: state.name);
    }
  });
}
