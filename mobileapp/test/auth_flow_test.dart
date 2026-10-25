import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_providers.dart';
import 'package:mobileapp/features/auth/presentation/verify_screen.dart';
import 'package:mobileapp/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<ProviderContainer> pumpApp(
    WidgetTester tester, {
    required String language,
  }) async {
    SharedPreferences.setMockInitialValues({'app_language': language});
    final container = ProviderContainer(
      overrides: [
        mockDatabaseProvider.overrideWithValue(
          MockDatabase(delay: Duration.zero),
        ),
        resendDelayProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const NawasulApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> enterCode(WidgetTester tester, String code) async {
    await tester.enterText(find.byType(EditableText), code);
    await tester.pump();
  }

  testWidgets('a new user reaches home in English', (tester) async {
    final container = await pumpApp(tester, language: 'en');

    expect(find.text('Add your car'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Stick the QR on your car'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Get alerted, privately'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your number'), findsOneWidget);
    await tester.tap(find.text('Terms'));
    await tester.pumpAndSettle();
    expect(find.text('The service'), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send me offers and news'));
    await tester.pumpAndSettle();
    await enterCode(tester, '555555555');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('What should we call you?'), findsOneWidget);
    await enterCode(tester, 'Sara');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Allow alerts'), findsOneWidget);
    await tester.tap(find.text('Maybe later'));
    await tester.pumpAndSettle();

    expect(find.text('Add your first vehicle'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    final user = container.read(mockDatabaseProvider).user;
    expect(user.name, 'Sara');
    expect(user.phone, '+966555555555');
    expect(user.preferences.marketing, isTrue);
  });

  testWidgets('a returning user skips name and alerts', (tester) async {
    await pumpApp(tester, language: 'en');
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await enterCode(tester, '512345678');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Protected'), findsOneWidget);
    expect(find.text('What should we call you?'), findsNothing);
  });

  testWidgets('a new user reaches home in Arabic', (tester) async {
    await pumpApp(tester, language: 'ar');
    expect(find.text('أضف سيارتك'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('أضف سيارتك'))),
      TextDirection.rtl,
    );
    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();
    await enterCode(tester, '555111222');
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();
    await enterCode(tester, 'ليان');
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('لاحقاً'));
    await tester.pumpAndSettle();

    expect(find.text('أضف مركبتك الأولى'), findsOneWidget);
    expect(find.text('الرئيسية'), findsOneWidget);
  });

  testWidgets('a number without WhatsApp can open help', (tester) async {
    await pumpApp(tester, language: 'en');
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await enterCode(tester, '500000003');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What should we call you?'), findsOneWidget);
  });

  testWidgets('a rate limited number stays on the phone screen', (tester) async {
    await pumpApp(tester, language: 'en');
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await enterCode(tester, '500000001');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('What should we call you?'), findsOneWidget);
  });
}
