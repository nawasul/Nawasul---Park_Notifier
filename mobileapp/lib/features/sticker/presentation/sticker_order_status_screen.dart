import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/mock/mock_sticker_orders.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/stepper_timeline.dart';

class StickerOrderStatusScreen extends StatelessWidget {
  const StickerOrderStatusScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final order = MockStickerOrders.sampleOrder;
    const steps = ['Ordered', 'Printed', 'Shipped', 'Delivered'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order Status', style: AppTypography.headingM),
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
              StepperTimeline(
                steps: steps,
                currentStepIndex: order.currentStepIndex,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Details', style: AppTypography.headingM),
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      label: 'Order Date',
                      value: DateFormat.yMMMd().format(order.orderDate),
                    ),
                    _DetailRow(label: 'Quantity', value: '${order.quantity}'),
                    _DetailRow(
                      label: 'Address',
                      value: '${order.addressLine}, ${order.city}',
                    ),
                    _DetailRow(
                      label: 'Total',
                      value: 'SAR ${order.totalPrice.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppTypography.bodyM),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyL.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
