import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'app_card.dart';
import 'status_pill.dart';

class OrderRow extends StatelessWidget {
  const OrderRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.statusVariant,
    required this.dateLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String statusLabel;
  final StatusPillVariant statusVariant;
  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headingM),
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle, style: AppTypography.bodyM),
                if (dateLabel.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(dateLabel, style: AppTypography.caption),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusPill(label: statusLabel, variant: statusVariant),
        ],
      ),
    );
  }
}
