import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/thin_progress_bar.dart';

class OrderStepHeader extends StatelessWidget {
  const OrderStepHeader({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.orderStep(step), style: AppTypography.caption),
        const SizedBox(height: AppSpacing.sm),
        ThinProgressBar(
          value: step / 3,
          color: AppColors.primary,
          track: AppColors.surfaceContainer,
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
