import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme => _theme(Brightness.light);
  static ThemeData get darkTheme => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.surface,
      primaryContainer: AppColors.primary.withValues(alpha: 0.2),
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondary,
      onSecondary: AppColors.surface,
      secondaryContainer: AppColors.secondaryDark.withValues(alpha: 0.3),
      onSecondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.accent,
      onTertiary: AppColors.surface,
      tertiaryContainer: AppColors.accent.withValues(alpha: 0.2),
      onTertiaryContainer: AppColors.accentLight,
      error: AppColors.error,
      onError: AppColors.surface,
      surface: const Color(0xFF1E293B),
      onSurface: Colors.white,
      onSurfaceVariant: AppColors.textLight,
      surfaceContainerLowest: const Color(0xFF0F172A),
      surfaceContainerLow: const Color(0xFF162032),
      surfaceContainer: const Color(0xFF1A2236),
      surfaceContainerHigh: AppColors.cardBackgroundDark,
      surfaceContainerHighest: const Color(0xFF171D2B),
      outline: AppColors.borderDark,
      outlineVariant: AppColors.borderDark.withValues(alpha: 0.5),
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: AppColors.surface,
      onInverseSurface: AppColors.textPrimary,
      inversePrimary: AppColors.primaryDark,
    )
        : ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.surface,
      primaryContainer: AppColors.primary,
      onPrimaryContainer: AppColors.surface,
      secondary: AppColors.secondary,
      onSecondary: AppColors.surface,
      secondaryContainer: AppColors.surfaceLight,
      onSecondaryContainer: AppColors.secondaryDark,
      tertiary: AppColors.accent,
      onTertiary: AppColors.surface,
      tertiaryContainer: AppColors.accentLight.withValues(alpha: 0.2),
      onTertiaryContainer: AppColors.accentDark,
      error: AppColors.error,
      onError: AppColors.surface,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.neutralLight,
      surfaceContainer: AppColors.surfaceLight,
      surfaceContainerHigh: AppColors.cardBackground,
      surfaceContainerHighest: AppColors.surface,
      outline: AppColors.border,
      outlineVariant: AppColors.border.withValues(alpha: 0.6),
      shadow: AppColors.primary.withValues(alpha: 0.08),
      scrim: Colors.black26,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.primaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.sectionTitle.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        hintStyle: AppTextStyles.subtitle.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) => AppTextStyles.caption.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.primary,
        titleTextStyle: AppTextStyles.cardTitle.copyWith(
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: AppTextStyles.subtitle.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: AppTextStyles.largeHeading.copyWith(
          color: colorScheme.onSurface,
        ),
        titleLarge: AppTextStyles.sectionTitle.copyWith(
          color: colorScheme.onSurface,
        ),
        titleMedium: AppTextStyles.cardTitle.copyWith(
          color: colorScheme.onSurface,
        ),
        bodyMedium: AppTextStyles.subtitle.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        bodySmall: AppTextStyles.caption.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}