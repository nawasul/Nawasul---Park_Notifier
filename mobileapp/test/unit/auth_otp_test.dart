import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobileapp/core/config/mock_config.dart';
import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_repositories.dart';
import 'package:mobileapp/core/models/alert_item.dart';
import 'package:mobileapp/features/auth/services/notification_prompt.dart';

void main() {
  late MockDatabase db;
  late MockAuthRepository auth;

  setUp(() {
    db = MockDatabase(delay: Duration.zero);
    auth = MockAuthRepository(db);
  });

  test('a new number with 123456 is a new user', () async {
    const phone = '+966555555555';
    final sent = await auth.sendOtp(phone);
    expect(sent.delivered, isTrue);
    final result = await auth.verifyOtp(phone, MockConfig.successOtp);
    expect(result.isNewUser, isTrue);
    expect(db.user.phone, phone);
  });

  test('the seed number is a returning user', () async {
    const phone = '+966512345678';
    await auth.sendOtp(phone);
    final result = await auth.verifyOtp(phone, MockConfig.successOtp);
    expect(result.isNewUser, isFalse);
  });

  test('wrong codes count down and then lock', () async {
    const phone = '+966555555555';
    await auth.sendOtp(phone);
    for (var left = 4; left >= 1; left--) {
      await expectLater(
        auth.verifyOtp(phone, '111111'),
        throwsA(
          isA<AppException>().having((error) => error.attemptsLeft, 'left', left),
        ),
      );
    }
    await expectLater(
      auth.verifyOtp(phone, '111111'),
      throwsA(
        isA<AppException>().having(
          (error) => error.code,
          'code',
          'too_many_attempts',
        ),
      ),
    );
    await expectLater(
      auth.sendOtp(phone),
      throwsA(
        isA<AppException>().having(
          (error) => error.code,
          'code',
          'too_many_attempts',
        ),
      ),
    );
  });

  test('reserved numbers cover rate limit, network, and missing WhatsApp', () async {
    await expectLater(
      auth.sendOtp(MockConfig.rateLimitedPhone),
      throwsA(isA<AppException>().having((e) => e.code, 'code', 'rate_limited')),
    );
    await expectLater(
      auth.sendOtp(MockConfig.networkPhone),
      throwsA(isA<AppException>().having((e) => e.code, 'code', 'network')),
    );
    final missing = await auth.sendOtp(MockConfig.noWhatsappPhone);
    expect(missing.delivered, isFalse);
    await expectLater(
      auth.verifyOtp(MockConfig.noWhatsappPhone, MockConfig.successOtp),
      throwsA(isA<AppException>().having((e) => e.code, 'code', 'no_whatsapp')),
    );
  });

  test('000000 is an expired code', () async {
    const phone = '+966555555555';
    await auth.sendOtp(phone);
    await expectLater(
      auth.verifyOtp(phone, MockConfig.expiredOtp),
      throwsA(isA<AppException>().having((e) => e.code, 'code', 'expired_otp')),
    );
  });

  test('loud alerts are offered on Android only', () {
    expect(
      showLoudAlertStep(isWeb: false, platform: TargetPlatform.android),
      isTrue,
    );
    expect(
      showLoudAlertStep(isWeb: true, platform: TargetPlatform.android),
      isFalse,
    );
    expect(
      showLoudAlertStep(isWeb: false, platform: TargetPlatform.iOS),
      isFalse,
    );
  });
}
