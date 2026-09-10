import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _navigateToOnboarding);
  }

  void _navigateToOnboarding() {
    if (!mounted) return;
    context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Static flat tint — no gradient, no blur filter.
          const Positioned(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
                boxShadow: AppShadows.iconCircle,
              ),
              child: SizedBox(width: 280, height: 280),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: AppLogoSize.large, showTagline: false)
                  .animate()
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: AppSpacing.md),
              DefaultTextStyle(
                style: AppTypography.caption.copyWith(
                  letterSpacing: 3,
                  color: AppColors.primary,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      'WE CONNECT',
                      duration: const Duration(milliseconds: 1200),
                    ),
                  ],
                  totalRepeatCount: 1,
                  isRepeatingAnimation: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
