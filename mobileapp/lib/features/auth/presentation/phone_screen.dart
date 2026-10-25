import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/models/alert_item.dart';
import '../../../core/router/app_routes.dart';
import '../../account/data/account_repository.dart';
import 'providers/session_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/phone_input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../data/auth_repository.dart';
import 'providers/auth_draft_provider.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  late final TextEditingController _phone;
  var _marketing = false;
  var _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(authDraftProvider);
    _phone = TextEditingController(text: draft.national);
    _marketing = draft.marketing;
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  bool get _valid => PhoneValidator.nationalError(_phone.text) == null;

  Future<void> _submit() async {
    final e164 = PhoneValidator.toE164(_phone.text);
    if (e164 == null || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (AppConfig.useMock) {
        final result = await ref.read(authRepositoryProvider).acceptPhone(e164);
        ref.read(authDraftProvider.notifier).state = AuthDraft(
          phoneE164: e164,
          national: _phone.text,
          marketing: _marketing,
        );
        final account = ref.read(accountRepositoryProvider);
        final preferences = await account.fetchPreferences();
        await account.updatePreferences(
          preferences.copyWith(marketing: _marketing),
        );
        await ref.read(sessionProvider.notifier).signIn(
              isNewUser: result.isNewUser,
              phoneE164: e164,
            );
        return;
      }
      final result = await ref.read(authRepositoryProvider).sendOtp(e164);
      ref.read(authDraftProvider.notifier).state = AuthDraft(
        phoneE164: e164,
        national: _phone.text,
        marketing: _marketing,
        noWhatsapp: !result.delivered,
      );
      if (mounted) context.push(AppRoutes.verify);
    } on AppException catch (error) {
      if (mounted) setState(() => _error = _message(AppLocalizations.of(context), error));
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).errorGenericBody);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nationalError = PhoneValidator.nationalError(_phone.text);
    final fieldError = _error ??
        (nationalError == 'invalid' && _phone.text.isNotEmpty
            ? l10n.phoneInvalid
            : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
          children: [
            Text(l10n.phoneTitle, style: AppTypography.headingL),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.phoneSubtitle,
              style: AppTypography.bodyL.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            PhoneField(
              controller: _phone,
              errorText: fieldError,
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ConsentText(l10n: l10n),
            CheckboxListTile(
              value: _marketing,
              onChanged: (value) => setState(() => _marketing = value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l10n.phoneMarketing, style: AppTypography.bodyM),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l10n.actionContinue,
              isLoading: _loading,
              enabled: _valid && !_loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

String _message(AppLocalizations l10n, AppException error) {
  return switch (error.code) {
    'rate_limited' || 'too_many_attempts' => l10n.phoneRateLimited(
        error.retryAfterSeconds ?? 60,
      ),
    'network' => l10n.phoneNetwork,
    'invalid_phone' => l10n.phoneInvalid,
    _ => l10n.errorGenericBody,
  };
}

class _ConsentText extends StatelessWidget {
  const _ConsentText({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyM.copyWith(color: AppColors.textSecondary);
    final link = AppTypography.bodyM.copyWith(color: AppColors.primary);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: l10n.phoneConsentBefore),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: _Link(
              label: l10n.phoneConsentTerms,
              style: link,
              onTap: () => context.push(AppRoutes.legalType('terms')),
            ),
          ),
          TextSpan(text: l10n.phoneConsentAnd),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: _Link(
              label: l10n.phoneConsentPrivacy,
              style: link,
              onTap: () => context.push(AppRoutes.legalType('privacy')),
            ),
          ),
          TextSpan(text: l10n.phoneConsentAfter),
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({
    required this.label,
    required this.style,
    required this.onTap,
  });

  final String label;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: style),
    );
  }
}
