import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';

class MyQrCodeScreen extends ConsumerWidget {
  const MyQrCodeScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(vehicleByIdProvider(vehicleId));

    if (vehicle == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Vehicle not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My QR Code', style: AppTypography.headingM),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: vehicle.id,
                      size: 220,
                      backgroundColor: AppColors.surface,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.primary,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.primary,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      child: Divider(color: AppColors.borderSubtle),
                    ),
                    Text(
                      '${vehicle.make} ${vehicle.model}',
                      style: AppTypography.headingM,
                    ),
                    Text(vehicle.plateNumber, style: AppTypography.bodyM),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Share',
                onPressed: () {
                  debugPrint('Share QR for ${vehicle.id}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share link copied (mock)')),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: 'Download',
                onPressed: () {
                  debugPrint('Download QR for ${vehicle.id}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QR saved (mock)')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
