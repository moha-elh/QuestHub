import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/proof.dart';

class ProofCard extends StatelessWidget {
  const ProofCard({required this.proof, super.key});

  final Proof proof;

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().toUtc().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  proof.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stack) => const Center(
                    child: Icon(Icons.broken_image, color: AppColors.textFaint),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '+${proof.questPoints} pts',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.sm,
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: proof.submitterAvatarUrl != null
                          ? NetworkImage(proof.submitterAvatarUrl!)
                          : null,
                      child: proof.submitterAvatarUrl == null
                          ? Text(
                              proof.submitterName.isNotEmpty
                                  ? proof.submitterName[0].toUpperCase()
                                  : '?',
                              style: AppTypography.caption,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        proof.submitterName,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    proof.questTitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _relativeTime(proof.submittedAt),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
