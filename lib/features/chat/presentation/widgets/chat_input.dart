import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/chat_providers.dart';

class ChatInput extends ConsumerStatefulWidget {
  const ChatInput({
    required this.roomId,
    required this.scrollController,
    super.key,
  });

  final String roomId;
  final ScrollController scrollController;

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final _controller = TextEditingController();
  Timer? _typingTimer;

  @override
  void dispose() {
    _controller.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.isEmpty) return;
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(chatRepositoryProvider).updateTyping(widget.roomId);
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    _typingTimer?.cancel();

    try {
      await ref.read(chatRepositoryProvider).sendMessage(
            roomId: widget.roomId,
            content: text,
          );
      // Scroll to bottom after send
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final typingAsync = ref.watch(typingUsersProvider(widget.roomId));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        typingAsync.when(
          data: (users) {
            if (users.isEmpty) return const SizedBox.shrink();
            final names = users.take(2).join(', ');
            return Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                bottom: AppSpacing.xs,
              ),
              child: Text(
                users.length <= 2
                    ? '$names is typing\u2026'
                    : 'Several people are typing\u2026',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textFaint,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          },
          error: (_, _) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.xs,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: 500,
                  maxLines: 4,
                  minLines: 1,
                  onChanged: _onChanged,
                  onSubmitted: (_) => _send(),
                  textInputAction: TextInputAction.send,
                  style: AppTypography.body.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Send a message\u2026',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.textFaint,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceElevated,
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: _send,
                tooltip: 'Send',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
