import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/font_sizes.dart';

class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
}

class AppSpacing {
  static const double xxs = 6;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
}

class AppTextStyles {
  static const TextStyle largeHeading = TextStyle(
    fontSize: FontSizes.xl,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
    height: 1.25,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: FontSizes.lg,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
    height: 1.3,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: FontSizes.md,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
    height: 1.35,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: FontSizes.md,
    fontWeight: FontWeight.w500,
    color: AppColors.softText,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontSize: FontSizes.sm,
    fontWeight: FontWeight.w500,
    color: AppColors.softText,
    height: 1.3,
  );

  static const TextStyle price = TextStyle(
    fontSize: FontSizes.md,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
}
