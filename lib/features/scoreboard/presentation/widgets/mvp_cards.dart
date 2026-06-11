import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/mvp_data.dart';

class MvpCards extends StatelessWidget {
  const MvpCards({required this.mvp, super.key});

  final MvpData mvp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: mvp.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = mvp.all[index];
          return _MvpCard(
            category: category,
            delay: index * 0.15,
          );
        },
      ),
    );
  }
}

class _MvpCard extends StatelessWidget {
  const _MvpCard({required this.category, required this.delay});

  final MvpCategory category;
  final double delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(40 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(category.icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    category.title,
                    style: AppTypography.caption.copyWith(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              category.playerName,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              category.value,
              style: AppTypography.caption.copyWith(
                color: AppColors.accent,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
