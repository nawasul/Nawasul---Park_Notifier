import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../network/live_repositories.dart';
import '../network/network_providers.dart';
import '../router/app_router.dart';
import 'deep_link.dart';
import 'link_bridge.dart';
import 'noop_notification_service.dart';
import 'notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NoopNotificationService();
  ref.onDispose(service.dispose);
  return service;
});

/// Alert ids whose alarm was stopped in this session.
final stoppedAlarmsProvider = StateProvider<Set<String>>((ref) => const {});

final incomingLinkProvider = FutureProvider<Uri?>((ref) => LinkBridge.initial());

class NotificationBindings extends ConsumerStatefulWidget {
  const NotificationBindings({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationBindings> createState() =>
      _NotificationBindingsState();
}

class _NotificationBindingsState extends ConsumerState<NotificationBindings> {
  StreamSubscription<NotificationEvent>? _taps;

  @override
  void initState() {
    super.initState();
    LinkBridge.listen(_open);
    _taps = ref.read(notificationServiceProvider).onTap.listen((event) {
      _open(Uri(scheme: 'nawasul', host: 'alerts', path: '/${event.alertId}'));
    });
    _registerDevice();
  }

  Future<void> _registerDevice() async {
    if (AppConfig.useMock) return;
    final token = await ref.read(notificationServiceProvider).getPushToken();
    if (token == null || token.isEmpty) return;
    try {
      await registerDevice(
        ref.read(apiClientProvider),
        token: token,
        platform: defaultTargetPlatform.name,
        locale: WidgetsBinding.instance.platformDispatcher.locale.languageCode,
      );
    } on Object {
      // The next launch tries again.
    }
  }

  void _open(Uri uri) {
    final path = locationForDeepLink(uri);
    if (path == null || !mounted) return;
    ref.read(appRouterProvider).go(path);
  }

  @override
  void dispose() {
    _taps?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
