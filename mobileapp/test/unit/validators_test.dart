import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/utils/validators.dart';

void main() {
  test('accepts a Saudi mobile and rejects other shapes', () {
    expect(PhoneValidator.nationalError('512345678'), isNull);
    expect(PhoneValidator.nationalError('0512345678'), isNull);
    expect(PhoneValidator.toE164('0512345678'), '+966512345678');
    expect(PhoneValidator.isValidE164('+966512345678'), isTrue);
    expect(PhoneValidator.nationalError('412345678'), 'invalid');
    expect(PhoneValidator.nationalError(''), 'required');
    expect(PhoneValidator.isValidE164('+96651234567'), isFalse);
    expect(PhoneValidator.isValidE164('+14155552671'), isFalse);
    expect(PhoneValidator.mask('+966512345678'), '+966 5•••••678');
  });

  test('requires letters and Western digits on a plate', () {
    expect(PlateValidator.error('ABC 1234'), isNull);
    expect(PlateValidator.error('أ ب ج 1234'), isNull);
    expect(PlateValidator.error('1234'), 'invalid');
    expect(PlateValidator.error('ABC'), 'invalid');
    expect(PlateValidator.error(''), 'required');
    expect(PlateValidator.error('ABC-1234'), 'invalid');
  });
}
