import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';

class ThinProgressBar extends StatelessWidget {
  const ThinProgressBar({
    super.key,
    required this.value,
    required this.color,
    required this.track,
  });

  final double value;
  final Color color;
  final Color track;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: SizedBox(
        height: 4,
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          backgroundColor: track,
          color: color,
        ),
      ),
    );
  }
}
