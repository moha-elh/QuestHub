import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/qh_button.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
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

  @override
  Widget build(BuildContext context) {
    final questAsync = ref.watch(myQuestProvider(widget.roomId));
    final hasSkipped = ref.watch(hasSkippedInRoomProvider(widget.roomId));

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
