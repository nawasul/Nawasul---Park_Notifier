import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/delete_account_screen.dart';
import '../../features/account/presentation/edit_profile_screen.dart';
import '../../features/account/presentation/profile_screen.dart';
import '../../features/alerts/presentation/alert_detail_screen.dart';
import '../../features/alerts/presentation/alerts_list_screen.dart';
import '../../features/auth/presentation/account_setup_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/legal/presentation/privacy_policy_screen.dart';
import '../../features/legal/presentation/terms_conditions_screen.dart';
import '../../features/settings/presentation/language_region_screen.dart';
import '../../features/settings/presentation/notification_preferences_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/support/presentation/contact_support_screen.dart';
import '../../features/support/presentation/help_faq_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/language/presentation/language_selection_screen.dart';
import '../../features/my_qr/presentation/my_qr_code_screen.dart';
import '../../features/my_qr/presentation/my_qr_tab_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/scan/presentation/scan_tab_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/sticker/presentation/sticker_order_screen.dart';
import '../../features/sticker/presentation/sticker_order_status_screen.dart';
import '../../features/subscription/presentation/subscription_checkout_screen.dart';
import '../../features/subscription/presentation/subscription_plans_screen.dart';
import '../../features/subscription/presentation/subscription_success_screen.dart';
import '../../features/vehicles/presentation/add_edit_vehicle_screen.dart';
import '../../features/vehicles/presentation/vehicle_details_screen.dart';
import '../../features/vehicles/presentation/vehicles_list_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (context, _) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, _) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, _) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountSetup,
        builder: (context, _) => const AccountSetupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, _, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myQr,
                builder: (context, _) => const MyQrTabScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.scan,
                builder: (context, _) => const ScanTabScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.vehicles,
        builder: (context, _) => const VehiclesListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.alerts,
        builder: (context, _) => const AlertsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.vehiclesAdd,
        builder: (context, _) => const AddEditVehicleScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/vehicles/:id/edit',
        builder: (_, state) => AddEditVehicleScreen(
          vehicleId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/vehicles/:id/qr',
        builder: (_, state) => MyQrCodeScreen(
          vehicleId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/vehicles/:id/sticker-order',
        builder: (_, state) => StickerOrderScreen(
          vehicleId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/vehicles/:id',
        builder: (_, state) => VehicleDetailsScreen(
          vehicleId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/sticker-orders/:id',
        builder: (_, state) => StickerOrderStatusScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/alerts/:id',
        builder: (_, state) => AlertDetailScreen(
          alertId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.subscriptionPlans,
        builder: (context, _) => const SubscriptionPlansScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.subscriptionCheckout,
        builder: (context, _) => const SubscriptionCheckoutScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.subscriptionSuccess,
        builder: (context, _) => const SubscriptionSuccessScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileEdit,
        builder: (context, _) => const EditProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settings,
        builder: (context, _) => const SettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.notificationPreferences,
        builder: (context, _) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.languageRegion,
        builder: (context, _) => const LanguageRegionScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.helpFaq,
        builder: (context, _) => const HelpFaqScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.contactSupport,
        builder: (context, _) => const ContactSupportScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.privacyPolicy,
        builder: (context, _) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.termsConditions,
        builder: (context, _) => const TermsConditionsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.deleteAccount,
        builder: (context, _) => const DeleteAccountScreen(),
      ),
    ],
  );
});
