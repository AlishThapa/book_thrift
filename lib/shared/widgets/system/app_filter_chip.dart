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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      side: BorderSide(color: selected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0))),
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.primary,
      elevation: selected ? 4 : 0,
      pressElevation: 2,
      shadowColor: AppColors.primary.withValues(alpha: 0.5),
      labelStyle: TextStyle(
        color: selected ? Colors.white : (isDark ? Colors.white70 : AppColors.darkText),
        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}
