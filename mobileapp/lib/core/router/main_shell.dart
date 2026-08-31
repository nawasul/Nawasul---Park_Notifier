import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Color(0x0F0F172A),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: GNav(
          selectedIndex: navigationShell.currentIndex,
          onTabChange: navigationShell.goBranch,
          gap: AppSpacing.sm,
          activeColor: AppColors.primary,
          color: AppColors.textMuted,
          iconSize: 22,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          tabBackgroundColor: AppColors.accentSoft,
          tabs: const [
            GButton(icon: Icons.home_outlined, text: 'Home'),
            GButton(icon: Icons.directions_car_outlined, text: 'Vehicles'),
            GButton(icon: Icons.qr_code_2_outlined, text: 'My QR'),
            GButton(icon: Icons.notifications_outlined, text: 'Alerts'),
            GButton(icon: Icons.person_outline, text: 'Account'),
          ],
        ),
      ),
    );
  }
}
