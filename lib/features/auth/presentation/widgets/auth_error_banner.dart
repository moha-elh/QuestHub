import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/auth_repository.dart';
import '../providers/auth_controller.dart';

/// Animated banner that surfaces the latest auth error, if any.
class AuthErrorBanner extends ConsumerWidget {
  const AuthErrorBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(authControllerProvider).error;

    final message = switch (error) {
      null => null,
      final AuthException e => e.message,
      _ => 'Something went wrong. Please try again.',
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(sizeFactor: animation, child: child),
      ),
      child: message == null
          ? const SizedBox.shrink()
          : Container(
              key: ValueKey(message),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.danger.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                message,
                style: AppTypography.body.copyWith(color: AppColors.danger),
              ),
            ),
    );
  }
}
