import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/vehicle_catalog.dart';
import '../../../core/models/alert_item.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/primary_button.dart';
import 'providers/vehicle_provider.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  const VehicleFormScreen({super.key, this.vehicleId});

  final String? vehicleId;

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _plate = TextEditingController();
  final _model = TextEditingController();
  final _otherMake = TextEditingController();
  String? _make;
  String? _color;
  var _loading = false;
  var _ready = false;
  String? _plateError;
  String? _formError;

  bool get _editing => widget.vehicleId != null;
  var _filling = false;

  @override
  void initState() {
    super.initState();
    _plate.addListener(_rebuild);
    _model.addListener(_rebuild);
    _otherMake.addListener(_rebuild);
  }

  void _rebuild() {
    if (!mounted || _filling) return;
    setState(() {});
  }

  @override
  void dispose() {
    _plate.removeListener(_rebuild);
    _model.removeListener(_rebuild);
    _otherMake.removeListener(_rebuild);
    _plate.dispose();
    _model.dispose();
    _otherMake.dispose();
    super.dispose();
  }

  void _fill(Vehicle vehicle) {
    if (_ready) return;
    _ready = true;
    _filling = true;
    _plate.text = vehicle.plate;
    _model.text = vehicle.model;
    if (vehicleMakes.contains(vehicle.make)) {
      _make = vehicle.make;
    } else {
      _make = otherMakeId;
      _otherMake.text = vehicle.make;
    }
    _color = vehicle.color?.toLowerCase();
    _filling = false;
  }

  bool get _valid {
    if (PlateValidator.error(_plate.text) != null) return false;
    if (_make == null) return false;
    if (_make == otherMakeId && _otherMake.text.trim().length < 2) return false;
    if (_model.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> _save(Vehicle? existing) async {
    if (!_valid || _loading) {
      setState(() {
        _plateError = PlateValidator.error(_plate.text);
        _formError = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _plateError = null;
      _formError = null;
    });
    final make = _make == otherMakeId ? _otherMake.text.trim() : _make!;
    try {
      if (existing == null) {
        final created = await ref.read(vehicleProvider.notifier).addVehicle(
              Vehicle(
                id: '',
                plate: _plate.text.trim(),
                make: make,
                model: _model.text.trim(),
                color: _color,
                qrCode: '',
                shortCode: '',
              ),
            );
        if (!mounted) return;
        context.go('${AppRoutes.vehicle(created.id)}?added=1');
      } else {
        await ref.read(vehicleProvider.notifier).updateVehicle(
              existing.copyWith(
                plate: _plate.text.trim(),
                make: make,
                model: _model.text.trim(),
                color: _color,
                clearColor: _color == null,
              ),
            );
        if (!mounted) return;
        context.pop();
      }
    } on AppException catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        _plateError = error.code == 'duplicate_plate' ? l10n.vehicleDuplicate : null;
        _formError = error.code == 'duplicate_plate' ? null : l10n.errorGenericBody;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _formError = AppLocalizations.of(context).errorGenericBody);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final existing = _editing
        ? ref.watch(vehicleProvider).value?.where((item) {
            return item.id == widget.vehicleId;
          }).firstOrNull
        : null;
    if (existing != null && !_ready) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_ready) setState(() => _fill(existing));
      });
    }
    if (_editing && ref.watch(vehicleProvider).isLoading) {
      return const AppScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_editing && existing == null && ref.watch(vehicleProvider).hasValue) {
      return AppScaffold(body: ErrorState(message: l10n.vehicleNotFound));
    }

    return AppScaffold(
      title: _editing ? l10n.vehicleEdit : l10n.homeAddVehicle,
      body: ListView(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: AppTextField(
              key: const Key('vehicle-plate'),
              controller: _plate,
              label: l10n.vehiclePlate,
              hint: l10n.vehiclePlateHint,
              errorText: _plateError == 'required' || _plateError == 'invalid'
                  ? l10n.vehiclePlateHint
                  : _plateError,
              onChanged: (_) => setState(() => _plateError = null),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            key: const Key('vehicle-make'),
            initialValue: _make,
            decoration: InputDecoration(labelText: l10n.vehicleMake),
            items: [
              for (final make in vehicleMakes)
                DropdownMenuItem(value: make, child: Text(make)),
              DropdownMenuItem(
                value: otherMakeId,
                child: Text(l10n.vehicleMakeOther),
              ),
            ],
            onChanged: (value) => setState(() => _make = value),
          ),
          if (_make == otherMakeId) ...[
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _otherMake,
              label: l10n.vehicleMakeOther,
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            key: const Key('vehicle-model'),
            controller: _model,
            label: l10n.vehicleModel,
            hint: l10n.vehicleModel,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.vehicleColor, style: AppTypography.bodyM),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final id in vehicleColorIds)
                ChoiceChip(
                  label: Text(_colorLabel(l10n, id)),
                  selected: _color == id,
                  onSelected: (selected) {
                    setState(() => _color = selected ? id : null);
                  },
                ),
            ],
          ),
          if (_formError != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _formError!,
              style: AppTypography.bodyM.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l10n.vehicleSave,
            isLoading: _loading,
            enabled: _valid && !_loading,
            onPressed: () => _save(existing),
          ),
        ],
      ),
    );
  }
}

String _colorLabel(AppLocalizations l10n, String id) {
  return switch (id) {
    'white' => l10n.colorWhite,
    'black' => l10n.colorBlack,
    'silver' => l10n.colorSilver,
    'gray' => l10n.colorGray,
    'blue' => l10n.colorBlue,
    'red' => l10n.colorRed,
    'green' => l10n.colorGreen,
    'beige' => l10n.colorBeige,
    _ => id,
  };
}
