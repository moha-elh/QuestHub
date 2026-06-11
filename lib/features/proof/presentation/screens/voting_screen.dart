import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../room/domain/room.dart';
import '../../../room/presentation/providers/room_providers.dart';
import '../../domain/proof.dart';
import '../../domain/vote_logic.dart';
import '../providers/proof_providers.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/proof_card.dart';
import '../widgets/vote_indicator_row.dart';
import '../widgets/vote_result_overlay.dart';

class VotingScreen extends ConsumerStatefulWidget {
  const VotingScreen({
    required this.roomId,
    required this.proofId,
    super.key,
  });

  final String roomId;
  final String proofId;

  @override
  ConsumerState<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends ConsumerState<VotingScreen> {
  Timer? _timer;
  int _remainingSeconds = 30;
  String? _selectedVote;
  bool _showResult = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds = max(0, _remainingSeconds - 1);
      });
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
      }
    });
  }

  void _submitVote(Proof proof) async {
    final vote = _selectedVote;
    if (vote == null || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      await ref.read(proofRepositoryProvider).castVote(
        roomId: widget.roomId,
        proofId: widget.proofId,
        vote: vote,
      );
    } catch (_) {}
    if (mounted) setState(() => _isSubmitting = false);
  }

  void _onVerdictDismiss() {
    if (mounted) context.go('/room/${widget.roomId}');
  }

  @override
  Widget build(BuildContext context) {
    final proofAsync = ref.watch(
      proofByIdProvider((roomId: widget.roomId, proofId: widget.proofId)),
    );
    final roomAsync = ref.watch(roomProvider(widget.roomId));
    final uid = ref.watch(authRepositoryProvider).currentUserId;

    return Scaffold(
      backgroundColor: Colors.black,
      body: proofAsync.when(
        data: (proof) {
          final room = roomAsync.asData?.value;
          final players = room?.players ?? <String, RoomPlayer>{};
          final isSubmitter = uid == proof.submitterId;
          final eligibleCount =
              players.keys.where((k) => k != proof.submitterId).length;

          if (proof.isResolved && !_showResult) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _showResult = true);
            });
          }

          if (_showResult) {
            final result = evaluateVoteResult(
              proof: proof,
              eligibleVoterCount: eligibleCount,
            );
            final fakeVoterNames = result.fakeVoterIds
                .map((id) => players[id]?.displayName ?? 'Unknown')
                .toList();
            return VoteResultOverlay(
              result: result,
              fakeVoterNames: fakeVoterNames,
              onDismiss: _onVerdictDismiss,
            );
          }

          return SafeArea(
            child: Column(
              children: [
                _buildTopBar(proof, eligibleCount),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildQuestInfo(proof),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenPadding,
                          ),
                          child: ProofCard(proof: proof),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildSubmitterInfo(proof),
                        const SizedBox(height: AppSpacing.lg),
                        if (isSubmitter)
                          _buildSubmitterView(proof, players, uid)
                        else
                          _buildVoterView(proof),
                        const SizedBox(height: AppSpacing.lg),
                        _buildVoteCount(proof, eligibleCount),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, _) => Center(
          child: Text('Error: $error',
              style: const TextStyle(color: AppColors.danger)),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildTopBar(Proof proof, int eligibleCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => context.go('/room/${widget.roomId}'),
          ),
          const Spacer(),
          CountdownRing(
            remainingSeconds: _remainingSeconds,
            totalSeconds: 30,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '${proof.votes.length} of $eligibleCount voted',
            style: AppTypography.caption.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestInfo(Proof proof) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Text(
            proof.questTitle,
            style: AppTypography.h2.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${proof.questPoints} points at stake',
            style: AppTypography.caption.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitterInfo(Proof proof) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: proof.submitterAvatarUrl != null
                ? NetworkImage(proof.submitterAvatarUrl!)
                : null,
            child: proof.submitterAvatarUrl == null
                ? Text(
                    proof.submitterName.isNotEmpty
                        ? proof.submitterName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 14),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            proof.submitterName,
            style: AppTypography.body.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildVoterView(Proof proof) {
    final selected = _selectedVote;
    final expired = _remainingSeconds <= 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _VoteButton(
                  label: 'Real \u2713',
                  icon: Icons.check_circle,
                  selected: selected == 'real',
                  color: AppColors.success,
                  onTap: _isSubmitting || expired
                      ? null
                      : () {
                          setState(() => _selectedVote = 'real');
                          _submitVote(proof);
                        },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _VoteButton(
                  label: 'Fake \u2717',
                  icon: Icons.cancel,
                  selected: selected == 'fake',
                  color: AppColors.danger,
                  onTap: _isSubmitting || expired
                      ? null
                      : () {
                          setState(() => _selectedVote = 'fake');
                          _submitVote(proof);
                        },
                ),
              ),
            ],
          ),
          if (selected != null && !expired)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Tap again to change your vote',
                style: AppTypography.caption.copyWith(
                  color: Colors.white38,
                ),
              ),
            ),
          if (expired && selected == null)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Time\u2019s up! Waiting for results\u2026',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitterView(
    Proof proof,
    Map<String, RoomPlayer> players,
    String? uid,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          const Text(
            'Waiting for votes\u2026',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          VoteIndicatorRow(
            players: players,
            proof: proof,
            currentUserId: uid,
          ),
        ],
      ),
    );
  }

  Widget _buildVoteCount(Proof proof, int eligibleCount) {
    return Text(
      '${proof.votes.length} of $eligibleCount players voted',
      style: AppTypography.caption.copyWith(color: Colors.white38),
    );
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selected ? color : color.withValues(alpha: 0.15),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: BorderSide(
                color: selected ? color : color.withValues(alpha: 0.3),
                width: selected ? 2 : 1,
              ),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: selected ? Colors.white : color),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTypography.button.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
