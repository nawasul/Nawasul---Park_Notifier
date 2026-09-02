class FaqItem {
  const FaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

class MockFaq {
  MockFaq._();

  static const items = [
    FaqItem(
      question: 'How does the QR sticker work?',
      answer:
          'Each vehicle gets a unique QR code printed on a weather-resistant sticker. '
          'When someone scans it, Nawasul sends you a push notification and initiates '
          'an automated call — without ever revealing your phone number to the scanner.',
    ),
    FaqItem(
      question: 'Will my phone number be visible to the person who scans my QR?',
      answer:
          'No. Your phone number is never shown to the person scanning your QR code. '
          'All communication is routed through Nawasul\'s secure notification system.',
    ),
    FaqItem(
      question: 'How do I order a replacement sticker?',
      answer:
          'Go to your vehicle details, tap "Order Sticker", and follow the checkout flow. '
          'Replacement stickers are shipped to your registered address within 3–5 business days.',
    ),
    FaqItem(
      question: 'What happens if I don\'t answer the notification call?',
      answer:
          'If you miss the automated call, you\'ll still receive a push notification and SMS '
          'alert with details about the scan. You can view the full alert in the Alerts tab.',
    ),
    FaqItem(
      question: 'Can I register more than one vehicle?',
      answer:
          'Yes. Depending on your subscription plan, you can register multiple vehicles. '
          'Each vehicle gets its own QR code and can be managed independently from the Vehicles tab.',
    ),
    FaqItem(
      question: 'How do I update my contact information?',
      answer:
          'Go to Account → Edit Profile to update your name and city. Phone number changes '
          'require OTP re-verification for security — contact support if you need to change your number.',
    ),
    FaqItem(
      question: 'What subscription plans are available?',
      answer:
          'Nawasul offers Basic, Standard, and Premium plans with monthly or annual billing. '
          'Visit Account → Subscription Plans to compare features and upgrade.',
    ),
    FaqItem(
      question: 'Is my data stored securely?',
      answer:
          'Yes. All personal data is encrypted in transit and at rest. We comply with Saudi '
          'data protection regulations and never share your information with third parties '
          'without your consent.',
    ),
  ];
}
