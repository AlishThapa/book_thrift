import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';

/// Horizontally scrollable category filter chips.
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = selected == category;
        return _CategoryChip(
          label: category,
          isSelected: isSelected,
          onTap: () => onSelected(category),
        );
      }).toList(),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary
            : (isDark ? colorScheme.surfaceContainerHigh : colorScheme.surfaceContainerLow),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : (isDark ? colorScheme.outline.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ]
            : (isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}