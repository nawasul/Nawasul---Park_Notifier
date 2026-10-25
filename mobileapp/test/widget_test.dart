import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobileapp/core/router/app_router.dart';
import 'package:mobileapp/features/auth/presentation/providers/session_provider.dart';
import 'package:mobileapp/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({'app_language': 'en'});
  });

  testWidgets('splash routes a new install to onboarding', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NawasulApp()));
    await tester.pump();
    expect(find.text('نواصل'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Add your car'), findsOneWidget);
  });

  testWidgets('unauthenticated users cannot open home', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const NawasulApp(),
      ),
    );
    await tester.pumpAndSettle();

    container.read(appRouterProvider).go('/home');
    await tester.pumpAndSettle();
    expect(find.text('Add your car'), findsOneWidget);
  });

  testWidgets('a signed-in session shows the shell and order route', (tester) async {
    SharedPreferences.setMockInitialValues({
      'app_language': 'en',
      SessionNotifier.authenticatedKey: true,
      SessionNotifier.onboardingKey: true,
      SessionNotifier.newUserKey: false,
      SessionNotifier.profileKey: true,
      SessionNotifier.alertsKey: true,
    });

    await tester.pumpWidget(const ProviderScope(child: NawasulApp()));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Vehicles'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);

    final order = find.text('Order sticker');
    await tester.scrollUntilVisible(order, 200);
    await tester.tap(order);
    await tester.pumpAndSettle();
    expect(find.text('Vehicle and validity'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);
  });

  testWidgets('Arabic locale lays out right to left', (tester) async {
    SharedPreferences.setMockInitialValues({'app_language': 'ar'});

    await tester.pumpWidget(const ProviderScope(child: NawasulApp()));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('ar'));
    expect(
      Directionality.of(tester.element(find.text('أضف سيارتك'))),
      TextDirection.rtl,
    );
  });
}
