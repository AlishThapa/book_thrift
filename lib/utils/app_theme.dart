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
      scaffoldBackgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.background,
      colorScheme: scheme.copyWith(
        surface: isDark ? const Color(0xFF1E293B) : Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.sectionTitle.copyWith(color: isDark ? Colors.white : AppColors.darkText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        hintStyle: AppTextStyles.subtitle.copyWith(color: isDark ? Colors.white38 : AppColors.softText),
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
        color: isDark ? const Color(0xFF1E293B) : AppColors.cardBackground,
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
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.borderDark : AppColors.border,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: isDark ? AppColors.primaryLight : AppColors.primary,
        titleTextStyle: AppTextStyles.cardTitle.copyWith(color: isDark ? Colors.white : AppColors.darkText),
        subtitleTextStyle: AppTextStyles.subtitle.copyWith(color: isDark ? AppColors.textLight : AppColors.softText),
      ),
      textTheme: TextTheme(
        headlineSmall: AppTextStyles.largeHeading.copyWith(color: isDark ? Colors.white : AppColors.darkText),
        titleLarge: AppTextStyles.sectionTitle.copyWith(color: isDark ? Colors.white : AppColors.darkText),
        titleMedium: AppTextStyles.cardTitle.copyWith(color: isDark ? Colors.white : AppColors.darkText),
        bodyMedium: AppTextStyles.subtitle.copyWith(color: isDark ? AppColors.textLight : AppColors.softText),
        bodySmall: AppTextStyles.caption.copyWith(color: isDark ? AppColors.textLight.withAlpha(180) : AppColors.softText),
      ),
    );
  }
}
