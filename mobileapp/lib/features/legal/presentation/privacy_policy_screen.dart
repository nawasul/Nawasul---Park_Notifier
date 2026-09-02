import 'package:flutter/material.dart';

import '../../../core/mock/mock_legal.dart';
import '../../../shared/widgets/legal_document_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentScreen(
      title: 'Privacy Policy',
      sections: MockLegal.privacyPolicySections,
    );
  }
}
