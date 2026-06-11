import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/qh_button.dart';
import '../providers/room_controller.dart';
import 'room_error_banner.dart';

/// Bottom sheet for configuring and creating a room.
Future<void> showCreateRoomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surfaceElevated,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (_) => const CreateRoomSheet(),
  );
}

class CreateRoomSheet extends ConsumerStatefulWidget {
  const CreateRoomSheet({super.key});

  @override
  ConsumerState<CreateRoomSheet> createState() => _CreateRoomSheetState();
}

class _CreateRoomSheetState extends ConsumerState<CreateRoomSheet> {
  bool _isPublic = false;
  int _maxPlayers = 8;

  Future<void> _create() async {
    final roomId = await ref.read(roomControllerProvider.notifier).createRoom(
          isPublic: _isPublic,
          maxPlayers: _maxPlayers,
        );
    if (roomId != null && mounted) {
      // Replace the sheet + home with the lobby.
      context.go('/room/$roomId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(roomControllerProvider).isLoading;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        // Keep the button above the keyboard / gesture area.
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('New room', style: AppTypography.h2),
          const SizedBox(height: AppSpacing.lg),
          const RoomErrorBanner(),
          SwitchListTile(
            value: _isPublic,
            onChanged: isLoading
                ? null
                : (value) => setState(() => _isPublic = value),
            contentPadding: EdgeInsets.zero,
            activeTrackColor: AppColors.primary,
            title: const Text('Public room', style: AppTypography.h3),
            subtitle: Text(
              _isPublic
                  ? 'Anyone can quick-match into this room.'
                  : 'Only players with the code can join.',
              style: AppTypography.caption,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Max players', style: AppTypography.h3),
              Text('$_maxPlayers', style: AppTypography.scoreMedium),
            ],
          ),
          Slider(
            value: _maxPlayers.toDouble(),
            min: 2,
            max: 8,
            divisions: 6,
            onChanged: isLoading
                ? null
                : (value) => setState(() => _maxPlayers = value.round()),
          ),
          const SizedBox(height: AppSpacing.lg),
          QhButton(
            label: 'Create room',
            isLoading: isLoading,
            onPressed: _create,
          ),
        ],
      ),
    );
  }
}
