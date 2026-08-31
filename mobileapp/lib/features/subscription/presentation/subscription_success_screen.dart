import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/icon_badge.dart';
import '../../../shared/widgets/primary_button.dart';

class SubscriptionSuccessScreen extends StatefulWidget {
  const SubscriptionSuccessScreen({super.key});

  @override
  State<SubscriptionSuccessScreen> createState() =>
      _SubscriptionSuccessScreenState();
}

class _SubscriptionSuccessScreenState extends State<SubscriptionSuccessScreen> {
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) setState(() => _scale = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                child: const IconBadge(
                  icon: Icons.check_rounded,
                  size: 96,
                  iconSize: 48,
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Subscription Active!',
                style: AppTypography.headingL,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your plan has been updated successfully.',
                style: AppTypography.bodyM,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              PrimaryButton(
                label: 'Back to Home',
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
