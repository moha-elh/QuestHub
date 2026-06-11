import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/qh_button.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/room.dart';
import '../providers/lobby_heartbeat.dart';
import '../providers/room_controller.dart';
import '../providers/room_providers.dart';
import '../widgets/lobby_player_list.dart';
import '../widgets/room_code_display.dart';

/// Waiting lobby: live player list, ready toggle, host start control.
class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({required this.roomId, super.key});

  final String roomId;

  Future<void> _confirmLeave(BuildContext context, WidgetRef ref) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: const Text('Leave room?', style: AppTypography.h2),
        content: const Text(
          'You can rejoin with the room code while the lobby is open.',
          style: AppTypography.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Leave',
              style: AppTypography.link.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (leave != true) return;

    await ref.read(roomControllerProvider.notifier).leaveRoom(roomId);
    if (context.mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep our presence heartbeat alive while this screen is mounted.
    ref.watch(lobbyHeartbeatProvider(roomId));

    // Navigate to quest on game start; back home on room deletion.
    ref.listen(roomProvider(roomId), (previous, next) {
      next.when(
        data: (room) {
          if (room.status == RoomStatus.inProgress &&
              previous?.asData?.value.status != RoomStatus.inProgress) {
            context.go('/room/$roomId/quest');
          }
        },
        error: (_, __) {
          if (previous?.hasError != true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('The room was closed.')),
            );
            context.go('/home');
          }
        },
        loading: () {},
      );
    });

    final roomAsync = ref.watch(roomProvider(roomId));
    final uid = ref.watch(authRepositoryProvider).currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
        leading: IconButton(
          tooltip: 'Leave room',
          icon: const Icon(Icons.close),
          onPressed: () => _confirmLeave(context, ref),
        ),
      ),
      body: SafeArea(
        child: switch (roomAsync) {
          AsyncData(value: final room) => _LobbyBody(room: room, uid: uid),
          AsyncError() => const SizedBox.shrink(), // listener navigates home
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _LobbyBody extends ConsumerWidget {
  const _LobbyBody({required this.room, required this.uid});

  final Room room;
  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(roomControllerProvider.notifier);
    final isLoading = ref.watch(roomControllerProvider).isLoading;

    final self = uid == null ? null : room.players[uid];
    final isHost = uid != null && uid == room.hostId;
    final isReady = self?.isReady ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoomCodeDisplay(code: room.code),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Players ${room.players.length}/${room.maxPlayers}',
                style: AppTypography.h3,
              ),
              Text(
                '${room.readyCount} ready',
                style: AppTypography.caption.copyWith(
                  color: room.canStart
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: LobbyPlayerList(room: room, currentUserId: uid),
          ),
          const SizedBox(height: AppSpacing.md),
          QhButton(
            label: isReady ? 'Not ready' : "I'm ready",
            variant:
                isReady ? QhButtonVariant.secondary : QhButtonVariant.primary,
            onPressed: isLoading
                ? null
                : () => controller.setReady(room.id, isReady: !isReady),
          ),
          if (isHost) ...[
            const SizedBox(height: AppSpacing.md),
            QhButton(
              label: room.canStart
                  ? 'Start game'
                  : 'Start game (2+ ready needed)',
              isLoading: isLoading && room.canStart,
              // Disabled style (grey, no ripple) comes from the theme.
              onPressed: room.canStart && !isLoading
                  ? () => controller.startGame(room.id)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}
