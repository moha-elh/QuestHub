import 'package:flutter/material.dart';

/// QuestHub palette — dark-first with vibrant accents.
///
/// Never hardcode colors in widgets; always reference [AppColors].
abstract final class AppColors {
  // Backgrounds (darkest → most elevated).
  static const Color background = Color(0xFF0D0E12);
  static const Color surface = Color(0xFF16181D);
  static const Color surfaceElevated = Color(0xFF1E2128);
  static const Color outline = Color(0xFF2A2E37);

  // Brand accents.
  static const Color primary = Color(0xFF7C5CFF); // electric violet
  static const Color primaryPressed = Color(0xFF6847E8);
  static const Color accent = Color(0xFF4DD8FF); // cyan highlight

  // Semantic.
  static const Color success = Color(0xFF3DDC84);
  static const Color danger = Color(0xFFFF5C5C);
  static const Color warning = Color(0xFFFFB020);

  // Quest difficulty tiers.
  static const Color tierEasy = Color(0xFF3DDC84);
  static const Color tierMedium = Color(0xFF4D9FFF);
  static const Color tierHard = Color(0xFFFF8A3D);
  static const Color tierLegendary = Color(0xFFE7B43A);

  // Text.
  static const Color textPrimary = Color(0xFFF2F3F5);
  static const Color textSecondary = Color(0xFF9BA1AC);
  static const Color textFaint = Color(0xFF5C6370);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
}
