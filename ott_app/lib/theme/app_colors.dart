import 'package:flutter/material.dart';

class AppColors {
  // Camcine (React) parity palette (from `camcine-main/src/index.css`).
  static const background = Color(0xFF06080A); // --bg-base
  static const backgroundSecondary = Color(0xFF0D1014); // --bg-surface
  static const card = Color(0xFF111418); // --bg-card
  static const cardElevated = Color(0xFF181C22); // --bg-elevated
  static const overlay = Color(0xFF1E232B); // --bg-overlay

  static const accent = Color(0xFF7A1027); // --accent
  static const accentHover = Color(0xFF9B1835); // --accent-hover
  static const accentGlow = Color(0x477A1027); // --accent-glow (0.28)
  static const accentSubtle = Color(0x247A1027); // --accent-subtle (0.14)

  static const textPrimary = Color(0xFFF0F2F5); // --text-primary
  static const textSecondary = Color(0xFF9AA3AD); // --text-secondary
  static const textMuted = Color(0xFF525B63); // --text-muted
  static const textFaint = Color(0xFF3A424A);

  static const borderSubtle = Color(0x0FFFFFFF); // --border-subtle
  static const border = Color(0x1AFFFFFF); // --border-default
  static const borderStrong = Color(0x2EFFFFFF); // --border-strong

  static const glassBg = Color(0x99111418); // rgba(17,20,24,0.6..0.8-ish)
  static const glassBorder = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const glassAccent = Color(0x247A1027); // accent subtle

  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFEF4444);
  static const error = Color(0xFFEF4444);

  // App-specific accents still used in some screens.
  static const gold = Color(0xFFF6D365);
  static const gradientStart = Color(0xFF1E3A8A);
  static const gradientMid = Color(0xFF4C1D95);
  static const gradientEnd = Color(0xFF7E22CE);
}
