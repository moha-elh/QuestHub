import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/room_controller.dart';
import '../widgets/room_code_input.dart';
import '../widgets/room_error_banner.dart';

/// Enter a 6-digit code to join a friend's room.
class JoinRoomScreen extends ConsumerWidget {
  const JoinRoomScreen({super.key});

  Future<void> _join(BuildContext context, WidgetRef ref, String code) async {
    final roomId =
        await ref.read(roomControllerProvider.notifier).joinByCode(code);
    if (roomId != null && context.mounted) context.go('/room/$roomId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(roomControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join room'),
        leading: BackButton(onPressed: () => context.go('/home')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the room code',
                style: AppTypography.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Ask the host for their 6-digit code.',
                style: AppTypography.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              const RoomErrorBanner(),
              RoomCodeInput(
                enabled: !state.isLoading,
                onCompleted: (code) => _join(context, ref, code),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
