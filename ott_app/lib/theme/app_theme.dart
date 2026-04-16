import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = _textTheme();

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: AppColors.accent,
        secondary: AppColors.accentHover,
        surface: AppColors.card,
      ),
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: AppColors.borderSubtle,
      splashFactory: InkSparkle.splashFactory,
    );
  }

  static TextTheme _textTheme() {
    TextStyle soraTight(double size, FontWeight weight) => GoogleFonts.sora(
          fontSize: size,
          fontWeight: weight,
          color: AppColors.textPrimary,
          height: 1.08,
          letterSpacing: -0.4,
        );

    TextStyle inter(double size, FontWeight weight) => GoogleFonts.inter(
          fontSize: size,
          fontWeight: weight,
          color: AppColors.textPrimary,
          height: 1.3,
        );

    return TextTheme(
      displayLarge: soraTight(56, FontWeight.w800),
      displayMedium: soraTight(40, FontWeight.w800),
      displaySmall: soraTight(32, FontWeight.w800),
      headlineLarge: soraTight(24, FontWeight.w800),
      headlineMedium: soraTight(20, FontWeight.w800),
      titleLarge: soraTight(18, FontWeight.w700),
      titleMedium: soraTight(16, FontWeight.w700),
      bodyLarge: inter(16, FontWeight.w400).copyWith(
        color: AppColors.textSecondary,
      ),
      bodyMedium: inter(14, FontWeight.w400).copyWith(
        color: AppColors.textSecondary,
      ),
      bodySmall: inter(12, FontWeight.w400).copyWith(
        color: AppColors.textMuted,
      ),
      labelSmall: inter(10, FontWeight.w500).copyWith(
        color: AppColors.textMuted,
      ),
    );
  }
}
