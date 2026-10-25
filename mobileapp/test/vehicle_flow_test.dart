import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_home_state.dart';
import 'package:mobileapp/core/mock/mock_providers.dart';
import 'package:mobileapp/features/auth/presentation/providers/session_provider.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/shared/widgets/primary_button.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('add, edit, and delete a vehicle from home', (tester) async {
    SharedPreferences.setMockInitialValues({
      'app_language': 'en',
      SessionNotifier.authenticatedKey: true,
      SessionNotifier.onboardingKey: true,
      SessionNotifier.newUserKey: false,
      SessionNotifier.profileKey: true,
      SessionNotifier.alertsKey: true,
    });
    final container = ProviderContainer(
      overrides: [
        mockDatabaseProvider.overrideWithValue(
          MockDatabase(
            homeState: MockHomeState.noVehicle,
            delay: Duration.zero,
            now: DateTime(2026, 6, 15, 9),
          ),
        ),
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

    expect(find.text('Add your first vehicle'), findsOneWidget);
    await tester.tap(find.text('Add vehicle').first);
    await tester.pumpAndSettle();

    Future<void> fill(Key key, String value) {
      return tester.enterText(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(EditableText),
        ),
        value,
      );
    }

    await fill(const Key('vehicle-plate'), 'KSA 9090');
    await tester.tap(find.byKey(const Key('vehicle-make')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Toyota').last);
    await tester.pumpAndSettle();
    await fill(const Key('vehicle-model'), 'Yaris');
    await tester.pump();
    await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Save'));
    await tester.tap(find.widgetWithText(PrimaryButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Order a sticker to protect this car.'), findsOneWidget);
    expect(find.text('KSA 9090'), findsWidgets);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Toyota Yaris'), findsWidgets);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Toyota Yaris'), findsWidgets);
    expect(find.text('Not protected yet'), findsWidgets);

    await tester.tap(find.text('Vehicles'));
    await tester.pumpAndSettle();
    expect(find.text('KSA 9090'), findsWidgets);
    await tester.tap(find.text('Toyota Yaris'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('vehicle-plate')),
        matching: find.byType(EditableText),
      ),
      'KSA 1111',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('KSA 1111'), findsWidgets);

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('No vehicles yet'), findsOneWidget);
  });

  testWidgets('the debug switcher shows each hero state', (tester) async {
    SharedPreferences.setMockInitialValues({
      'app_language': 'en',
      SessionNotifier.authenticatedKey: true,
      SessionNotifier.onboardingKey: true,
      SessionNotifier.newUserKey: false,
      SessionNotifier.profileKey: true,
      SessionNotifier.alertsKey: true,
    });
    final container = ProviderContainer(
      overrides: [
        mockDatabaseProvider.overrideWithValue(
          MockDatabase(delay: Duration.zero, now: DateTime(2026, 6, 15, 9)),
        ),
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
    expect(find.text('Protected'), findsWidgets);

    await tester.tap(find.byTooltip('States'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('No sticker'));
    await tester.tap(find.text('No sticker'));
    await tester.pumpAndSettle();
    expect(find.text('Not protected yet'), findsWidgets);

    await tester.tap(find.byTooltip('States'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('No alerts'));
    await tester.tap(find.text('No alerts'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('No alerts yet.'), 200);
    expect(find.text('No alerts yet.'), findsOneWidget);
  });
}
