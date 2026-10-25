import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/online.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import 'info_banner.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoBanner(
      message: AppLocalizations.of(context).offlineBanner,
      tone: InfoBannerTone.warning,
    );
  }
}

/// Puts [child] under an offline notice when the device is offline.
class WithOfflineBanner extends ConsumerWidget {
  const WithOfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(onlineProvider).asData?.value == false;
    if (!offline) return child;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OfflineBanner(),
        const SizedBox(height: AppSpacing.md),
        Expanded(child: child),
      ],
    );
  }
}
