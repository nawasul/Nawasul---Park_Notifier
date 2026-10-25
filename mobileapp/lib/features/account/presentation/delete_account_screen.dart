import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/order.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/destructive_button.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../auth/presentation/providers/session_provider.dart';
import '../../home/presentation/providers/garage_provider.dart';
import '../data/account_repository.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _reason = TextEditingController();
  var _loading = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await ConfirmationDialog.show(
      context,
      title: l10n.deleteConfirmTitle,
      message: l10n.deleteConfirmBody,
      confirmLabel: l10n.accountDelete,
      cancelLabel: l10n.actionCancel,
      isDestructive: true,
    );
    if (confirmed != true || !mounted) return;
    setState(() => _loading = true);
    final reason = _reason.text.trim();
    await ref.read(accountRepositoryProvider).deleteMe(
          reason: reason.isEmpty ? null : reason,
        );
    await ref.read(sessionProvider.notifier).signOut();
    if (mounted) context.go(AppRoutes.phone);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final orders = ref.watch(ordersProvider).value ?? const <Order>[];
    final inProgress = orders.any(_inProgress);

    return AppScaffold(
      title: l10n.accountDelete,
      body: ListView(
        children: [
          Text(l10n.deleteBody, style: AppTypography.bodyL),
          if (inProgress) ...[
            const SizedBox(height: AppSpacing.lg),
            InfoBanner(
              message: l10n.deleteInProgress,
              tone: InfoBannerTone.warning,
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.help),
                child: Text(l10n.accountHelp),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _reason,
            label: l10n.deleteReason,
          ),
          const SizedBox(height: AppSpacing.xl),
          DestructiveButton(
            label: l10n.accountDelete,
            isLoading: _loading,
            onPressed: _delete,
          ),
        ],
      ),
    );
  }
}

bool _inProgress(Order order) {
  return order.status.isPaid && order.status != OrderStatus.delivered;
}
