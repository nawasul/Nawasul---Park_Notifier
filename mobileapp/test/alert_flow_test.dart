import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobileapp/core/mock/mock_database.dart';
import 'package:mobileapp/core/mock/mock_home_state.dart';
import 'package:mobileapp/core/mock/mock_providers.dart';
import 'package:mobileapp/core/notifications/notification_providers.dart';
import 'package:mobileapp/core/notifications/notification_service.dart';
import 'package:mobileapp/features/auth/presentation/providers/session_provider.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/shared/widgets/destructive_button.dart';
import 'package:mobileapp/shared/widgets/primary_button.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<({ProviderContainer container, FakeNotificationService alerts})> launch(
    WidgetTester tester, {
    MockHomeState homeState = MockHomeState.active,
    Uri? link,
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
    final fake = FakeNotificationService();
    final container = ProviderContainer(
      overrides: [
        mockDatabaseProvider.overrideWithValue(database),
        notificationServiceProvider.overrideWith((ref) {
          ref.onDispose(fake.dispose);
          return fake;
        }),
        if (link != null)
          incomingLinkProvider.overrideWith((ref) async => link),
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
    return (container: container, alerts: fake);
  }

  testWidgets('home and the alerts list show the same alerts', (tester) async {
    final harness = await launch(tester);
    expect(find.text('Blocking another car'), findsOneWidget);
    expect(find.text('Order update'), findsOneWidget);

    await tester.tap(find.text('See all'));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Push · Delivered'), findsWidgets);

    await tester.tap(find.text('Blocking another car').last);
    await tester.pumpAndSettle();
    expect(find.text("I'm coming"), findsOneWidget);
    expect(find.text('Stop alarm'), findsNothing);
    expect(
      find.text(
        'Alerts may be delayed or missed if your phone is off, muted, or offline.',
      ),
      findsOneWidget,
    );
    final stored = harness.container
        .read(mockDatabaseProvider)
        .alerts
        .firstWhere((alert) => alert.id == 'alert-001');
    expect(stored.isRead, isTrue);
  });

  testWidgets('coming and spam update the alert', (tester) async {
    await launch(tester);
    await tester.tap(find.text('See all'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Blocking another car').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text("I'm coming"));
    await tester.pumpAndSettle();
    expect(find.text("You told them you're coming."), findsOneWidget);
    final button = tester.widget<PrimaryButton>(
      find.widgetWithText(PrimaryButton, "I'm coming"),
    );
    expect(button.enabled, isFalse);

    await tester.tap(find.text('Report as spam'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(DestructiveButton, 'Report'));
    await tester.pumpAndSettle();
    expect(find.text('Blocking another car'), findsNothing);
    expect(find.text('Order update'), findsOneWidget);
  });

  testWidgets('a simulated alert can stop the alarm', (tester) async {
    final harness = await launch(tester);
    await tester.tap(find.text('Alerts'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Simulate alert'));
    await tester.pumpAndSettle();

    expect(find.text('Lights left on'), findsOneWidget);
    expect(find.text('Stop alarm'), findsOneWidget);
    expect(harness.alerts.shown, 1);
    await tester.tap(find.text('Stop alarm'));
    await tester.pumpAndSettle();
    expect(find.text('Stop alarm'), findsNothing);
    expect(harness.alerts.stopped, ['alert-101']);
  });

  testWidgets('a cold alert link opens that alert', (tester) async {
    await launch(tester, link: Uri.parse('nawasul://alerts/alert-001'));
    expect(find.text('Blocking another car'), findsWidgets);
    expect(find.text("I'm coming"), findsOneWidget);
  });

  testWidgets('a notification tap opens that alert', (tester) async {
    final harness = await launch(tester);
    expect(find.text('Good morning, Ahmed'), findsOneWidget);
    harness.alerts.taps.add(const NotificationEvent(alertId: 'alert-001'));
    await tester.pumpAndSettle();
    expect(find.text("I'm coming"), findsOneWidget);
  });

  testWidgets('an empty list says there are no alerts', (tester) async {
    await launch(tester, homeState: MockHomeState.emptyAlerts);
    await tester.tap(find.text('Alerts'));
    await tester.pumpAndSettle();
    expect(find.text('No alerts yet.'), findsOneWidget);
  });
}

class FakeNotificationService implements NotificationService {
  final taps = StreamController<NotificationEvent>.broadcast();
  final stopped = <String>[];
  var shown = 0;

  @override
  Stream<NotificationEvent> get onTap => taps.stream;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getPushToken() async => null;

  @override
  Future<void> showAlarmAlert(AlertPayload payload) async {
    shown += 1;
  }

  @override
  Future<void> stopAlarm(String alertId) async {
    stopped.add(alertId);
  }

  @override
  Future<bool> openSystemSettings() async => false;

  @override
  Future<bool> loudAlertsReady() async => false;

  void dispose() {
    taps.close();
  }
}
