import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/quest.dart';

class DifficultyBadge extends StatelessWidget {
  const DifficultyBadge({required this.difficulty, super.key});

  final QuestDifficulty difficulty;

  Color get _color => switch (difficulty) {
    QuestDifficulty.easy => AppColors.tierEasy,
    QuestDifficulty.medium => AppColors.tierMedium,
    QuestDifficulty.hard => AppColors.tierHard,
    QuestDifficulty.legendary => AppColors.tierLegendary,
  };

  String get _label => switch (difficulty) {
    QuestDifficulty.easy => 'Easy',
    QuestDifficulty.medium => 'Medium',
    QuestDifficulty.hard => 'Hard',
    QuestDifficulty.legendary => 'Legendary',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        _label,
        style: AppTypography.caption.copyWith(
          color: _color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
