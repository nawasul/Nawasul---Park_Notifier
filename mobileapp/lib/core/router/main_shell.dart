import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/providers/garage_provider.dart';
import '../../shared/widgets/app_bottom_nav_bar.dart';
import '../theme/app_colors.dart';
import 'app_routes.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branch = navigationShell.currentIndex;
    final selectedSlot = const [0, 1, 3, 4][branch];
    final unread = ref.watch(alertsProvider).value?.any((alert) => !alert.isRead) ?? false;

    return PopScope(
      canPop: branch == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        navigationShell.goBranch(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: navigationShell,
        bottomNavigationBar: AppBottomNavBar(
          selectedSlot: selectedSlot,
          showAlertsDot: unread,
          onSlotSelected: (slot) {
            if (slot == 2) {
              context.push(AppRoutes.orderVehicle);
              return;
            }
            navigationShell.goBranch(const [0, 1, 0, 2, 3][slot]);
          },
        ),
      ),
    );
  }
}
