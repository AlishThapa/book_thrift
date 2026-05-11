import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.hintText = 'Search books',
    this.onTap,
    this.onChanged,
    this.onClear,
    this.controller,
    this.readOnly = false,
    this.showFilterIcon = false,
  });

  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool readOnly;
  final bool showFilterIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : AppColors.textLight,
          fontSize: 14,
        ),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
        suffixIcon: _buildSuffix(),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.primary.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.primary.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget? _buildSuffix() {
    if (onClear != null && controller != null) {
      return ValueListenableBuilder(
        valueListenable: controller!,
        builder: (context, value, _) {
          if (value.text.isEmpty) {
            return showFilterIcon 
                ? const Icon(Icons.tune_rounded, size: 20, color: AppColors.neutral) 
                : const SizedBox.shrink();
          }
          return IconButton(
            icon: const Icon(Icons.clear_rounded, size: 20, color: AppColors.neutral),
            onPressed: onClear,
          );
        },
      );
    }
    if (showFilterIcon) {
      return const Icon(Icons.tune_rounded, size: 20, color: AppColors.neutral);
    }
    return null;
  }
}
