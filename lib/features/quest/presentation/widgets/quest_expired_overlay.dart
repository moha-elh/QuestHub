import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class QuestExpiredOverlay extends StatelessWidget {
  const QuestExpiredOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_off, color: AppColors.danger, size: 80),
            SizedBox(height: AppSpacing.md),
            Text(
              "Time's Up!",
              style: AppTypography.h1,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'No points earned',
              style: AppTypography.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
