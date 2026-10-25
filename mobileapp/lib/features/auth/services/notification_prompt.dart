import 'package:flutter/foundation.dart';

/// The loud-alert step is Android only. Web and other platforms skip it.
bool showLoudAlertStep({
  required bool isWeb,
  required TargetPlatform platform,
}) {
  return !isWeb && platform == TargetPlatform.android;
}
