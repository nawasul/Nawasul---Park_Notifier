import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_repositories.dart';
import 'package:mobileapp/core/models/alert_item.dart';
import 'package:mobileapp/core/models/enums.dart';
import 'package:mobileapp/core/models/vehicle.dart';
import 'package:mobileapp/core/utils/home_banner.dart';

void main() {
  test('banners follow notifications, then expiry, then payment', () {
    expect(
      pickHomeBanner(
        notificationsBlocked: true,
        state: ProtectionState.expiring,
      ),
      HomeBanner.notificationsBlocked,
    );
    expect(
      pickHomeBanner(
        notificationsBlocked: false,
        state: ProtectionState.expired,
      ),
      HomeBanner.expiringOrExpired,
    );
    expect(
      pickHomeBanner(
        notificationsBlocked: false,
        state: ProtectionState.paymentPending,
      ),
      HomeBanner.paymentPending,
    );
    expect(
      pickHomeBanner(
        notificationsBlocked: false,
        state: ProtectionState.active,
      ),
      isNull,
    );
  });

  test('a duplicate plate is rejected and a new vehicle gets a code', () async {
    final db = MockDatabase(delay: Duration.zero);
    final repo = MockVehicleRepository(db);
    await expectLater(
      repo.addVehicle(
        const Vehicle(
          id: '',
          plate: 'abc  1234',
          make: 'Kia',
          model: 'Rio',
          qrCode: '',
          shortCode: '',
        ),
      ),
      throwsA(isA<AppException>().having((e) => e.code, 'code', 'duplicate_plate')),
    );
    final created = await repo.addVehicle(
      const Vehicle(
        id: '',
        plate: 'KSA 9090',
        make: 'Kia',
        model: 'Rio',
        qrCode: '',
        shortCode: '',
      ),
    );
    expect(created.id, isNotEmpty);
    expect(created.qrCode, startsWith('qr_tok_'));
    expect(created.shortCode, startsWith('NW-'));
  });
}
