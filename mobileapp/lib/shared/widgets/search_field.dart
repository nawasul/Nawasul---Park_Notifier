import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.hint = 'Search...',
    this.onChanged,
    this.controller,
  });

  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      style: AppTypography.bodyL,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textMuted,
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
