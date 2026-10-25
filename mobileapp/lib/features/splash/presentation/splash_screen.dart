import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/notifications/deep_link.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../features/auth/presentation/providers/session_provider.dart';
import '../../../shared/widgets/app_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;
  var _left = false;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    if (!mounted) return;
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce) {
      _fade.value = 1;
    } else {
      _fade.forward();
    }
    final session = await ref.read(sessionProvider.future);
    final link = await ref.read(incomingLinkProvider.future);
    if (!reduce) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
    if (!mounted || _left) return;
    _left = true;
    final path = link == null ? null : locationForDeepLink(link);
    if (session.isAuthenticated && path != null) {
      context.go(path);
      return;
    }
    context.go(destinationFor(session));
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: const AppLogo(showTagline: false),
        ),
      ),
    );
  }
}
