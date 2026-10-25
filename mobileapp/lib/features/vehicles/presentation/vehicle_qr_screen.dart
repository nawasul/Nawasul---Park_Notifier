import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/mock/mock_seed.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../home/presentation/providers/garage_provider.dart';
import 'providers/vehicle_provider.dart';
import 'vehicle_protection.dart';

class VehicleQrScreen extends ConsumerStatefulWidget {
  const VehicleQrScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<VehicleQrScreen> createState() => _VehicleQrScreenState();
}

class _VehicleQrScreenState extends ConsumerState<VehicleQrScreen> {
  String? _error;

  Future<void> _preview(String url) async {
    setState(() => _error = null);
    final uri = Uri.parse(url);
    try {
      final opened = await launchUrl(
        uri,
        mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.inAppBrowserView,
      );
      if (!opened && mounted) {
        setState(() => _error = AppLocalizations.of(context).errorGenericBody);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).errorGenericBody);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vehicles = ref.watch(vehicleProvider);
    final orders = ref.watch(ordersProvider);
    final now = ref.watch(clockProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.homeMyQr, style: AppTypography.headingM),
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(AppIcons.caretLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: vehicles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(onRetry: () => ref.invalidate(vehicleProvider)),
        data: (items) {
          final match = items.where((item) => item.id == widget.id);
          if (match.isEmpty) return ErrorState(message: l10n.vehicleNotFound);
          final vehicle = match.first;
          final view = protectionView(
            vehicle: vehicle,
            orders: orders.value ?? const [],
            now: now,
          );
          final url = qrUrlFor(vehicle.qrCode);
          final inactive = view.state == ProtectionState.noSticker ||
              view.state == ProtectionState.paymentPending;
          return ListView(
            padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
            children: [
              Text(
                vehicle.displayName,
                style: AppTypography.headingL,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Container(
                  color: AppColors.surface,
                  padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                  child: QrImageView(
                    data: url,
                    size: 220,
                    backgroundColor: AppColors.surface,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: AppColors.textPrimary,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                vehicle.shortCode,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: AppTypography.headingM,
              ),
              if (inactive) ...[
                const SizedBox(height: AppSpacing.lg),
                InfoBanner(message: l10n.qrInactive),
              ],
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  _error!,
                  style: AppTypography.bodyM.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: l10n.qrPreview,
                onPressed: () => _preview(url),
              ),
            ],
          );
        },
      ),
    );
  }
}
