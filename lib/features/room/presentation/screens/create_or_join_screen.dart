import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/qh_button.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../providers/room_controller.dart';
import '../widgets/create_room_sheet.dart';
import '../widgets/room_error_banner.dart';

/// Home screen: the entry point into a game — create, join, or quick match.
class CreateOrJoinScreen extends ConsumerWidget {
  const CreateOrJoinScreen({super.key});

  Future<void> _quickMatch(BuildContext context, WidgetRef ref) async {
    final roomId =
        await ref.read(roomControllerProvider.notifier).joinPublic();
    if (roomId != null && context.mounted) context.go('/room/$roomId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(roomControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuestHub'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.lg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.travel_explore,
                    size: 56,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Ready for a side quest?',
                    style: AppTypography.h1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Gather your crew or get matched with strangers.',
                    style: AppTypography.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const RoomErrorBanner(),
                  QhButton(
                    label: 'Create room',
                    icon: const Icon(Icons.add, size: 20),
                    onPressed:
                        isLoading ? null : () => showCreateRoomSheet(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  QhButton(
                    label: 'Join with code',
                    variant: QhButtonVariant.secondary,
                    icon: const Icon(Icons.pin, size: 20),
                    onPressed: isLoading ? null : () => context.go('/join'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  QhButton(
                    label: 'Quick match',
                    variant: QhButtonVariant.secondary,
                    icon: const Icon(Icons.bolt, size: 20),
                    isLoading: isLoading,
                    onPressed: () => _quickMatch(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
