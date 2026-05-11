import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({super.key, required this.label, required this.selected, required this.onSelected});

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: selected ? AppColors.primary : const Color(0xFFE2E8F0)),
      selectedColor: AppColors.primary.withAlpha(30),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.darkText,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}
