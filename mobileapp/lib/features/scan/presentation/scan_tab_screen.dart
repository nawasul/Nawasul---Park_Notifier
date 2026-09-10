import 'package:flutter/material.dart';

import 'qr_scanner_screen.dart';

/// Shell tab entry point for universal QR scanning.
class ScanTabScreen extends StatelessWidget {
  const ScanTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const QrScannerScreen();
  }
}
