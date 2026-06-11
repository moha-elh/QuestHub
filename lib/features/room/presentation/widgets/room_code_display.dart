import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// The room code, large and monospace — tap to copy, share button beside it.
class RoomCodeDisplay extends StatelessWidget {
  const RoomCodeDisplay({required this.code, super.key});

  final String code;

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: code));
    messenger.showSnackBar(
      const SnackBar(content: Text('Room code copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _copy(context),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Column(
                children: [
                  const Text('ROOM CODE', style: AppTypography.caption),
                  const SizedBox(height: AppSpacing.xs),
                  FittedBox(
                    // Keeps 6 spaced digits on one line down to 320px.
                    fit: BoxFit.scaleDown,
                    child: Text(code, style: AppTypography.code),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Share code',
            icon: const Icon(Icons.ios_share, color: AppColors.textSecondary),
            onPressed: () => SharePlus.instance.share(
              ShareParams(
                text: 'Join my QuestHub room with code $code',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
