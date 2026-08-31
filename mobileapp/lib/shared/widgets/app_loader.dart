import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({
    super.key,
    this.size = 32,
    this.color = AppColors.primary,
  });

  final double size;
  final Color color;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _LoaderPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  _LoaderPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708 + (progress * 6.2832),
      2.0,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoaderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
