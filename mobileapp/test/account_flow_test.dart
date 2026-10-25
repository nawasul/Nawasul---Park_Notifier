import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_home_state.dart';
import 'package:mobileapp/core/mock/mock_providers.dart';
import 'package:mobileapp/features/auth/presentation/providers/session_provider.dart';
import 'package:mobileapp/features/orders/presentation/providers/order_providers.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/shared/widgets/destructive_button.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<ProviderContainer> launch(
    WidgetTester tester, {
    MockHomeState homeState = MockHomeState.active,
    void Function(Uri uri)? onOpen,
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
    final container = ProviderContainer(
      overrides: [
        mockDatabaseProvider.overrideWithValue(database),
        urlOpenerProvider.overrideWithValue((uri) async {
          onOpen?.call(uri);
          return true;
        }),
      ],
    );
    addTearDown(container.dispose);
    await tester.binding.setSurfaceSize(const Size(900, 1600));
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

  testWidgets('account rows open and log out returns to the phone screen', (
    tester,
  ) async {
    Uri? opened;
    final container = await launch(tester, onOpen: (uri) => opened = uri);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('Ahmed'), findsWidgets);
    expect(find.text('+966 5X XXX 5678'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit profile'));
    await tester.pumpAndSettle();
    expect(
      find.text('To change your number, contact support.'),
      findsOneWidget,
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('profile-name')),
        matching: find.byType(EditableText),
      ),
      'Sara',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('profile-save')));
    await tester.pumpAndSettle();
    expect(find.text('Sara'), findsWidgets);

    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('pref-marketing')));
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('pref-marketing')),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      container.read(mockDatabaseProvider).user.preferences.marketing,
      isTrue,
    );
    await tester.ensureVisible(find.text('Send test alert'));
    await tester.tap(find.text('Send test alert'));
    await tester.pumpAndSettle();
    expect(find.text('Test alert'), findsOneWidget);
    expect(find.text('Push: Sent'), findsOneWidget);
    expect(find.text('WhatsApp: Sent'), findsOneWidget);
    expect(
      find.text(
        'Alerts may be delayed or missed if your phone is off, muted, or offline.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Help and contact'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('How does it work?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Your number is not shared.'), findsOneWidget);
    await tester.tap(find.text('WhatsApp'));
    await tester.pumpAndSettle();
    expect(opened?.host, 'wa.me');

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Legal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();
    expect(find.text('What we collect'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('My orders'));
    await tester.tap(find.text('My orders'));
    await tester.pumpAndSettle();
    expect(find.text('Toyota Camry'), findsWidgets);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Log out'));
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your number'), findsOneWidget);
  });

  testWidgets('deleting an account keeps invoices and returns to the phone screen', (
    tester,
  ) async {
    final container = await launch(tester, homeState: MockHomeState.inTransit);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Delete account'));
    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    expect(find.textContaining('still on the way'), findsOneWidget);

    await tester.tap(find.widgetWithText(DestructiveButton, 'Delete account'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(DestructiveButton, 'Delete account').last);
    await tester.pumpAndSettle();

    expect(find.text('Enter your number'), findsOneWidget);
    final database = container.read(mockDatabaseProvider);
    expect(database.vehicles, isEmpty);
    expect(database.alerts, isEmpty);
    expect(database.orders, isNotEmpty);
  });
}
