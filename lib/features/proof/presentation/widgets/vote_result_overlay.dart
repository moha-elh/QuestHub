import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/vote_logic.dart';

class VoteResultOverlay extends StatefulWidget {
  const VoteResultOverlay({
    required this.result,
    required this.fakeVoterNames,
    required this.onDismiss,
    super.key,
  });

  final VoteResult result;
  final List<String> fakeVoterNames;
  final VoidCallback onDismiss;

  @override
  State<VoteResultOverlay> createState() => _VoteResultOverlayState();
}

class _VoteResultOverlayState extends State<VoteResultOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _controller.forward();
    _dismissTimer = Timer(const Duration(seconds: 3), widget.onDismiss);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;

    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.black87,
        child: Stack(
          children: [
            Center(
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildVerdict(result),
                      const SizedBox(height: AppSpacing.lg),
                      _buildPointDelta(result),
                      const SizedBox(height: AppSpacing.lg),
                      if (result.isRejected && widget.fakeVoterNames.isNotEmpty)
                        _buildFakeVoters(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerdict(VoteResult result) {
    final approved = result.approved;
    return Column(
      children: [
        Icon(
          approved ? Icons.check_circle : Icons.cancel,
          color: approved ? AppColors.success : AppColors.danger,
          size: 64,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          approved ? 'PROOF APPROVED' : 'PROOF REJECTED',
          style: AppTypography.h1.copyWith(
            fontSize: 28,
            color: approved ? AppColors.success : AppColors.danger,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPointDelta(VoteResult result) {
    final points = result.pointDelta.abs();
    final isPositive = result.pointDelta > 0;
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: points),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) => Text(
        '${isPositive ? '+' : '-'}$value',
        style: AppTypography.scoreLarge.copyWith(
          color: isPositive ? AppColors.success : AppColors.danger,
        ),
      ),
    );
  }

  Widget _buildFakeVoters() {
    return Column(
      children: [
        const Text(
          'Voted Fake:',
          style: AppTypography.caption,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: widget.fakeVoterNames
              .map((name) => Chip(
                    label: Text(name, style: AppTypography.caption),
                    backgroundColor: AppColors.danger.withValues(alpha: 0.15),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
