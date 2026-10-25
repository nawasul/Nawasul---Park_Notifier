import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/vehicle_catalog.dart';
import '../../../../core/models/alert_item.dart';
import '../../../../core/models/vehicle.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../vehicles/presentation/providers/vehicle_provider.dart';

Future<Vehicle?> showAddVehicleSheet(BuildContext context) {
  return showModalBottomSheet<Vehicle>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const AddVehicleSheet(),
  );
}

class AddVehicleSheet extends ConsumerStatefulWidget {
  const AddVehicleSheet({super.key});

  @override
  ConsumerState<AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends ConsumerState<AddVehicleSheet> {
  final _plate = TextEditingController();
  final _model = TextEditingController();
  final _otherMake = TextEditingController();
  String? _make;
  String? _color;
  var _saving = false;
  String? _plateError;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _plate.addListener(_rebuild);
    _model.addListener(_rebuild);
    _otherMake.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
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

  bool get _valid {
    if (PlateValidator.error(_plate.text) != null) return false;
    if (_make == null) return false;
    if (_make == otherMakeId && _otherMake.text.trim().length < 2) return false;
    if (_model.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> _save() async {
    if (!_valid || _saving) return;
    setState(() {
      _saving = true;
      _plateError = null;
      _formError = null;
    });
    final make = _make == otherMakeId ? _otherMake.text.trim() : _make!;
    try {
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
      Navigator.pop(context, created);
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
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.orderAddVehicle, style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.lg),
              Directionality(
                textDirection: TextDirection.ltr,
                child: AppTextField(
                  key: const Key('sheet-plate'),
                  controller: _plate,
                  label: l10n.vehiclePlate,
                  hint: l10n.vehiclePlateHint,
                  errorText: _plateError,
                  onChanged: (_) => setState(() => _plateError = null),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              InputDecorator(
                decoration: InputDecoration(labelText: l10n.vehicleMake),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    key: const Key('sheet-make'),
                    isExpanded: true,
                    value: _make,
                    hint: Text(l10n.vehicleMake),
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
                ),
              ),
              if (_make == otherMakeId) ...[
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _otherMake,
                  label: l10n.vehicleMakeOther,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                key: const Key('sheet-model'),
                controller: _model,
                label: l10n.vehicleModel,
                hint: l10n.vehicleModel,
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
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: l10n.vehicleSave,
                isLoading: _saving,
                enabled: _valid && !_saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
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
