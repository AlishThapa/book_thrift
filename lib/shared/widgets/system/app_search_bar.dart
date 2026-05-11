import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary, size: 22),
        suffixIcon: _buildSuffix(colorScheme),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget? _buildSuffix(ColorScheme colorScheme) {
    if (onClear != null && controller != null) {
      return ValueListenableBuilder(
        valueListenable: controller!,
        builder: (context, value, _) {
          if (value.text.isEmpty) {
            return showFilterIcon 
                ? Icon(Icons.tune_rounded, size: 20, color: colorScheme.onSurfaceVariant) 
                : const SizedBox.shrink();
          }
          return IconButton(
            icon: Icon(Icons.clear_rounded, size: 20, color: colorScheme.onSurfaceVariant),
            onPressed: onClear,
          );
        },
      );
    }
    if (showFilterIcon) {
      return Icon(Icons.tune_rounded, size: 20, color: colorScheme.onSurfaceVariant);
    }
    return null;
  }
}
