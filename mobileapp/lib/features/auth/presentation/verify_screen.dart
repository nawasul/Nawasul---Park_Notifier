import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/mock_config.dart';
import '../../../core/models/alert_item.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../features/account/data/account_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/otp_input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../data/auth_repository.dart';
import 'providers/auth_draft_provider.dart';
import 'providers/session_provider.dart';

final resendDelayProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 60),
);

class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({super.key});

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _otp;
  late final AnimationController _shake;
  Timer? _timer;
  var _seconds = 0;
  var _loading = false;
  var _locked = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _otp = TextEditingController();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _startCountdown());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otp.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    final total = ref.read(resendDelayProvider).inSeconds;
    if (total <= 0) {
      setState(() => _seconds = 0);
      return;
    }
    setState(() => _seconds = total);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds -= 1);
      }
    });
  }

  Future<void> _resend() async {
    final phone = ref.read(authDraftProvider).phoneE164;
    if (phone.isEmpty || _seconds > 0 || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
      _locked = false;
    });
    try {
      final result = await ref.read(authRepositoryProvider).sendOtp(phone);
      ref.read(authDraftProvider.notifier).update(
            (draft) => AuthDraft(
              phoneE164: draft.phoneE164,
              national: draft.national,
              marketing: draft.marketing,
              noWhatsapp: !result.delivered,
            ),
          );
      _otp.clear();
      _startCountdown();
    } on AppException catch (error) {
      _applyError(error);
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).errorGenericBody);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit(String code) async {
    if (_loading || _locked || code.length != 6) return;
    final draft = ref.read(authDraftProvider);
    if (draft.phoneE164.isEmpty) return;
    _loading = true;
    setState(() => _error = null);
    try {
      final result = await ref.read(authRepositoryProvider).verifyOtp(
            draft.phoneE164,
            code == MockConfig.expiredOtp ? code : MockConfig.successOtp,
          );
      final account = ref.read(accountRepositoryProvider);
      final preferences = await account.fetchPreferences();
      await account.updatePreferences(
        preferences.copyWith(marketing: draft.marketing),
      );
      await ref.read(sessionProvider.notifier).signIn(
            isNewUser: result.isNewUser,
            phoneE164: draft.phoneE164,
          );
    } on AppException catch (error) {
      _otp.clear();
      _applyError(error);
    } catch (_) {
      _otp.clear();
      if (mounted) setState(() => _error = AppLocalizations.of(context).errorGenericBody);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyError(AppException error) {
    final l10n = AppLocalizations.of(context);
    final message = switch (error.code) {
      'invalid_otp' => l10n.verifyWrongCode(error.attemptsLeft ?? 0),
      'expired_otp' => l10n.verifyExpired,
      'too_many_attempts' => l10n.verifyLocked(error.retryAfterSeconds ?? 60),
      'no_whatsapp' => l10n.verifyNoWhatsapp,
      _ => l10n.errorGenericBody,
    };
    setState(() {
      _error = message;
      _locked = error.code == 'too_many_attempts';
    });
    if (error.code == 'invalid_otp' && !MediaQuery.disableAnimationsOf(context)) {
      _shake.forward(from: 0);
    }
  }

  Future<void> _openWhatsapp() async {
    final uri = Uri.parse('https://wa.me/');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).errorGenericBody);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(authDraftProvider);
    if (draft.noWhatsapp) return _NoWhatsapp(l10n: l10n);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
          children: [
            Text(l10n.verifyTitle, style: AppTypography.headingL),
            const SizedBox(height: AppSpacing.sm),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                l10n.verifySentTo(PhoneValidator.mask(draft.phoneE164)),
                style: AppTypography.bodyL.copyWith(color: AppColors.textSecondary),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.phone);
                  }
                },
                child: Text(l10n.verifyEdit),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AnimatedBuilder(
              animation: _shake,
              builder: (context, child) {
                final t = _shake.value;
                final dx = math.sin(t * math.pi * 4) * (1 - t) * 8;
                return Transform.translate(offset: Offset(dx, 0), child: child);
              },
              child: AbsorbPointer(
                absorbing: _locked || _loading,
                child: OtpInputField(
                  controller: _otp,
                  hasError: _error != null,
                  onCompleted: _submit,
                  onChanged: (value) {
                    if (value.length == 6) _submit(value);
                  },
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                _error!,
                style: AppTypography.bodyM.copyWith(color: AppColors.error),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: _seconds == 0 && !_loading ? _resend : null,
              child: Text(
                _seconds == 0 ? l10n.verifyResend : l10n.verifyResendIn(_seconds),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: l10n.verifyOpenWhatsapp,
              onPressed: _openWhatsapp,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoWhatsapp extends StatelessWidget {
  const _NoWhatsapp({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.verifyTitle, style: AppTypography.headingL),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.verifyNoWhatsapp, style: AppTypography.bodyL),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.help),
                  child: Text(l10n.verifyHelp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
