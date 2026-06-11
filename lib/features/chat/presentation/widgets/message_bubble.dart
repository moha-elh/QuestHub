import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../room/domain/room.dart';
import '../../domain/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.isOwn,
    this.players,
    this.onReact,
    super.key,
  });

  final Message message;
  final bool isOwn;
  final Map<String, RoomPlayer>? players;
  final void Function(String emoji)? onReact;

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) return _buildSystemMessage();

    final alignment = isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubble = _buildBubble(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isOwn) _buildAvatar(),
              if (!isOwn) const SizedBox(width: AppSpacing.sm),
              Flexible(child: bubble),
              if (isOwn) const SizedBox(width: AppSpacing.xs),
            ],
          ),
          if (message.reactions.isNotEmpty) _buildReactions(),
        ],
      ),
    );
  }

  Widget _buildSystemMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xs,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            message.content,
            style: AppTypography.caption.copyWith(
              color: AppColors.textFaint,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = message.senderAvatarUrl;
    return CircleAvatar(
      radius: 12,
      backgroundColor: AppColors.surfaceElevated,
      backgroundImage:
          avatarUrl != null ? NetworkImage(avatarUrl) : null,
      child: avatarUrl == null
          ? Text(
              message.senderName.isNotEmpty
                  ? message.senderName[0].toUpperCase()
                  : '?',
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            )
          : null,
    );
  }

  Widget _buildBubble(BuildContext context) {
    final radius = AppRadius.md;
    final borderRadius = isOwn
        ? BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            bottomRight: const Radius.circular(AppRadius.sm),
          )
        : BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.sm),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          );

    return GestureDetector(
      onLongPress: onReact != null
          ? () => _showReactionPicker(context)
          : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isOwn
                ? AppColors.primary.withValues(alpha: 0.85)
                : AppColors.surfaceElevated,
            borderRadius: borderRadius,
          ),
          child: Text(
            message.content,
            style: AppTypography.body.copyWith(
              color: isOwn ? AppColors.textOnPrimary : AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReactions() {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSpacing.xs,
        left: isOwn ? 0 : 28,
        right: isOwn ? 28 : 0,
      ),
      child: Wrap(
        spacing: AppSpacing.xs,
        children: message.reactions.entries.map((entry) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '${entry.key} ${entry.value.length}',
              style: AppTypography.caption.copyWith(fontSize: 11),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showReactionPicker(BuildContext context) {
    const emojis = ['👀', '😂', '🔥', '💀', '👏', '😤'];
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: emojis.map((e) {
        return PopupMenuItem<String>(
          value: e,
          height: 36,
          child: Text(e, style: const TextStyle(fontSize: 26)),
        );
      }).toList(),
    ).then((emoji) {
      if (emoji != null) onReact?.call(emoji);
    });
  }
}
