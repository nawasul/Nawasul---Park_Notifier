import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/expandable_faq_item.dart';
import '../../../shared/widgets/outline_button.dart';
import '../../orders/presentation/providers/order_providers.dart';

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final eta = ref.watch(pricingProvider).value?.deliveryEta;

    final items = <(String, String)>[
      (l10n.faqHowTitle, l10n.faqHowBody),
      (l10n.faqNumberTitle, l10n.faqNumberBody),
      (l10n.faqReachTitle, l10n.faqReachBody),
      (l10n.faqExpireTitle, l10n.faqExpireBody),
      (
        l10n.faqDeliveryTitle,
        eta == null ? l10n.faqDeliveryPending : l10n.faqDeliveryBody(eta),
      ),
      (l10n.faqMoveTitle, l10n.faqMoveBody),
      (l10n.faqSilentTitle, l10n.faqSilentBody),
      (l10n.faqDeleteTitle, l10n.faqDeleteBody),
    ];

    return AppScaffold(
      title: l10n.accountHelp,
      body: ListView(
        children: [
          for (final item in items)
            ExpandableFAQItem(question: item.$1, answer: item.$2),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.accountContact, style: AppTypography.headingM),
          const SizedBox(height: AppSpacing.md),
          OutlineButton(
            label: l10n.accountWhatsappContact,
            onPressed: () => _open(
              ref,
              Uri.parse(
                'https://wa.me/${AppConfig.supportWhatsAppE164.replaceAll('+', '')}',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlineButton(
            label: l10n.accountEmailContact,
            onPressed: () => _open(
              ref,
              Uri.parse('mailto:${AppConfig.supportEmail}'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppConfig.supportEmail,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

Future<void> _open(WidgetRef ref, Uri uri) {
  return ref.read(urlOpenerProvider)(uri);
}
