import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

/// Five slots. Index 2 is the raised order button, not a shell branch.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.selectedSlot,
    required this.onSlotSelected,
    this.showAlertsDot = false,
  });

  final int selectedSlot;
  final ValueChanged<int> onSlotSelected;
  final bool showAlertsDot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      _Slot(0, AppIcons.house, AppIcons.houseFill, l10n.navHome),
      _Slot(1, AppIcons.car, AppIcons.carFill, l10n.navVehicles),
      _Slot(3, AppIcons.bell, AppIcons.bellFill, l10n.navAlerts),
      _Slot(4, AppIcons.user, AppIcons.userFill, l10n.navAccount),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.navBar,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Expanded(child: _item(items[0])),
                    Expanded(child: _item(items[1])),
                    const SizedBox(width: 72),
                    Expanded(child: _item(items[2], showDot: showAlertsDot)),
                    Expanded(child: _item(items[3])),
                  ],
                ),
              ),
              PositionedDirectional(
                top: -18,
                child: _OrderButton(
                  label: l10n.navOrderSticker,
                  onPressed: () => onSlotSelected(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(_Slot slot, {bool showDot = false}) {
    final selected = selectedSlot == slot.index;
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return Semantics(
      button: true,
      selected: selected,
      label: slot.label,
      child: InkWell(
        onTap: () => onSlotSelected(slot.index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  selected ? slot.selected : slot.icon,
                  color: color,
                  size: 24,
                ),
                if (showDot)
                  const PositionedDirectional(
                    top: -2,
                    end: -2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(width: 8, height: 8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              slot.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slot {
  const _Slot(this.index, this.icon, this.selected, this.label);

  final int index;
  final IconData icon;
  final IconData selected;
  final String label;
}

class _OrderButton extends StatelessWidget {
  const _OrderButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 0,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Ink(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primary,
              boxShadow: AppShadows.button,
            ),
            child: const Icon(
              AppIcons.plus,
              color: AppColors.onPrimary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
