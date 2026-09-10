import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Shell tab index for the QR scanner branch.
const kScanTabIndex = 2;

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  static const _items = [
    _NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.qr_code_2_outlined,
      selectedIcon: Icons.qr_code_2_rounded,
      label: 'QR',
    ),
    _NavItem(
      icon: Icons.qr_code_scanner_outlined,
      selectedIcon: Icons.qr_code_scanner_rounded,
      label: 'Scan',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.brandDark,
      child: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.brandDark,
            border: Border(
              top: BorderSide(
                color: AppColors.onPrimary.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 4),
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isSelected = selectedIndex == index;
                return Expanded(
                  child: _NavBarItem(
                    item: item,
                    isSelected: isSelected,
                    onTap: () => onItemSelected(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? AppColors.primary : AppColors.textOnDarkSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? item.selectedIcon : item.icon,
                size: 23,
                color: color,
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: AppTypography.caption.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 11,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
