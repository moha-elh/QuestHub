import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../room/domain/room.dart';
import '../../domain/proof.dart';

class VoteIndicatorRow extends StatelessWidget {
  const VoteIndicatorRow({
    required this.players,
    required this.proof,
    required this.currentUserId,
    super.key,
  });

  final Map<String, RoomPlayer> players;
  final Proof proof;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final eligible = players.entries
        .where((e) => e.key != proof.submitterId)
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final entry in eligible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: _PlayerVoteAvatar(
              player: entry.value,
              vote: proof.votes[entry.key],
              isSelf: entry.key == currentUserId,
            ),
          ),
        if (eligible.isEmpty)
          const Text(
            'No other players to vote',
            style: TextStyle(color: AppColors.textFaint, fontSize: 12),
          ),
      ],
    );
  }
}

class _PlayerVoteAvatar extends StatelessWidget {
  const _PlayerVoteAvatar({
    required this.player,
    required this.vote,
    required this.isSelf,
  });

  final RoomPlayer player;
  final String? vote;
  final bool isSelf;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: player.displayName,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelf ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceElevated,
              backgroundImage: player.avatarUrl != null
                  ? NetworkImage(player.avatarUrl!)
                  : null,
              child: player.avatarUrl == null
                  ? Text(
                      player.displayName.isNotEmpty
                          ? player.displayName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    )
                  : null,
            ),
            if (vote != null)
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: vote == 'real'
                        ? AppColors.success
                        : AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      vote == 'real' ? '\u2713' : '\u2717',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            else
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.outline,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '\u23F3',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
