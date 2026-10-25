import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(localeProvider).valueOrNull?.languageCode ?? 'en';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LanguageChip(
          label: l10n.languageEn,
          selected: code == 'en',
          onTap: () => ref.read(localeProvider.notifier).setLanguageCode('en'),
        ),
        Text(
          '|',
          style: AppTypography.bodyM.copyWith(color: AppColors.textMuted),
        ),
        _LanguageChip(
          label: l10n.languageAr,
          selected: code == 'ar',
          onTap: () => ref.read(localeProvider.notifier).setLanguageCode('ar'),
        ),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: AppTypography.button.copyWith(
          color: selected ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}
