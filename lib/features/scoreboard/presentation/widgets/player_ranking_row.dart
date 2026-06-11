import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/player_score.dart';
import 'rank_badge.dart';

class PlayerRankingRow extends StatelessWidget {
  const PlayerRankingRow({
    required this.score,
    this.isCurrentUser = false,
    super.key,
  });

  final PlayerScore score;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        border: isCurrentUser
            ? Border.all(color: AppColors.accent, width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          RankBadge(rank: score.rank),
          const SizedBox(width: AppSpacing.sm),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceElevated,
            backgroundImage:
                score.avatarUrl != null ? NetworkImage(score.avatarUrl!) : null,
            child: score.avatarUrl == null
                ? Text(
                    score.displayName.isNotEmpty
                        ? score.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              score.displayName,
              style: AppTypography.body.copyWith(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (score.rankDelta != 0) ...[
            Icon(
              score.rankImproved
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 14,
              color: score.rankImproved
                  ? AppColors.success
                  : AppColors.danger,
            ),
            Text(
              '${score.rankDelta.abs()}',
              style: AppTypography.caption.copyWith(
                color: score.rankImproved
                    ? AppColors.success
                    : AppColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            '${score.questsCompleted} done',
            style: AppTypography.caption.copyWith(fontSize: 11),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '${score.score}',
            style: AppTypography.h3.copyWith(
              color: AppColors.primary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
