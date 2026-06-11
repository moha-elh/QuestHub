import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/scoreboard_providers.dart';
import 'player_ranking_row.dart';

class LiveScoreboardSheet extends ConsumerWidget {
  const LiveScoreboardSheet({
    required this.roomId,
    required this.scrollController,
    required this.onClose,
    super.key,
  });

  final String roomId;
  final ScrollController scrollController;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = ref.watch(sortedPlayersProvider(roomId));
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          const Divider(height: 1, color: AppColors.outline),
          Expanded(
            child: scores.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: scrollController,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      final ps = scores[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        child: PlayerRankingRow(
                          score: ps,
                          isCurrentUser: ps.playerId == currentUserId,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textFaint.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.warning, size: 20),
          const SizedBox(width: AppSpacing.sm),
          const Text('Scoreboard', style: AppTypography.h3),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onClose,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events,
              size: 48, color: AppColors.textFaint.withValues(alpha: 0.3)),
          const SizedBox(height: AppSpacing.md),
          Text('No scores yet', style: AppTypography.bodySecondary),
          Text(
            'Scores will appear as quests are completed',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}
