import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthDraft {
  const AuthDraft({
    this.phoneE164 = '',
    this.national = '',
    this.marketing = false,
    this.noWhatsapp = false,
  });

  final String phoneE164;
  final String national;
  final bool marketing;
  final bool noWhatsapp;
}

final authDraftProvider = StateProvider<AuthDraft>((ref) => const AuthDraft());
