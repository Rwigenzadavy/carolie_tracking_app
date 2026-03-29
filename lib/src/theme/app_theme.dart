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
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta Sans',
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        surface: AppColors.surface,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta Sans',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        surface: Color(0xFF1E1E1E),
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final textColor = brightness == Brightness.light
        ? AppColors.textPrimary
        : Colors.white;
    final secondaryColor = brightness == Brightness.light
        ? AppColors.textSecondary
        : const Color(0xFFAAAAAA);

    return TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.5,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        height: 1.5,
        color: secondaryColor,
      ),
    );
  }
}
