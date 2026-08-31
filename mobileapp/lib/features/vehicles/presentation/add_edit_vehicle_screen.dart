import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_vehicles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import 'providers/vehicle_provider.dart';

class AddEditVehicleScreen extends ConsumerStatefulWidget {
  const AddEditVehicleScreen({super.key, this.vehicleId});

  final String? vehicleId;

  bool get isEditMode => vehicleId != null;

  @override
  ConsumerState<AddEditVehicleScreen> createState() =>
      _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends ConsumerState<AddEditVehicleScreen> {
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _plateController;
  late final TextEditingController _colorController;
  bool _photoSelected = false;
  bool _isLoading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController();
    _modelController = TextEditingController();
    _plateController = TextEditingController();
    _colorController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && widget.vehicleId != null) {
      final existing =
          ref.read(vehicleProvider.notifier).getById(widget.vehicleId!);
      if (existing != null) {
        _makeController.text = existing.make;
        _modelController.text = existing.model;
        _plateController.text = existing.plateNumber;
        _colorController.text = existing.color;
        _photoSelected = existing.photoSelected;
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final notifier = ref.read(vehicleProvider.notifier);
    if (widget.isEditMode) {
      final existing = notifier.getById(widget.vehicleId!);
      if (existing != null) {
        notifier.updateVehicle(existing.copyWith(
          make: _makeController.text,
          model: _modelController.text,
          plateNumber: _plateController.text,
          color: _colorController.text,
          photoSelected: _photoSelected,
        ));
      }
    } else {
      notifier.addVehicle(Vehicle(
        id: 'veh-${DateTime.now().millisecondsSinceEpoch}',
        make: _makeController.text,
        model: _modelController.text,
        plateNumber: _plateController.text,
        color: _colorController.text,
        qrStatus: QrStatus.stickerPending,
        photoSelected: _photoSelected,
      ));
    }

    setState(() => _isLoading = false);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'Edit Vehicle' : 'Add Vehicle',
          style: AppTypography.headingM,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => setState(() => _photoSelected = !_photoSelected),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: _photoSelected
                        ? AppColors.accentSoft
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: AppColors.borderSubtle,
                      width: _photoSelected ? 2 : 1,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: _photoSelected
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.success, size: 32),
                            const SizedBox(height: AppSpacing.sm),
                            Text('Photo selected',
                                style: AppTypography.bodyM),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined,
                                color: AppColors.textMuted, size: 32),
                            const SizedBox(height: AppSpacing.sm),
                            Text('Tap to add photo',
                                style: AppTypography.bodyM),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Make',
                      hint: 'e.g. Toyota',
                      controller: _makeController,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Model',
                      hint: 'e.g. Camry',
                      controller: _modelController,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Plate Number',
                      hint: 'e.g. ABC 1234',
                      controller: _plateController,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Color',
                      hint: 'e.g. White',
                      controller: _colorController,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: widget.isEditMode ? 'Save Changes' : 'Add Vehicle',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
