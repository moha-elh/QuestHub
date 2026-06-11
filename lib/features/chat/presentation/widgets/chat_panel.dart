import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../room/domain/room.dart';
import '../../domain/message.dart';
import '../providers/chat_providers.dart';
import 'chat_input.dart';
import 'message_bubble.dart';

class ChatPanel extends ConsumerStatefulWidget {
  const ChatPanel({
    required this.roomId,
    required this.scrollController,
    required this.onClose,
    this.players,
    super.key,
  });

  final String roomId;
  final ScrollController scrollController;
  final VoidCallback onClose;
  final Map<String, RoomPlayer>? players;

  @override
  ConsumerState<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends ConsumerState<ChatPanel> {
  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.roomId));

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
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) return _buildEmptyState();
                return ListView.builder(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isOwn = message.senderId ==
                        ref.read(authRepositoryProvider).currentUserId;
                    return MessageBubble(
                      message: message,
                      isOwn: isOwn,
                      players: widget.players,
                      onReact: (emoji) => _onReact(message, emoji),
                    );
                  },
                );
              },
              error: (_, _) => Center(
                child: Text(
                  'Failed to load messages',
                  style: AppTypography.body.copyWith(color: AppColors.danger),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          ChatInput(
            roomId: widget.roomId,
            scrollController: widget.scrollController,
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
          const Text('Chat', style: AppTypography.h3),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: widget.onClose,
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
          Icon(Icons.chat_bubble_outline,
              size: 48, color: AppColors.textFaint.withValues(alpha: 0.3)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No messages yet',
            style: AppTypography.bodySecondary,
          ),
          Text(
            'Be the first to say something!',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }

  void _onReact(Message message, String emoji) async {
    final uid = ref.read(authRepositoryProvider).currentUserId;
    if (uid == null) return;

    final hasReacted = message.reactions[emoji]?.contains(uid) ?? false;
    final repo = ref.read(chatRepositoryProvider);

    try {
      if (hasReacted) {
        await repo.removeReaction(
          roomId: widget.roomId,
          messageId: message.id,
          emoji: emoji,
        );
      } else {
        await repo.addReaction(
          roomId: widget.roomId,
          messageId: message.id,
          emoji: emoji,
        );
      }
    } catch (_) {}
  }
}
