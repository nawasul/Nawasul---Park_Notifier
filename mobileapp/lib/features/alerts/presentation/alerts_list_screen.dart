import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/alert_list_item.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../subscription/presentation/providers/subscription_provider.dart';

class AlertsListScreen extends ConsumerWidget {
  const AlertsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: alerts.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.notifications_none_outlined,
                heading: 'No alerts yet',
                message: 'When someone scans your QR, alerts will appear here.',
              )
            : ListView.separated(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                itemCount: alerts.length + 1,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Text('Alerts', style: AppTypography.headingL);
                  }
                  final alert = alerts[index - 1];
                  return AlertListItem(
                    alert: alert,
                    onTap: () =>
                        context.push(AppRoutes.alertDetail(alert.id)),
                  );
                },
              ),
      ),
    );
  }
}
