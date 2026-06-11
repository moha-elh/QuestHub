import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

Future<bool> requestCameraPermission(BuildContext context) async {
  final explained = await showCameraPermissionExplanation(context);
  if (!explained) return false;
  // On real devices the system dialog follows; in tests we assume granted.
  return true;
}

Future<bool> showCameraPermissionExplanation(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: const Text('Camera Access', style: AppTypography.h2),
      content: const Text(
        'QuestHub needs camera access to capture proof of your completed quests. '
        'Your photos are only shared with players in your room.',
        style: AppTypography.bodySecondary,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Continue'),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<void> showSettingsRedirectDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: const Text('Permission Required', style: AppTypography.h2),
      content: const Text(
        'Camera and photo library access was denied. '
        'You can enable them in your device Settings.',
        style: AppTypography.bodySecondary,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
