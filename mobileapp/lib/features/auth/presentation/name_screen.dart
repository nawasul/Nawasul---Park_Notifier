import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/saudi_cities.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../features/account/data/account_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/city_select_field.dart';
import '../../../shared/widgets/primary_button.dart';
import 'providers/session_provider.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  final _name = TextEditingController();
  String? _city;
  var _cityFocused = false;
  var _loading = false;
  var _showError = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _valid {
    final length = _name.text.trim().length;
    return length >= 2 && length <= 50;
  }

  Future<void> _submit() async {
    if (!_valid || _loading) {
      setState(() => _showError = true);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(accountRepositoryProvider).updateMe(
            name: _name.text.trim(),
            city: _city,
          );
      await ref.read(sessionProvider.notifier).completeProfile();
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).errorGenericBody);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = {
      for (final id in saudiCityIds) id: saudiCityLabel(l10n, id),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
          children: [
            Text(l10n.nameTitle, style: AppTypography.headingL),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _name,
              label: l10n.nameLabel,
              hint: l10n.nameHint,
              textInputAction: TextInputAction.done,
              errorText: _showError && !_valid ? l10n.nameInvalid : _error,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.cityLabel, style: AppTypography.bodyM),
            const SizedBox(height: AppSpacing.sm),
            CitySelectField(
              cities: saudiCityIds,
              labels: labels,
              selectedCity: _city,
              hint: l10n.cityHint,
              isFocused: _cityFocused,
              onFocusChange: (focused) => setState(() => _cityFocused = focused),
              onChanged: (value) => setState(() => _city = value),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: l10n.actionContinue,
              isLoading: _loading,
              enabled: _valid && !_loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
