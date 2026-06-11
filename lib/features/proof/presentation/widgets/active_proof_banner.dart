import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/proof_providers.dart';

class ActiveProofBanner extends ConsumerWidget {
  const ActiveProofBanner({required this.roomId, super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proofAsync = ref.watch(activeProofProvider(roomId));

    return proofAsync.when(
      data: (proof) {
        if (proof == null) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.fiber_new, color: AppColors.primary, size: 18),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: Text(
                  'A new proof is waiting for votes!',
                  style: AppTypography.caption,
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Voting screen coming soon'),
                    ),
                  );
                },
                child: Text(
                  'View',
                  style: AppTypography.link.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
