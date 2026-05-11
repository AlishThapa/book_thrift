import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class AppSurface extends StatelessWidget {
  const AppSurface({super.key, required this.child, this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10), this.margin});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (Theme.of(context).brightness == Brightness.dark ? AppColors.cardBackgroundDark : Colors.white),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withAlpha(40) : const Color(0x0A000000),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
