import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/qh_button.dart';
import '../../../../features/chat/presentation/providers/chat_providers.dart';
import '../../../../features/chat/presentation/widgets/chat_panel.dart';
import '../../../../features/chat/presentation/widgets/chat_toggle_button.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/room.dart';
import '../providers/lobby_heartbeat.dart';
import '../providers/room_controller.dart';
import '../providers/room_providers.dart';
import '../widgets/lobby_player_list.dart';
import '../widgets/room_code_display.dart';

/// Waiting lobby: live player list, ready toggle, host start control.
class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({required this.roomId, super.key});

  final String roomId;

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  bool _isChatOpen = false;
  int _unreadCount = 0;
  int _lastMessageCount = 0;

  Future<void> _confirmLeave() async {
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

    await ref.read(roomControllerProvider.notifier).leaveRoom(widget.roomId);
    if (context.mounted) context.go('/home');
  }

  void _openChat() {
    setState(() {
      _isChatOpen = true;
      _unreadCount = 0;
    });
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (context, scrollController) => ChatPanel(
          roomId: widget.roomId,
          scrollController: scrollController,
          onClose: () => Navigator.of(ctx).pop(),
        ),
      ),
    ).whenComplete(() {
      if (mounted) setState(() => _isChatOpen = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep our presence heartbeat alive while this screen is mounted.
    ref.watch(lobbyHeartbeatProvider(widget.roomId));

    // Track messages for unread count
    ref.listen(messagesProvider(widget.roomId), (prev, next) {
      next.whenData((messages) {
        if (!_isChatOpen && messages.length > _lastMessageCount) {
          final delta = messages.length - _lastMessageCount;
          setState(() => _unreadCount += delta);
        }
        _lastMessageCount = messages.length;
      });
    });

    // Navigate to quest on game start; to results on game end; back home on room deletion.
    ref.listen(roomProvider(widget.roomId), (previous, next) {
      next.when(
        data: (room) {
          if (room.status == RoomStatus.inProgress &&
              previous?.asData?.value.status != RoomStatus.inProgress) {
            context.go('/room/${widget.roomId}/quest');
          }
          if (room.status == RoomStatus.finished &&
              previous?.asData?.value.status != RoomStatus.finished) {
            context.go('/room/${widget.roomId}/results');
          }
        },
        error: (_, _) {
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

    final roomAsync = ref.watch(roomProvider(widget.roomId));
    final uid = ref.watch(authRepositoryProvider).currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
        leading: IconButton(
          tooltip: 'Leave room',
          icon: const Icon(Icons.close),
          onPressed: _confirmLeave,
        ),
      ),
      body: SafeArea(
            child: switch (roomAsync) {
          AsyncData(value: final room) => Stack(
              children: [
                _LobbyBody(
                  room: room,
                  uid: uid,
                  onEndGame: room.status == RoomStatus.inProgress && uid != null && uid == room.hostId
                      ? () => ref.read(roomControllerProvider.notifier).endGame(widget.roomId)
                      : null,
                ),
                Positioned(
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: ChatToggleButton(
                    unreadCount: _unreadCount,
                    onTap: _openChat,
                  ),
                ),
              ],
            ),
          AsyncError() => const SizedBox.shrink(),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _LobbyBody extends ConsumerWidget {
  const _LobbyBody({
    required this.room,
    required this.uid,
    this.onEndGame,
  });

  final Room room;
  final String? uid;
  final VoidCallback? onEndGame;

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
              onPressed: room.canStart && !isLoading
                  ? () => controller.startGame(room.id)
                  : null,
            ),
          ],
          if (onEndGame != null) ...[
            const SizedBox(height: AppSpacing.md),
            QhButton(
              label: 'End Game',
              variant: QhButtonVariant.secondary,
              onPressed: onEndGame,
            ),
          ],
        ],
      ),
    );
  }
}
