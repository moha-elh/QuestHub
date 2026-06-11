import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/player_score.dart';
import 'rank_badge.dart';

class PodiumSection extends StatelessWidget {
  const PodiumSection({
    required this.topScores,
    super.key,
  });

  final List<PlayerScore> topScores;

  @override
  Widget build(BuildContext context) {
    if (topScores.isEmpty) return const SizedBox.shrink();

    final first = topScores.isNotEmpty ? topScores[0] : null;
    final second = topScores.length > 1 ? topScores[1] : null;
    final third = topScores.length > 2 ? topScores[2] : null;

    return SizedBox(
      height: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (second != null)
            _podiumSlot(second, 140, 0),
          if (first != null)
            _podiumSlot(first, 180, 0.3),
          if (third != null)
            _podiumSlot(third, 120, 0.6),
        ],
      ),
    );
  }

  Widget _podiumSlot(PlayerScore score, double barHeight, double delay) {
    final isFirst = score.rank == 1;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, barHeight * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isFirst)
              const Text('\u{1F451}', style: TextStyle(fontSize: 28)),
            const SizedBox(height: AppSpacing.xs),
            CircleAvatar(
              radius: isFirst ? 28 : 22,
              backgroundColor: AppColors.surfaceElevated,
              backgroundImage: score.avatarUrl != null
                  ? NetworkImage(score.avatarUrl!)
                  : null,
              child: score.avatarUrl == null
                  ? Text(
                      score.displayName.isNotEmpty
                          ? score.displayName[0].toUpperCase()
                          : '?',
                      style: AppTypography.h3,
                    )
                  : null,
            ),
            const SizedBox(height: AppSpacing.xs),
            RankBadge(rank: score.rank),
            const SizedBox(height: AppSpacing.xs),
            Text(
              score.displayName,
              style: AppTypography.caption.copyWith(
                fontWeight: isFirst ? FontWeight.w700 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${score.score}',
              style: (isFirst ? AppTypography.scoreMedium : AppTypography.h3)
                  .copyWith(
                color: isFirst ? AppColors.warning : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              width: isFirst ? 72 : 56,
              height: barHeight * 0.4,
              decoration: BoxDecoration(
                color: isFirst
                    ? AppColors.warning.withValues(alpha: 0.3)
                    : AppColors.surfaceElevated,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.sm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
