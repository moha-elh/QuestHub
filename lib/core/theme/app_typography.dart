import 'package:flutter/material.dart';

import 'app_colors.dart';

/// QuestHub type scale — clean sans-serif for UI, large bold numerals for
/// scores (tabular figures so point counters don't jitter while animating).
abstract final class AppTypography {
  static const List<FontFeature> _tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  // Score numerals (Duolingo-style big energy).
  static const TextStyle scoreLarge = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    height: 1.0,
    color: AppColors.textPrimary,
    fontFeatures: _tabularFigures,
  );

  static const TextStyle scoreMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.0,
    color: AppColors.textPrimary,
    fontFeatures: _tabularFigures,
  );

  // Headings.
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Body.
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.textSecondary,
  );

  // Interactive.
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}
