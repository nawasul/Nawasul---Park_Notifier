import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.padding = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!, style: AppTypography.headingM),
              actions: actions,
            ),
      body: SafeArea(
        child: padding
            ? Padding(
                padding: const EdgeInsetsDirectional.all(AppSpacing.screen),
                child: body,
              )
            : body,
      ),
    );
  }
}
