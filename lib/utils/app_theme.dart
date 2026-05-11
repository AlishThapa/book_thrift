import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme => _theme(Brightness.light);

  static ThemeData get darkTheme => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? const Color(0xFF10151F) : AppColors.background,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF10151F) : AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.sectionTitle.copyWith(color: isDark ? Colors.white : AppColors.darkText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1B2232) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        hintStyle: AppTextStyles.subtitle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF171D2B) : Colors.white,
        indicatorColor: AppColors.primary.withAlpha(40),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => AppTextStyles.caption.copyWith(
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? Colors.white70 : AppColors.darkText,
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: AppTextStyles.largeHeading.copyWith(color: isDark ? Colors.white : AppColors.darkText),
        titleLarge: AppTextStyles.sectionTitle.copyWith(color: isDark ? Colors.white : AppColors.darkText),
        titleMedium: AppTextStyles.cardTitle.copyWith(color: isDark ? Colors.white : AppColors.darkText),
        bodyMedium: AppTextStyles.subtitle,
      ),
    );
  }
}
