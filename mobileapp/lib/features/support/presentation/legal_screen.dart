import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/legal_document_screen.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final document = _document(l10n, type);
    if (document == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(l10n.legalMissing, style: AppTypography.headingM)),
        body: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
          child: Text(l10n.legalMissing, style: AppTypography.bodyL),
        ),
      );
    }
    return LegalDocumentScreen(title: document.$1, sections: document.$2);
  }
}

(String, List<LegalSection>)? _document(AppLocalizations l10n, String type) {
  return switch (type) {
    'privacy' => (
        l10n.legalPrivacy,
        [
          LegalSection(title: l10n.privacyS1Title, paragraphs: [l10n.privacyS1Body]),
          LegalSection(title: l10n.privacyS2Title, paragraphs: [l10n.privacyS2Body]),
          LegalSection(title: l10n.privacyS3Title, paragraphs: [l10n.privacyS3Body]),
        ],
      ),
    'terms' => (
        l10n.legalTerms,
        [
          LegalSection(title: l10n.termsS1Title, paragraphs: [l10n.termsS1Body]),
          LegalSection(title: l10n.termsS2Title, paragraphs: [l10n.termsS2Body]),
          LegalSection(title: l10n.termsS3Title, paragraphs: [l10n.termsS3Body]),
        ],
      ),
    'shipping' => (
        l10n.legalShipping,
        [
          LegalSection(title: l10n.shippingS1Title, paragraphs: [l10n.shippingS1Body]),
          LegalSection(title: l10n.shippingS2Title, paragraphs: [l10n.shippingS2Body]),
        ],
      ),
    _ => null,
  };
}
