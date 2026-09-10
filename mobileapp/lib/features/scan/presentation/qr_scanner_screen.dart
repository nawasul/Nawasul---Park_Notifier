import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../services/qr_payload_handler.dart';
import 'widgets/qr_text_result_sheet.dart';
import 'widgets/scanner_overlay.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _controller;
  bool _isProcessing = false;
  bool _torchOn = false;
  PermissionStatus? _permissionStatus;
  bool _cameraUnavailable = false;
  String? _lastScannedValue;
  DateTime? _lastScanAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.status;
    if (!mounted) return;

    if (status.isGranted) {
      _startScanner();
      return;
    }

    setState(() => _permissionStatus = status);
  }

  void _startScanner() {
    _controller?.dispose();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      formats: const [BarcodeFormat.qrCode],
    );
    setState(() {
      _permissionStatus = PermissionStatus.granted;
      _cameraUnavailable = false;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (status.isGranted) {
      _startScanner();
      return;
    }

    setState(() => _permissionStatus = status);
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final raw = capture.barcodes
        .map((b) => b.rawValue)
        .whereType<String>()
        .map((v) => v.trim())
        .firstWhere((v) => v.isNotEmpty, orElse: () => '');

    if (raw.isEmpty) return;

    final now = DateTime.now();
    if (_lastScannedValue == raw &&
        _lastScanAt != null &&
        now.difference(_lastScanAt!) < const Duration(seconds: 3)) {
      return;
    }

    _isProcessing = true;
    _lastScannedValue = raw;
    _lastScanAt = now;

    await _controller?.stop();

    if (!mounted) return;

    final webUri = QrPayloadHandler.safeWebUri(raw);
    if (webUri != null) {
      final opened = await QrPayloadHandler.openWebUrl(webUri);
      if (!mounted) return;

      if (!opened) {
        await _showTextResult(raw);
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        _resetScanner();
      }
      return;
    }

    await _showTextResult(raw);
  }

  Future<void> _showTextResult(String content) async {
    if (!mounted) return;
    await QrTextResultSheet.show(
      context,
      content: content,
      onClose: _resetScanner,
    );
  }

  void _resetScanner() {
    if (!mounted) return;
    _isProcessing = false;
    _controller?.start();
  }

  Future<void> _toggleTorch() async {
    await _controller?.toggleTorch();
    if (!mounted) return;
    setState(() => _torchOn = !_torchOn);
  }

  void _goBack() {
    context.go(AppRoutes.home);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_isProcessing) _controller!.start();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _controller!.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.brandDark,
        body: kIsWeb ? _buildWebFallback() : _buildMobileBody(),
      ),
    );
  }

  Widget _buildWebFallback() {
    return Column(
      children: [
        _buildTopBar(showTorch: false),
        Expanded(
          child: ScannerPermissionView(
            title: 'Camera not available',
            message:
                'QR scanning requires a mobile device with camera access. '
                'Run the app on Android or iOS to use the scanner.',
            actionLabel: 'Back to Home',
            onAction: _goBack,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBody() {
    if (_permissionStatus == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_permissionStatus!.isPermanentlyDenied) {
      return Column(
        children: [
          _buildTopBar(showTorch: false),
          Expanded(
            child: ScannerPermissionView(
              title: 'Camera access required',
              message:
                  'Allow camera access in Settings to scan QR codes.',
              actionLabel: 'Open Settings',
              onAction: openAppSettings,
              secondaryActionLabel: 'Back to Home',
              onSecondaryAction: _goBack,
            ),
          ),
        ],
      );
    }

    if (!_permissionStatus!.isGranted) {
      return Column(
        children: [
          _buildTopBar(showTorch: false),
          Expanded(
            child: ScannerPermissionView(
              title: 'Camera access required',
              message:
                  'Nawasul needs camera access to scan QR codes on stickers, '
                  'links, and other codes.',
              actionLabel: 'Allow Camera',
              onAction: _requestPermission,
              secondaryActionLabel: 'Back to Home',
              onSecondaryAction: _goBack,
            ),
          ),
        ],
      );
    }

    if (_cameraUnavailable || _controller == null) {
      return Column(
        children: [
          _buildTopBar(showTorch: false),
          Expanded(
            child: ScannerPermissionView(
              title: 'Camera unavailable',
              message:
                  'Unable to start the camera. Please close other apps using '
                  'the camera and try again.',
              actionLabel: 'Try Again',
              onAction: _startScanner,
              secondaryActionLabel: 'Back to Home',
              onSecondaryAction: _goBack,
            ),
          ),
        ],
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _handleDetection,
          errorBuilder: (context, error, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _cameraUnavailable = true);
            });
            return child ?? const SizedBox.shrink();
          },
        ),
        const ScannerOverlay(),
        Column(
          children: [
            _buildTopBar(showTorch: true),
            const Spacer(),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
                child: Text(
                  'Scan a QR code',
                  style: AppTypography.bodyM.copyWith(
                    color: AppColors.textOnDark.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopBar({required bool showTorch}) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8, topInset + 4, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textOnDark,
          ),
          const Spacer(),
          if (showTorch)
            IconButton(
              onPressed: _toggleTorch,
              icon: Icon(
                _torchOn ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded,
              ),
              color: AppColors.textOnDark,
            ),
        ],
      ),
    );
  }
}
