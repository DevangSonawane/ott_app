import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppDecorations {
  static final cardDecoration = BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.borderSubtle),
  );

  static final glassDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.06),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.borderSubtle),
  );

  static const gradientButtonDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        AppColors.gradientStart,
        AppColors.gradientMid,
        AppColors.gradientEnd,
      ],
    ),
  );

  static final accentGlow = BoxShadow(
    color: AppColors.accent.withOpacity(0.25),
    blurRadius: 20,
    spreadRadius: 0,
    offset: const Offset(0, 8),
  );
}
