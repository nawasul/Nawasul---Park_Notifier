import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/allow_alerts_screen.dart';
import '../../features/auth/presentation/name_screen.dart';
import '../../features/auth/presentation/phone_screen.dart';
import '../../features/auth/presentation/verify_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/providers/session_provider.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/vehicles/presentation/vehicle_details_screen.dart';
import '../../features/vehicles/presentation/vehicle_form_screen.dart';
import '../../features/vehicles/presentation/vehicle_qr_screen.dart';
import '../../features/vehicles/presentation/vehicles_list_screen.dart';
import '../../features/orders/presentation/order_delivery_screen.dart';
import '../../features/orders/presentation/order_details_screen.dart';
import '../../features/orders/presentation/order_result_screen.dart';
import '../../features/orders/presentation/order_review_screen.dart';
import '../../features/orders/presentation/order_vehicle_screen.dart';
import '../../features/orders/presentation/orders_list_screen.dart';
import '../../features/account/presentation/account_screen.dart';
import '../../features/account/presentation/delete_account_screen.dart';
import '../../features/account/presentation/edit_profile_screen.dart';
import '../../features/account/presentation/notification_settings_screen.dart';
import '../../features/support/presentation/help_screen.dart';
import '../../features/support/presentation/legal_screen.dart';
import '../../features/alerts/presentation/alert_detail_screen.dart';
import '../../features/alerts/presentation/alerts_list_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);
  ref.listen(sessionProvider, (_, _) => refresh.ping());

  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  final router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.phone,
        builder: (_, _) => const PhoneScreen(),
      ),
      GoRoute(
        path: AppRoutes.verify,
        builder: (_, _) => const VerifyScreen(),
      ),
      GoRoute(
        path: AppRoutes.name,
        builder: (_, _) => const NameScreen(),
      ),
      GoRoute(
        path: AppRoutes.allowAlerts,
        builder: (_, _) => const AllowAlertsScreen(),
      ),
      GoRoute(
        path: AppRoutes.legal,
        builder: (_, state) => LegalScreen(type: state.pathParameters['type'] ?? ''),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.vehicles,
                builder: (_, _) => const VehiclesListScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const VehicleFormScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootKey,
                    builder: (_, state) => VehicleDetailsScreen(
                      id: state.pathParameters['id'] ?? '',
                      justAdded: state.uri.queryParameters['added'] == '1',
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: rootKey,
                        builder: (_, state) => VehicleFormScreen(
                          vehicleId: state.pathParameters['id'],
                        ),
                      ),
                      GoRoute(
                        path: 'qr',
                        parentNavigatorKey: rootKey,
                        builder: (_, state) => VehicleQrScreen(
                          id: state.pathParameters['id'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.alerts,
                builder: (_, _) => const AlertsListScreen(),
                routes: [
                  GoRoute(
                    path: ':alertId',
                    parentNavigatorKey: rootKey,
                    builder: (_, state) => AlertDetailsScreen(
                      alertId: state.pathParameters['alertId'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (_, _) => const AccountScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'help',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const HelpScreen(),
                  ),
                  GoRoute(
                    path: 'delete',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const DeleteAccountScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.orderVehicle,
        builder: (_, state) => OrderVehicleScreen(
          initialVehicleId: state.uri.queryParameters['vehicleId'],
        ),
      ),
      GoRoute(
        path: AppRoutes.orderDelivery,
        builder: (_, _) => const OrderDeliveryScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderReview,
        builder: (_, _) => const OrderReviewScreen(),
      ),
      GoRoute(
        path: '/order/result/:orderId',
        builder: (_, state) => OrderResultScreen(
          orderId: state.pathParameters['orderId'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.orders,
        builder: (_, _) => const OrdersListScreen(),
        routes: [
          GoRoute(
            path: ':orderId',
            builder: (_, state) => OrderDetailsScreen(
              orderId: state.pathParameters['orderId'] ?? '',
            ),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

String? _redirect(Ref ref, GoRouterState state) {
  final asyncSession = ref.read(sessionProvider);
  final loc = state.uri.path;
  if (asyncSession.isLoading || asyncSession.hasError) {
    return loc == AppRoutes.splash ? null : AppRoutes.splash;
  }
  final session = asyncSession.requireValue;
  if (loc == AppRoutes.splash) return null;
  if (loc.startsWith('/legal')) return null;
  if (loc == AppRoutes.help) return null;

  final dest = destinationFor(session);
  final onboarding = loc == AppRoutes.onboarding;
  final loggingIn = loc == AppRoutes.phone || loc == AppRoutes.verify;
  final naming = loc == AppRoutes.name;
  final alerts = loc == AppRoutes.allowAlerts;

  if (!session.isAuthenticated) {
    if (onboarding) {
      return session.hasSeenOnboarding ? AppRoutes.phone : null;
    }
    if (loggingIn) {
      return session.hasSeenOnboarding ? null : AppRoutes.onboarding;
    }
    return dest;
  }

  if (onboarding || loggingIn) return dest;
  if (naming) {
    if (!session.isNewUser || session.profileComplete) return dest;
    return null;
  }
  if (alerts) {
    if (!session.isNewUser || session.alertsPromptSeen) return dest;
    if (!session.profileComplete) return AppRoutes.name;
    return null;
  }
  if (session.isNewUser && !session.profileComplete) return AppRoutes.name;
  if (session.isNewUser && !session.alertsPromptSeen) {
    return AppRoutes.allowAlerts;
  }
  return null;
}

class _RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}
