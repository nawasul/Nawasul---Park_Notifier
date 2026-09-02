import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_faq.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/expandable_faq_item.dart';
import '../../../shared/widgets/search_field.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FaqItem> get _filteredItems {
    if (_query.isEmpty) return MockFaq.items;
    final lower = _query.toLowerCase();
    return MockFaq.items
        .where(
          (item) =>
              item.question.toLowerCase().contains(lower) ||
              item.answer.toLowerCase().contains(lower),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Help & FAQ', style: AppTypography.headingM),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: SearchField(
                controller: _searchController,
                hint: 'Search FAQs...',
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'No matching FAQs found',
                        style: AppTypography.bodyM.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ExpandableFAQItem(
                          question: item.question,
                          answer: item.answer,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
