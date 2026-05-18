import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class ChatFilterChips extends StatelessWidget {
  const ChatFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onFilterSelected(filter),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                          width: 1,
                        ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
