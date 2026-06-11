import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/qh_button.dart';
import '../../../../features/chat/presentation/providers/chat_providers.dart';
import '../../../../features/chat/presentation/widgets/chat_panel.dart';
import '../../../../features/chat/presentation/widgets/chat_toggle_button.dart';
import '../../../../features/scoreboard/presentation/widgets/live_scoreboard_sheet.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../room/domain/room.dart';
import '../../../room/presentation/providers/room_providers.dart';
import '../../domain/quest.dart';
import '../providers/quest_providers.dart';
import '../widgets/category_icon.dart';
import '../widgets/difficulty_badge.dart';
import '../widgets/quest_countdown_timer.dart';
import '../widgets/quest_expired_overlay.dart';

class ActiveQuestScreen extends ConsumerStatefulWidget {
  const ActiveQuestScreen({required this.roomId, super.key});

  final String roomId;

  @override
  ConsumerState<ActiveQuestScreen> createState() => _ActiveQuestScreenState();
}

class _ActiveQuestScreenState extends ConsumerState<ActiveQuestScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _showExpiredOverlay = false;
  bool _timerStarted = false;
  bool _isChatOpen = false;
  int _unreadCount = 0;
  int _lastMessageCount = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(QuestAssignment quest) {
    if (_timerStarted) return;
    _timerStarted = true;
    _totalSeconds = quest.durationSeconds;
    final elapsed =
        DateTime.now().toUtc().difference(quest.assignedAt).inSeconds;
    _remainingSeconds = (_totalSeconds - elapsed).clamp(0, _totalSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds = (_remainingSeconds - 1).clamp(0, _totalSeconds);
        if (_remainingSeconds <= 0 && !_showExpiredOverlay) {
          _showExpiredOverlay = true;
          _timer?.cancel();
          _autoDismiss();
        }
      });
    });
  }

  void _autoDismiss() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go('/room/${widget.roomId}');
    });
  }

  void _submitProof(QuestAssignment quest) {
    context.go(
      AppRoutes.proofCapture(widget.roomId),
      extra: quest,
    );
  }

  Future<void> _confirmSkip() async {
    final skip = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: const Text('Skip quest?', style: AppTypography.h2),
        content: const Text(
          'Skipping will cost you 10 points. You can only skip once per game.',
          style: AppTypography.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Skip (-10 pts)',
              style: AppTypography.link.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (skip != true || !mounted) return;

    final userId = ref.read(authRepositoryProvider).currentUserId;
    if (userId == null) return;
    await ref.read(questRepositoryProvider).skipQuest(
      widget.roomId,
      userId,
    );
    _timer?.cancel();
    if (mounted) context.go('/room/${widget.roomId}');
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

  void _openScoreboard() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (context, scrollController) => LiveScoreboardSheet(
          roomId: widget.roomId,
          scrollController: scrollController,
          onClose: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questAsync = ref.watch(myQuestProvider(widget.roomId));
    final hasSkipped = ref.watch(hasSkippedInRoomProvider(widget.roomId));

    // Navigate to post-game when finished
    ref.listen(roomProvider(widget.roomId), (previous, next) {
      next.when(
        data: (room) {
          if (room.status == RoomStatus.finished &&
              previous?.asData?.value.status != RoomStatus.finished) {
            context.go('/room/${widget.roomId}/results');
          }
        },
        error: (_, _) {},
        loading: () {},
      );
    });

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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            questAsync.when(
              data: (assignment) {
                if (assignment == null) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          'Assigning your quest\u2026',
                          style: AppTypography.bodySecondary,
                        ),
                      ],
                    ),
                  );
                }

                if (!_timerStarted) _startTimer(assignment);

                if (assignment.status == QuestAssignmentStatus.skipped) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) context.go('/room/${widget.roomId}');
                  });
                  return const SizedBox.shrink();
                }

                return _QuestBody(
                  quest: assignment,
                  remainingSeconds: _remainingSeconds,
                  totalSeconds: _totalSeconds,
                  hasSkipped: hasSkipped,
                  onSubmitProof: () => _submitProof(assignment),
                  onSkip: _confirmSkip,
                );
              },
              error: (error, _) => Center(
                child: Text(
                  'Failed to load quest: $error',
                  style: AppTypography.bodySecondary,
                ),
              ),
              loading: () => const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Assigning your quest\u2026',
                      style: AppTypography.bodySecondary,
                    ),
                  ],
                ),
              ),
            ),
            if (_showExpiredOverlay)
              const QuestExpiredOverlay(),
            Positioned(
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'scoreboard',
                    mini: true,
                    backgroundColor: AppColors.warning,
                    onPressed: _openScoreboard,
                    child: const Icon(Icons.emoji_events,
                        color: Colors.black, size: 20),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ChatToggleButton(
                    unreadCount: _unreadCount,
                    onTap: _openChat,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestBody extends StatelessWidget {
  const _QuestBody({
    required this.quest,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.hasSkipped,
    required this.onSubmitProof,
    required this.onSkip,
  });

  final QuestAssignment quest;
  final int remainingSeconds;
  final int totalSeconds;
  final bool hasSkipped;
  final VoidCallback onSubmitProof;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          CategoryIcon(category: quest.category, size: 56),
          const SizedBox(height: AppSpacing.md),
          DifficultyBadge(difficulty: quest.difficulty),
          const SizedBox(height: AppSpacing.md),
          Text(
            quest.title,
            style: AppTypography.h1.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            quest.description,
            style: AppTypography.bodySecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: quest.points),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) => Text(
              '+$value pts',
              style: AppTypography.scoreMedium.copyWith(
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          QuestCountdownTimer(
            totalSeconds: totalSeconds,
            remainingSeconds: remainingSeconds,
          ),
          const SizedBox(height: AppSpacing.xl),
          QhButton(
            label: 'Submit Proof',
            onPressed: onSubmitProof,
          ),
          const SizedBox(height: AppSpacing.md),
          if (!hasSkipped)
            TextButton(
              onPressed: onSkip,
              child: Text(
                'Skip quest (-10 pts)',
                style: AppTypography.link.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
