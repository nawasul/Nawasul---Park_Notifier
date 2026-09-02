class LegalSection {
  const LegalSection({
    required this.title,
    required this.paragraphs,
  });

  final String title;
  final List<String> paragraphs;
}

class MockLegal {
  MockLegal._();

  static const privacyPolicySections = [
    LegalSection(
      title: '1. Information We Collect',
      paragraphs: [
        'When you use Nawasul, we collect information you provide directly, including your '
        'name, phone number, email address, city/region, and vehicle details (make, model, '
        'plate number). We also collect usage data such as QR scan events, notification '
        'delivery status, and app interaction logs.',
        'We do not collect location data from your device unless you explicitly grant permission '
        'for a specific feature that requires it.',
      ],
    ),
    LegalSection(
      title: '2. How We Use Your Information',
      paragraphs: [
        'Your information is used to provide the core Nawasul service: routing anonymous '
        'notifications between QR scanners and vehicle owners. We use your phone number solely '
        'for authentication and delivering alerts — it is never disclosed to third parties or '
        'to individuals who scan your QR code.',
        'We may use aggregated, anonymized data to improve our services, develop new features, '
        'and generate usage statistics. Individual user data is never sold to advertisers or '
        'data brokers.',
      ],
    ),
    LegalSection(
      title: '3. Data Sharing and Disclosure',
      paragraphs: [
        'We share your data only with service providers who assist in operating Nawasul (e.g., '
        'cloud hosting, SMS delivery, payment processing). These providers are contractually '
        'bound to protect your data and use it only for the services they provide to us.',
        'We may disclose information if required by law, court order, or government regulation '
        'in the Kingdom of Saudi Arabia.',
      ],
    ),
    LegalSection(
      title: '4. Your Rights and Choices',
      paragraphs: [
        'You have the right to access, correct, or delete your personal data at any time through '
        'the app\'s Account settings. You can manage notification preferences, update your profile, '
        'or request full account deletion.',
        'For questions about your data or to exercise your rights, contact us at '
        'privacy@nawasul.app.',
      ],
    ),
  ];

  static const termsSections = [
    LegalSection(
      title: '1. Acceptance of Terms',
      paragraphs: [
        'By downloading, installing, or using the Nawasul mobile application, you agree to be '
        'bound by these Terms and Conditions. If you do not agree, please do not use the service.',
        'Nawasul reserves the right to modify these terms at any time. Continued use of the '
        'app after changes constitutes acceptance of the updated terms.',
      ],
    ),
    LegalSection(
      title: '2. Service Description',
      paragraphs: [
        'Nawasul provides a QR-based vehicle owner notification service. Vehicle owners register '
        'their vehicles, receive QR stickers, and get notified when someone scans their QR code. '
        'The service is designed to facilitate communication without revealing personal contact '
        'information.',
        'Nawasul is not responsible for the actions of individuals who scan QR codes or for '
        'any disputes arising from vehicle-related interactions.',
      ],
    ),
    LegalSection(
      title: '3. User Responsibilities',
      paragraphs: [
        'You are responsible for maintaining the accuracy of your account information and for '
        'keeping your login credentials secure. You must not use Nawasul for any unlawful purpose, '
        'including harassment, fraud, or impersonation.',
        'You agree to place QR stickers only on vehicles you own or are authorized to register. '
        'Misuse of the service may result in account suspension or termination.',
      ],
    ),
    LegalSection(
      title: '4. Subscriptions and Payments',
      paragraphs: [
        'Certain features require a paid subscription. Subscription fees are billed according to '
        'the plan you select (monthly or annual). All fees are non-refundable except as required '
        'by applicable law.',
        'You may cancel your subscription at any time through the app. Cancellation takes effect '
        'at the end of the current billing period.',
      ],
    ),
    LegalSection(
      title: '5. Limitation of Liability',
      paragraphs: [
        'Nawasul is provided "as is" without warranties of any kind. We do not guarantee '
        'uninterrupted or error-free service. To the maximum extent permitted by law, Nawasul '
        'shall not be liable for any indirect, incidental, or consequential damages arising from '
        'your use of the service.',
      ],
    ),
  ];
}
