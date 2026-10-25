import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/language_toggle.dart';
import '../../../shared/widgets/profile_menu_item.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../../auth/presentation/providers/session_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);

    return AppScaffold(
      title: l10n.navAccount,
      body: user.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(
          onRetry: () => ref.invalidate(currentUserProvider),
        ),
        data: (me) => ListView(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    nameInitials(me.name),
                    style: AppTypography.headingM,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(me.name, style: AppTypography.headingM),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        maskPhone(me.phone),
                        style: AppTypography.bodyM.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.accountEdit,
                  onPressed: () => context.push(AppRoutes.accountEdit),
                  icon: const Icon(AppIcons.pencil),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ProfileMenuItem(
              icon: AppIcons.packageIcon,
              label: l10n.ordersTitle,
              onTap: () => context.push(AppRoutes.orders),
            ),
            ProfileMenuItem(
              icon: AppIcons.bell,
              label: l10n.accountNotifications,
              onTap: () => context.push(AppRoutes.notifications),
            ),
            ProfileMenuItem(
              icon: AppIcons.translate,
              label: l10n.accountLanguage,
              onTap: () => _language(context, l10n),
            ),
            ProfileMenuItem(
              icon: AppIcons.question,
              label: l10n.accountHelp,
              onTap: () => context.push(AppRoutes.help),
            ),
            ProfileMenuItem(
              icon: AppIcons.fileText,
              label: l10n.accountLegal,
              onTap: () => _legal(context, l10n),
            ),
            ProfileMenuItem(
              icon: AppIcons.trash,
              label: l10n.accountDelete,
              isDestructive: true,
              onTap: () => context.push(AppRoutes.deleteAccount),
            ),
            ProfileMenuItem(
              icon: AppIcons.signOut,
              label: l10n.accountLogOut,
              isDestructive: true,
              showDivider: false,
              onTap: () => _logOut(context, ref, l10n),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.accountVersion(AppConfig.appVersion),
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _language(BuildContext context, AppLocalizations l10n) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.accountLanguage, style: AppTypography.headingM),
            const SizedBox(height: AppSpacing.md),
            const LanguageToggle(),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      );
    },
  );
}

Future<void> _legal(BuildContext context, AppLocalizations l10n) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (sheetContext) {
      void open(String type) {
        Navigator.of(sheetContext).pop();
        context.push(AppRoutes.legalType(type));
      }

      return Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.accountLegal, style: AppTypography.headingM),
            const SizedBox(height: AppSpacing.md),
            ProfileMenuItem(
              icon: AppIcons.fileText,
              label: l10n.legalPrivacy,
              onTap: () => open('privacy'),
            ),
            ProfileMenuItem(
              icon: AppIcons.fileText,
              label: l10n.legalTerms,
              onTap: () => open('terms'),
            ),
            ProfileMenuItem(
              icon: AppIcons.fileText,
              label: l10n.legalShipping,
              showDivider: false,
              onTap: () => open('shipping'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _logOut(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) async {
  final confirmed = await ConfirmationDialog.show(
    context,
    title: l10n.accountLogOutTitle,
    message: l10n.accountLogOutBody,
    confirmLabel: l10n.accountLogOut,
    cancelLabel: l10n.actionCancel,
  );
  if (confirmed != true || !context.mounted) return;
  await ref.read(sessionProvider.notifier).signOut();
  if (context.mounted) context.go(AppRoutes.phone);
}
