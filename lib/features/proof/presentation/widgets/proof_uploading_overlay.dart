import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../quest/domain/quest.dart';
import '../providers/proof_providers.dart';

class ProofUploadingOverlay extends ConsumerStatefulWidget {
  const ProofUploadingOverlay({
    required this.roomId,
    required this.quest,
    required this.imageFile,
    required this.onComplete,
    super.key,
  });

  final String roomId;
  final QuestAssignment quest;
  final File imageFile;
  final void Function(String proofId) onComplete;

  @override
  ConsumerState<ProofUploadingOverlay> createState() =>
      _ProofUploadingOverlayState();
}

class _ProofUploadingOverlayState extends ConsumerState<ProofUploadingOverlay> {
  String _statusMessage = 'Uploading proof\u2026';
  bool _hasError = false;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  Future<void> _startUpload() async {
    setState(() {
      _hasError = false;
      _statusMessage = 'Uploading proof\u2026';
    });

    try {
      final proofId = await ref.read(proofRepositoryProvider).submitProof(
        roomId: widget.roomId,
        questId: widget.quest.questId,
        questTitle: widget.quest.title,
        questPoints: widget.quest.points,
        imageFile: widget.imageFile,
      );

      if (!mounted) return;
      setState(() {
        _isComplete = true;
        _statusMessage = 'Proof submitted!';
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) widget.onComplete(proofId);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _statusMessage = 'Upload failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.xl),
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppSpacing.lg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_hasError)
                  const Icon(Icons.error, color: AppColors.danger, size: 48)
                else if (_isComplete)
                  const Icon(Icons.check_circle, color: AppColors.success, size: 48)
                else
                  const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(),
                  ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  _statusMessage,
                  style: AppTypography.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.quest.title,
                  style: AppTypography.bodySecondary,
                  textAlign: TextAlign.center,
                ),
                if (_hasError) ...[
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: _startUpload,
                    child: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
