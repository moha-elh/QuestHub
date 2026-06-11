import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/qh_button.dart';
import '../../../quest/domain/quest.dart';
import '../widgets/permission_dialogs.dart';
import '../widgets/proof_uploading_overlay.dart';

class ProofCaptureScreen extends ConsumerStatefulWidget {
  const ProofCaptureScreen({
    required this.roomId,
    required this.quest,
    super.key,
  });

  final String roomId;
  final QuestAssignment quest;

  @override
  ConsumerState<ProofCaptureScreen> createState() => _ProofCaptureScreenState();
}

class _ProofCaptureScreenState extends ConsumerState<ProofCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  bool _cameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    final granted = await requestCameraPermission(context);
    if (!granted) {
      if (mounted) await showSettingsRedirectDialog(context);
      return;
    }

    try {
      _cameras = await availableCameras();
    } catch (_) {
      if (mounted) _showPicker();
      return;
    }

    if (_cameras == null || _cameras!.isEmpty) {
      if (mounted) _showPicker();
      return;
    }

    await _startCamera(0);
  }

  Future<void> _startCamera(int index) async {
    if (index >= (_cameras?.length ?? 0)) return;
    final camera = _cameras![index];
    final controller = CameraController(camera, ResolutionPreset.medium);
    unawaited(_cameraController?.dispose());
    _cameraController = controller;

    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _cameraInitialized = true;
      });
    } catch (_) {}
  }

  Future<void> _capture() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;
    try {
      final image = await controller.takePicture();
      if (!mounted) return;
      setState(() => _capturedImage = image);
    } catch (_) {}
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null && mounted) {
      setState(() => _capturedImage = image);
    }
  }

  void _showPicker() {
    unawaited(showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.of(ctx).pop();
                unawaited(_initCamera());
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(ctx).pop();
                unawaited(_pickFromGallery());
              },
            ),
          ],
        ),
      ),
    ));
  }

  void _retake() {
    setState(() => _capturedImage = null);
  }

  Future<void> _usePhoto() async {
    final image = _capturedImage;
    if (image == null || !mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProofUploadingOverlay(
        roomId: widget.roomId,
        quest: widget.quest,
        imageFile: File(image.path),
        onComplete: () {
          if (mounted) context.go('/room/${widget.roomId}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (_capturedImage != null)
              _buildPreview()
            else if (_cameraInitialized)
              _buildCameraPreview()
            else
              _buildFallback(),
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            if (_capturedImage == null && _cameraInitialized) ...[
              Positioned(
                bottom: AppSpacing.xl,
                left: 0,
                right: 0,
                child: _buildCameraControls(),
              ),
              Positioned(
                top: AppSpacing.lg + 40,
                left: 0,
                right: 0,
                child: _buildInstruction(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction() {
    return const Center(
      child: Text(
        'Take a photo proving you did the quest',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_cameraController!);
  }

  Widget _buildFallback() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt, color: Colors.white54, size: 64),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Camera unavailable',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: AppSpacing.md),
          QhButton(
            label: 'Choose from Gallery',
            onPressed: () => unawaited(_pickFromGallery()),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_library, color: Colors.white),
              onPressed: () => unawaited(_pickFromGallery()),
              tooltip: 'Gallery',
            ),
            GestureDetector(
              onTap: () => unawaited(_capture()),
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.black87),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.flip_camera_android, color: Colors.white),
              onPressed: () {
                final idx = _cameras != null && _cameras!.length > 1 ? 1 : 0;
                unawaited(_startCamera(idx));
              },
              tooltip: 'Flip camera',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            File(_capturedImage!.path),
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          bottom: AppSpacing.xl,
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          child: Row(
            children: [
              Expanded(
                child: QhButton(
                  label: 'Retake',
                  variant: QhButtonVariant.secondary,
                  onPressed: _retake,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: QhButton(
                  label: 'Use this photo',
                  onPressed: _usePhoto,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
