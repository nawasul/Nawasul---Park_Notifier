import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../../shared/widgets/app_bottom_nav_bar.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isScannerTab = navigationShell.currentIndex == kScanTabIndex;

    return Scaffold(
      backgroundColor: AppColors.brandDark,
      body: navigationShell,
      bottomNavigationBar: isScannerTab
          ? null
          : AppBottomNavBar(
              selectedIndex: navigationShell.currentIndex,
              onItemSelected: navigationShell.goBranch,
            ),
    );
  }
}
