import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../scoreboard/presentation/widgets/rank_badge.dart';
import '../../domain/leaderboard_entry.dart';

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({
    required this.entry,
    this.isCurrentUser = false,
    super.key,
  });

  final LeaderboardEntry entry;
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
            ? const Border(
                left: BorderSide(color: AppColors.accent, width: 3))
            : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          RankBadge(rank: entry.rank),
          const SizedBox(width: AppSpacing.sm),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceElevated,
            backgroundImage: entry.avatarUrl != null
                ? NetworkImage(entry.avatarUrl!)
                : null,
            child: entry.avatarUrl == null
                ? Text(
                    entry.displayName.isNotEmpty
                        ? entry.displayName[0].toUpperCase()
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
              entry.displayName,
              style: AppTypography.body.copyWith(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (entry.gamesPlayed > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Text(
                '${entry.gamesPlayed} games',
                style: AppTypography.caption.copyWith(fontSize: 11),
              ),
            ),
          Text(
            '${entry.totalPoints}',
            style: AppTypography.h3.copyWith(
              color: AppColors.accent,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
