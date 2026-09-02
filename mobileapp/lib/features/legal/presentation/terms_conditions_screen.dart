import 'package:flutter/material.dart';

import '../../../core/mock/mock_legal.dart';
import '../../../shared/widgets/legal_document_screen.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentScreen(
      title: 'Terms & Conditions',
      sections: MockLegal.termsSections,
    );
  }
}
