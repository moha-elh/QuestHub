import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class QuestCompletedOverlay extends StatelessWidget {
  const QuestCompletedOverlay({required this.points, super.key});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 80),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Quest Complete!',
              style: AppTypography.h1,
            ),
            const SizedBox(height: AppSpacing.sm),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: points),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) => Text(
                '+$value',
                style: AppTypography.scoreLarge.copyWith(
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
