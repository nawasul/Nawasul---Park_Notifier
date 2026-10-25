import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_providers.dart';
import 'package:mobileapp/features/auth/presentation/providers/session_provider.dart';
import 'package:mobileapp/features/orders/presentation/providers/order_providers.dart';
import 'package:mobileapp/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> launch(WidgetTester tester, {required String language}) async {
    SharedPreferences.setMockInitialValues({
      'app_language': language,
      SessionNotifier.authenticatedKey: true,
      SessionNotifier.onboardingKey: true,
      SessionNotifier.newUserKey: false,
      SessionNotifier.profileKey: true,
      SessionNotifier.alertsKey: true,
    });
    final database = MockDatabase(
      delay: Duration.zero,
      now: DateTime(2026, 6, 15, 9),
    );
    final container = ProviderContainer(
      overrides: [
        mockDatabaseProvider.overrideWithValue(database),
        urlOpenerProvider.overrideWithValue((_) async => true),
      ],
    );
    addTearDown(container.dispose);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(() {
      tester.platformDispatcher.textScaleFactorTestValue = 1;
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const NawasulApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('text scale 1.3 keeps the main lists on screen', (tester) async {
    await launch(tester, language: 'en');
    expect(find.text('Home'), findsWidgets);
    await tester.tap(find.text('Vehicles'));
    await tester.pumpAndSettle();
    expect(find.text('Vehicles'), findsWidgets);
    await tester.tap(find.text('Alerts'));
    await tester.pumpAndSettle();
    expect(find.text('Alerts'), findsWidgets);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('Delete account'), findsOneWidget);
    await tester.ensureVisible(find.text('Delete account'));
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic lays the shell out from right to left', (tester) async {
    await launch(tester, language: 'ar');
    expect(find.text('الرئيسية'), findsWidgets);
    expect(
      Directionality.of(tester.element(find.text('الرئيسية'))),
      TextDirection.rtl,
    );
    expect(find.textContaining('ABC'), findsWidgets);
  });
}
