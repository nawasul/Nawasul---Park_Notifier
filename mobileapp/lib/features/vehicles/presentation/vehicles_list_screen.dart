import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/search_field.dart';
import '../../../shared/widgets/vehicle_card.dart';
import '../../vehicles/presentation/providers/vehicle_provider.dart';

class VehiclesListScreen extends ConsumerStatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  ConsumerState<VehiclesListScreen> createState() =>
      _VehiclesListScreenState();
}

class _VehiclesListScreenState extends ConsumerState<VehiclesListScreen> {
  String _query = '';
  bool _isGrid = false;

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(vehicleProvider);
    final filtered = vehicles.where((v) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return v.make.toLowerCase().contains(q) ||
          v.model.toLowerCase().contains(q) ||
          v.plateNumber.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.vehiclesAdd),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.surface),
      ),
      body: SafeArea(
        child: vehicles.isEmpty
            ? EmptyStateWidget(
                icon: Icons.directions_car_outlined,
                heading: 'No vehicles yet',
                message: 'Add your first vehicle to get started.',
                actionLabel: 'Add Vehicle',
                onAction: () => context.push(AppRoutes.vehiclesAdd),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'My Vehicles',
                            style: AppTypography.headingL,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => _isGrid = !_isGrid),
                          icon: Icon(
                            _isGrid ? Icons.view_list : Icons.grid_view,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: SearchField(
                      hint: 'Search vehicles...',
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: _isGrid
                        ? GridView.builder(
                            padding: const EdgeInsetsDirectional.all(
                              AppSpacing.lg,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppSpacing.md,
                              mainAxisSpacing: AppSpacing.md,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) => VehicleCard(
                              vehicle: filtered[i],
                              compact: true,
                              onTap: () => context.push(
                                AppRoutes.vehicleDetails(filtered[i].id),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsetsDirectional.all(
                              AppSpacing.lg,
                            ),
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (_, i) => VehicleCard(
                              vehicle: filtered[i],
                              onTap: () => context.push(
                                AppRoutes.vehicleDetails(filtered[i].id),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
