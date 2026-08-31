import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/onboarding_slide.dart';
import '../../../shared/widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    (
      icon: Icons.directions_car_outlined,
      heading: 'Register your vehicle',
      subheading:
          'Add your car details and get a unique QR code linked to your account.',
    ),
    (
      icon: Icons.qr_code_2_outlined,
      heading: 'Get your QR sticker',
      subheading:
          'Receive a durable QR sticker to place on your vehicle windshield.',
    ),
    (
      icon: Icons.notifications_active_outlined,
      heading: 'Get notified privately',
      subheading:
          'When someone scans your QR, you get notified instantly. Your phone number is never shared.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _navigateToLanguage();
    }
  }

  void _navigateToLanguage() {
    context.go(AppRoutes.language);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: AppSpacing.sm,
                end: AppSpacing.sm,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: _navigateToLanguage,
                  child: Text(
                    'Skip',
                    style: AppTypography.link.copyWith(
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return AnimationLimiter(
                    child: AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 20,
                        child: FadeInAnimation(
                          child: OnboardingSlide(
                            key: ValueKey(index),
                            icon: slide.icon,
                            heading: slide.heading,
                            subheading: slide.subheading,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    width: isActive ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.borderSubtle,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: PrimaryButton(
                label: isLastPage ? 'Get Started' : 'Next',
                onPressed: _onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
