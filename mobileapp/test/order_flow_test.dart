import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_home_state.dart';
import 'package:mobileapp/core/mock/mock_payment_outcome.dart';
import 'package:mobileapp/core/mock/mock_providers.dart';
import 'package:mobileapp/core/router/app_router.dart';
import 'package:mobileapp/core/router/app_routes.dart';
import 'package:mobileapp/features/auth/presentation/providers/session_provider.dart';
import 'package:mobileapp/features/orders/presentation/providers/order_providers.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/shared/widgets/primary_button.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<ProviderContainer> launch(
    WidgetTester tester, {
    MockHomeState homeState = MockHomeState.noSticker,
    MockPaymentOutcome? outcome,
    PaymentPoll? poll,
  }) async {
    SharedPreferences.setMockInitialValues({
      'app_language': 'en',
      SessionNotifier.authenticatedKey: true,
      SessionNotifier.onboardingKey: true,
      SessionNotifier.newUserKey: false,
      SessionNotifier.profileKey: true,
      SessionNotifier.alertsKey: true,
    });
    final database = MockDatabase(
      homeState: homeState,
      delay: Duration.zero,
      now: DateTime(2026, 6, 15, 9),
    );
    if (outcome != null) database.nextPayment = outcome;
    final container = ProviderContainer(
      overrides: [
        mockDatabaseProvider.overrideWithValue(database),
        urlOpenerProvider.overrideWithValue((uri) async => true),
        if (poll != null) paymentPollProvider.overrideWithValue(poll),
      ],
    );
    addTearDown(container.dispose);
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const NawasulApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> fill(WidgetTester tester, Key key, String value) {
    return tester.enterText(
      find.descendant(
        of: find.byKey(key),
        matching: find.byType(EditableText),
      ),
      value,
    );
  }

  Future<void> reachReview(WidgetTester tester) async {
    expect(find.text('Not protected yet'), findsWidgets);
    await tester.tap(find.widgetWithText(PrimaryButton, 'Order sticker'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('order-continue')));
    await tester.tap(find.byKey(const Key('order-continue')));
    await tester.pumpAndSettle();
    await fill(tester, const Key('delivery-street'), 'Olaya');
    await fill(tester, const Key('delivery-district'), 'Al Olaya');
    await fill(tester, const Key('delivery-building'), '12');
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('order-continue')));
    await tester.tap(find.byKey(const Key('order-continue')));
    await tester.pumpAndSettle();
  }

  testWidgets('a paid sticker moves from on the way to protected', (tester) async {
    final container = await launch(tester);
    await reachReview(tester);
    await tester.ensureVisible(find.byKey(const Key('order-pay')));
    await tester.tap(find.byKey(const Key('order-pay')));
    await tester.pumpAndSettle();

    expect(find.text('Back to Home'), findsOneWidget);
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();
    expect(find.text('Sticker on the way'), findsWidgets);

    await tester.tap(find.widgetWithText(PrimaryButton, 'View order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark delivered'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Protected'), findsWidgets);

    container.read(appRouterProvider).go(AppRoutes.orders);
    await tester.pumpAndSettle();
    expect(find.text('Toyota Camry'), findsWidgets);
    expect(find.text('Delivered'), findsWidgets);
  });

  testWidgets('a new vehicle can be added from the order step', (tester) async {
    await launch(tester, homeState: MockHomeState.noVehicle);
    await tester.tap(find.text('Order sticker'));
    await tester.pumpAndSettle();
    expect(find.text('Add a vehicle to continue.'), findsOneWidget);
    await tester.tap(find.text('Add a new vehicle'));
    await tester.pumpAndSettle();

    Future<void> fillField(Key key, String value) {
      return tester.enterText(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(EditableText),
        ),
        value,
      );
    }

    await fillField(const Key('sheet-plate'), 'KSA 2222');
    await tester.tap(find.byKey(const Key('sheet-make')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Toyota').last);
    await tester.pumpAndSettle();
    await fillField(const Key('sheet-model'), 'Yaris');
    await tester.pump();
    await tester.tap(find.widgetWithText(PrimaryButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.text('Toyota Yaris'), findsWidgets);
    expect(find.text('KSA 2222'), findsWidgets);
  });

  testWidgets('the debug switcher can choose each payment outcome', (tester) async {
    final container = await launch(tester);
    await tester.tap(find.byTooltip('States'));
    await tester.pumpAndSettle();
    expect(find.text('Succeeds'), findsOneWidget);
    expect(find.text('Fails'), findsOneWidget);
    expect(find.text('Stays pending'), findsOneWidget);
    await tester.ensureVisible(find.text('Fails'));
    await tester.tap(find.text('Fails'));
    await tester.pumpAndSettle();
    expect(
      container.read(mockDatabaseProvider).nextPayment,
      MockPaymentOutcome.failed,
    );
  });

  testWidgets('a failed payment can be tried again', (tester) async {
    await launch(tester, outcome: MockPaymentOutcome.failed);
    await reachReview(tester);
    await tester.ensureVisible(find.byKey(const Key('order-pay')));
    await tester.tap(find.byKey(const Key('order-pay')));
    await tester.pumpAndSettle();
    expect(find.text('Payment failed'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text("We're confirming your payment. We'll notify you."), findsNothing);
  });

  testWidgets('a pending payment does not offer another charge', (tester) async {
    await launch(
      tester,
      outcome: MockPaymentOutcome.pending,
      poll: const PaymentPoll(interval: Duration.zero, maxAttempts: 0),
    );
    await reachReview(tester);
    await tester.ensureVisible(find.byKey(const Key('order-pay')));
    await tester.tap(find.byKey(const Key('order-pay')));
    await tester.pumpAndSettle();
    expect(
      find.text("We're confirming your payment. We'll notify you."),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsNothing);
  });
}
