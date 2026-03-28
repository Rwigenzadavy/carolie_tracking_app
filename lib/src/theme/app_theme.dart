import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color heroBackground = Color(0xFF0C0F0D);
  static const Color heroBackgroundSoft = Color(0xFF0F0F0F);
  static const Color heroChip = Color(0xFF1A1A1A);
  static const Color heroCard = Color(0x14FFFFFF);
  static const Color accent = Color(0xFFD96C2C);
  static const Color accentSoft = Color(0xFFFFF4EC);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textMuted = Color(0xFF999999);
  static const Color textOnDarkMuted = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color chipBackground = Color(0xFFF5F5F5);
}

class AppTheme {
  static ThemeData light() {
    const textTheme = TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta Sans',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        surface: AppColors.surface,
      ),
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}
