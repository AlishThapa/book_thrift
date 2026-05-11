import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(
        color: selected
            ? AppColors.primary
            : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
      ),
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.primary.withOpacity(isDark ? 0.2 : 0.1),
      labelStyle: TextStyle(
        color: selected
            ? (isDark ? AppColors.primaryLight : AppColors.primary)
            : (isDark ? Colors.white70 : AppColors.darkText),
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}
