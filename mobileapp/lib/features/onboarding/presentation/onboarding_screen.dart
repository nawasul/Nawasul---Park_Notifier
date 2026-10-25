import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../features/auth/presentation/providers/session_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/icon_badge.dart';
import '../../../shared/widgets/language_toggle.dart';
import '../../../shared/widgets/primary_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  var _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(sessionProvider.notifier).completeOnboarding();
    if (mounted) context.go(AppRoutes.phone);
  }

  void _next(int count) {
    if (_index >= count - 1) {
      _finish();
      return;
    }
    final next = _index + 1;
    if (MediaQuery.disableAnimationsOf(context)) {
      _page.jumpToPage(next);
    } else {
      _page.animateToPage(
        next,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = [
      _Slide(AppIcons.car, l10n.onboardingTitle1, l10n.onboardingBody1),
      _Slide(AppIcons.qrCode, l10n.onboardingTitle2, l10n.onboardingBody2),
      _Slide(AppIcons.bell, l10n.onboardingTitle3, l10n.onboardingBody3),
    ];
    final last = _index == slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const LanguageToggle(),
                  const Spacer(),
                  TextButton(
                    onPressed: _finish,
                    child: Text(l10n.actionSkip),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _page,
                  itemCount: slides.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) => _SlideView(slide: slides[index]),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _PageDots(count: slides.length, index: _index),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: last ? l10n.actionGetStarted : l10n.actionNext,
                onPressed: () => _next(slides.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconBadge(icon: slide.icon, size: 96, iconSize: 40),
        const SizedBox(height: AppSpacing.xl),
        Text(
          slide.title,
          style: AppTypography.headingL,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          slide.body,
          style: AppTypography.bodyL.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index ? AppColors.primary : AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ],
      ],
    );
  }
}
