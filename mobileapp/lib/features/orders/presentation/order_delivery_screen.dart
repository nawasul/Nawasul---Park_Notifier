import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/saudi_cities.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/city_select_field.dart';
import '../../../shared/widgets/primary_button.dart';
import 'providers/order_draft.dart';
import 'providers/order_providers.dart';
import 'widgets/order_step_header.dart';

class OrderDeliveryScreen extends ConsumerStatefulWidget {
  const OrderDeliveryScreen({super.key});

  @override
  ConsumerState<OrderDeliveryScreen> createState() => _OrderDeliveryScreenState();
}

class _OrderDeliveryScreenState extends ConsumerState<OrderDeliveryScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _street = TextEditingController();
  final _district = TextEditingController();
  final _building = TextEditingController();
  final _shortAddress = TextEditingController();
  final _notes = TextEditingController();
  var _cityFocused = false;
  var _ready = false;
  var _closed = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => _apply((text) => ref.read(orderDraftProvider.notifier).setName(text), _name));
    _phone.addListener(() => _apply((text) => ref.read(orderDraftProvider.notifier).setPhone(text), _phone));
    _street.addListener(() => _apply((text) => ref.read(orderDraftProvider.notifier).setStreet(text), _street));
    _district.addListener(
      () => _apply((text) => ref.read(orderDraftProvider.notifier).setDistrict(text), _district),
    );
    _building.addListener(
      () => _apply((text) => ref.read(orderDraftProvider.notifier).setBuilding(text), _building),
    );
    _shortAddress.addListener(
      () => _apply(
        (text) => ref.read(orderDraftProvider.notifier).setShortAddress(text),
        _shortAddress,
      ),
    );
    _notes.addListener(() => _apply((text) => ref.read(orderDraftProvider.notifier).setNotes(text), _notes));
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefill());
  }

  void _prefill() {
    if (!mounted || _ready) return;
    final draft = ref.read(orderDraftProvider);
    final notifier = ref.read(orderDraftProvider.notifier);
    if (draft.name.isEmpty) {
      final db = ref.read(mockDatabaseProvider);
      if (db.savedDelivery != null) {
        notifier.applySaved(db.savedDelivery!);
      } else {
        notifier.prefillFromUser(db.user);
      }
    }
    final next = ref.read(orderDraftProvider);
    _name.text = next.name;
    _phone.text = next.phone;
    _street.text = next.street;
    _district.text = next.district;
    _building.text = next.building;
    _shortAddress.text = next.shortAddress;
    _notes.text = next.notes;
    setState(() => _ready = true);
  }

  void _apply(void Function(String text) update, TextEditingController controller) {
    if (_closed) return;
    update(controller.text);
  }

  @override
  void dispose() {
    _closed = true;
    _name.dispose();
    _phone.dispose();
    _street.dispose();
    _district.dispose();
    _building.dispose();
    _shortAddress.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(orderDraftProvider);
    final eta = ref.watch(pricingProviderEta);
    final labels = {for (final id in saudiCityIds) id: saudiCityLabel(l10n, id)};

    return AppScaffold(
      title: l10n.orderDeliveryTitle,
      body: ListView(
        children: [
          const OrderStepHeader(step: 2),
          Text(l10n.orderDeliveryEta(eta), style: AppTypography.bodyM),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _name,
            label: l10n.nameLabel,
            hint: l10n.nameHint,
          ),
          const SizedBox(height: AppSpacing.lg),
          Directionality(
            textDirection: TextDirection.ltr,
            child: AppTextField(
              controller: _phone,
              label: l10n.orderPhone,
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.cityLabel, style: AppTypography.bodyM),
          const SizedBox(height: AppSpacing.sm),
          CitySelectField(
            cities: saudiCityIds,
            selectedCity: draft.city,
            isFocused: _cityFocused,
            onFocusChange: (value) => setState(() => _cityFocused = value),
            onChanged: (value) => ref.read(orderDraftProvider.notifier).setCity(value),
            hint: l10n.cityHint,
            labels: labels,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            key: const Key('delivery-street'),
            controller: _street,
            label: l10n.orderStreet,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            key: const Key('delivery-district'),
            controller: _district,
            label: l10n.orderDistrict,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            key: const Key('delivery-building'),
            controller: _building,
            label: l10n.orderBuilding,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _shortAddress,
            label: l10n.orderShortAddress,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _notes,
            label: l10n.orderNotes,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: draft.saveAddress,
            onChanged: (value) {
              ref.read(orderDraftProvider.notifier).setSaveAddress(value ?? true);
            },
            title: Text(l10n.orderSaveAddress),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            key: const Key('order-continue'),
            label: l10n.actionContinue,
            enabled: draft.deliveryComplete,
            onPressed: () {
              rememberDelivery(ref.read(mockDatabaseProvider), draft);
              context.push(AppRoutes.orderReview);
            },
          ),
        ],
      ),
    );
  }
}

final pricingProviderEta = Provider<String>((ref) {
  return ref.watch(pricingProvider).value?.deliveryEta ?? '';
});
