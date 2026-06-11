import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/room.dart';
import 'ready_dot.dart';

/// One row in the lobby player list.
class PlayerCard extends StatelessWidget {
  const PlayerCard({
    required this.player,
    required this.isHost,
    required this.isSelf,
    super.key,
  });

  final RoomPlayer player;
  final bool isHost;
  final bool isSelf;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isSelf ? AppColors.primary : AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.surfaceElevated,
            foregroundImage:
                player.avatarUrl == null ? null : NetworkImage(player.avatarUrl!),
            child: Text(
              player.displayName.isEmpty
                  ? '?'
                  : player.displayName[0].toUpperCase(),
              style: AppTypography.h3,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    player.displayName,
                    style: AppTypography.h3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isHost) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(
                    Icons.workspace_premium,
                    size: 18,
                    color: AppColors.tierLegendary,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            player.isReady ? 'Ready' : 'Waiting',
            style: AppTypography.caption.copyWith(
              color:
                  player.isReady ? AppColors.success : AppColors.textFaint,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ReadyDot(isReady: player.isReady),
        ],
      ),
    );
  }
}
