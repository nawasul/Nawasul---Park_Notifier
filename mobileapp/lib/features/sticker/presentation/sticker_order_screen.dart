import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_auth_data.dart';
import '../../../core/mock/mock_sticker_orders.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/quantity_stepper.dart';

class StickerOrderScreen extends StatefulWidget {
  const StickerOrderScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  State<StickerOrderScreen> createState() => _StickerOrderScreenState();
}

class _StickerOrderScreenState extends State<StickerOrderScreen> {
  final _addressController = TextEditingController();
  final _postalController = TextEditingController();
  String? _selectedCity = MockAuthData.primaryUser.city;
  int _quantity = 2;
  bool _isLoading = false;

  double get _total => MockStickerOrders.totalFor(_quantity);

  @override
  void dispose() {
    _addressController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.push(AppRoutes.stickerOrderStatus(MockStickerOrders.sampleOrder.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order QR Sticker', style: AppTypography.headingM),
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
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: AppTheme.surfaceCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Address Line',
                      hint: 'Street address',
                      controller: _addressController,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('City', style: AppTypography.bodyM.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCity,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      items: MockAuthData.saudiCities
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCity = v),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Postal Code',
                      hint: '12345',
                      controller: _postalController,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Quantity', style: AppTypography.headingM),
              const SizedBox(height: AppSpacing.md),
              QuantityStepper(
                value: _quantity,
                onChanged: (v) => setState(() => _quantity = v),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$_quantity × SAR ${MockStickerOrders.unitPrice.toStringAsFixed(0)}',
                            style: AppTypography.bodyM),
                        Text(
                          'SAR ${_total.toStringAsFixed(0)}',
                          style: AppTypography.headingM.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Place Order',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _placeOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
