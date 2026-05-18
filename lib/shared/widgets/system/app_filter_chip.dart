import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';

import '../../../constants/design_tokens.dart';

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({super.key, required this.label, required this.selected, required this.onSelected});

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary
            : (isDark ? colorScheme.surfaceContainerHigh : colorScheme.surfaceContainerLow),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected
              ? colorScheme.primary
              : (isDark ? colorScheme.outline.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
          width: 1.5,
        ),
        boxShadow: selected
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
          onTap: () => onSelected(!selected),
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
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
                        color: selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
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
