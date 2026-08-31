import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_vehicles.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/alert_list_item.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/outline_button.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../subscription/presentation/providers/subscription_provider.dart';
import 'providers/vehicle_provider.dart';

class VehicleDetailsScreen extends ConsumerWidget {
  const VehicleDetailsScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(vehicleByIdProvider(vehicleId));
    final alerts = ref.watch(alertsForVehicleProvider(vehicleId));

    if (vehicle == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Vehicle not found')),
      );
    }

    final statusLabel = vehicle.qrStatus == QrStatus.active
        ? 'QR Active'
        : 'Sticker Pending';
    final statusVariant = vehicle.qrStatus == QrStatus.active
        ? StatusPillVariant.active
        : StatusPillVariant.pending;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                context.push(AppRoutes.vehicleEdit(vehicleId)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                ),
                child: const Icon(
                  Icons.directions_car,
                  size: 72,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '${vehicle.make} ${vehicle.model}',
                style: AppTypography.headingL,
              ),
              Text(vehicle.plateNumber, style: AppTypography.bodyM),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('QR Status', style: AppTypography.bodyL),
                    StatusPill(label: statusLabel, variant: statusVariant),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Alert History', style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.md),
              if (alerts.isEmpty)
                Text('No alerts for this vehicle.', style: AppTypography.bodyM)
              else
                ...alerts.map(
                  (a) => Padding(
                    padding: const EdgeInsetsDirectional.only(
                      bottom: AppSpacing.md,
                    ),
                    child: AlertListItem(
                      alert: a,
                      onTap: () =>
                          context.push(AppRoutes.alertDetail(a.id)),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'View QR Code',
                onPressed: () =>
                    context.push(AppRoutes.vehicleQr(vehicleId)),
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: 'Edit Vehicle',
                onPressed: () =>
                    context.push(AppRoutes.vehicleEdit(vehicleId)),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlineButton(
                label: 'Delete Vehicle',
                onPressed: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context,
                    title: 'Delete Vehicle',
                    message:
                        'Are you sure you want to delete ${vehicle.make} ${vehicle.model}?',
                    confirmLabel: 'Delete',
                    isDestructive: true,
                  );
                  if (confirmed == true && context.mounted) {
                    ref
                        .read(vehicleProvider.notifier)
                        .deleteVehicle(vehicleId);
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
