import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/saudi_cities.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/city_select_field.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../../orders/presentation/providers/order_draft.dart';
import '../data/account_repository.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _name = TextEditingController();
  final _phoneField = TextEditingController();
  String? _city;
  var _cityFocused = false;
  var _filled = false;
  var _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _phoneField.dispose();
    super.dispose();
  }

  bool get _valid {
    final length = _name.text.trim().length;
    return length >= 2 && length <= 50;
  }

  Future<void> _save() async {
    if (!_valid || _loading) return;
    setState(() => _loading = true);
    try {
      await ref.read(accountRepositoryProvider).updateMe(
            name: _name.text.trim(),
            city: _city,
          );
      ref.invalidate(currentUserProvider);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final labels = {
      for (final id in saudiCityIds) id: saudiCityLabel(l10n, id),
    };

    return AppScaffold(
      title: l10n.accountEdit,
      body: user.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(
          onRetry: () => ref.invalidate(currentUserProvider),
        ),
        data: (me) {
          if (!_filled) {
            _filled = true;
            _name.text = me.name;
            _phoneField.text = me.phone;
            _city = cityIdFor(me.city);
          }
          return ListView(
            children: [
              AppTextField(
                key: const Key('profile-name'),
                controller: _name,
                label: l10n.nameLabel,
                onChanged: (_) => setState(() {}),
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
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: l10n.orderPhone,
                controller: _phoneField,
                readOnly: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.accountPhoneLocked,
                style: AppTypography.caption,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                key: const Key('profile-save'),
                label: l10n.vehicleSave,
                isLoading: _loading,
                enabled: _valid && !_loading,
                onPressed: _save,
              ),
            ],
          );
        },
      ),
    );
  }
}
