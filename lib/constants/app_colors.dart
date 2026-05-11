import 'package:flutter/material.dart';

class AppColors {
  // 60-30-10 Color Rule Implementation

  // 60% - Primary/Dominant Color (Blue theme)
  static const Color primary = Color(0xFF4361EE);
  static const Color primaryLight = Color(0xFF6B7EFF);
  static const Color primaryDark = Color(0xFF1B3CDF);
  static const Color background = Color(0xFFEFEEEE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF4F7FF);

  // 30% - Secondary Color (Neutral grays and whites)
  static const Color secondary = Color(0xFF6B73FF);
  static const Color secondaryLight = Color(0xFF9FA8FF);
  static const Color secondaryDark = Color(0xFF4A52CC);
  static const Color neutral = Color(0xFF8F95B2);
  static const Color neutralLight = Color(0xFFF5F6FA);
  static const Color neutralDark = Color(0xFF6B7280);

  // 10% - Accent Color (Orange for highlights and CTAs)
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentLight = Color(0xFFFF8A65);
  static const Color accentDark = Color(0xFFE55100);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // System Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Legacy colors (keeping for compatibility)
  static const Color darkText = Color(0xFF14213D);
  static const Color softText = Color(0xFF5D6785);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF1F2638);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF344056);

  static const Color transparentColor = Colors.transparent;
}
