import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/qh_button.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../room/presentation/providers/room_controller.dart';
import '../../../room/presentation/providers/room_providers.dart';
import '../../domain/player_score.dart';
import '../providers/scoreboard_providers.dart';
import '../widgets/mvp_cards.dart';
import '../widgets/player_ranking_row.dart';
import '../widgets/podium_section.dart';

class PostGameScreen extends ConsumerStatefulWidget {
  const PostGameScreen({required this.roomId, super.key});

  final String roomId;

  @override
  ConsumerState<PostGameScreen> createState() => _PostGameScreenState();
}

class _PostGameScreenState extends ConsumerState<PostGameScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomAsync = ref.watch(roomProvider(widget.roomId));
    final scores = ref.watch(sortedPlayersProvider(widget.roomId));
    final uid = ref.watch(authRepositoryProvider).currentUserId;

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.accent,
                AppColors.warning,
                AppColors.success,
              ],
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
          SafeArea(
            child: roomAsync.when(
              data: (room) {
                final isHost = uid != null && uid == room.hostId;
                return _buildContent(scores, isHost);
              },
              error: (_, _) => _buildError(),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<PlayerScore> scores, bool isHost) {
    final topScores = scores.length > 3 ? scores.sublist(0, 3) : scores;
    final restScores =
        scores.length > 3 ? scores.sublist(3) : <PlayerScore>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Game Over!',
            style: AppTypography.h1,
          ),
          const SizedBox(height: AppSpacing.lg),
          PodiumSection(topScores: topScores.cast()),
          const SizedBox(height: AppSpacing.xl),
          if (restScores.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Rankings', style: AppTypography.h3),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...restScores.map((score) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: PlayerRankingRow(score: score),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('MVPs', style: AppTypography.h3),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 130,
            child: ref.watch(mvpStatsProvider(widget.roomId)).when(
              data: (mvp) {
                if (mvp == null) {
                  return Center(
                    child: Text(
                      'Not enough data yet',
                      style: AppTypography.bodySecondary,
                    ),
                  );
                }
                return MvpCards(mvp: mvp);
              },
              error: (_, _) => Center(
                child: Text(
                  'Could not load MVPs',
                  style: AppTypography.body.copyWith(color: AppColors.danger),
                ),
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (isHost)
            QhButton(
              label: 'Play Again',
              onPressed: () => _resetGame(),
            ),
          const SizedBox(height: AppSpacing.md),
          QhButton(
            label: 'Leave',
            variant: QhButtonVariant.secondary,
            onPressed: () => context.go('/home'),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Could not load game results',
            style: AppTypography.body.copyWith(color: AppColors.danger),
          ),
          const SizedBox(height: AppSpacing.md),
          QhButton(
            label: 'Go Home',
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetGame() async {
    await ref.read(roomControllerProvider.notifier).resetGame(widget.roomId);
    if (mounted) context.go('/room/${widget.roomId}');
  }
}
