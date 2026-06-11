import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/qh_button.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../leaderboard/presentation/providers/leaderboard_providers.dart';
import '../../../leaderboard/presentation/widgets/city_picker_sheet.dart';
import '../providers/room_controller.dart';
import '../widgets/create_room_sheet.dart';
import '../widgets/room_error_banner.dart';

/// Home screen: the entry point into a game — create, join, or quick match.
class CreateOrJoinScreen extends ConsumerStatefulWidget {
  const CreateOrJoinScreen({super.key});

  @override
  ConsumerState<CreateOrJoinScreen> createState() => _CreateOrJoinScreenState();
}

class _CreateOrJoinScreenState extends ConsumerState<CreateOrJoinScreen> {
  var _citySetupShown = false;

  Future<void> _quickMatch() async {
    final roomId =
        await ref.read(roomControllerProvider.notifier).joinPublic();
    if (roomId != null && mounted) context.go('/room/$roomId');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeShowCitySetup();
  }

  Future<void> _maybeShowCitySetup() async {
    if (_citySetupShown) return;
    final uid = ref.read(authRepositoryProvider).currentUserId;
    if (uid == null) return;

    final cachedCode = await ref.read(cityServiceProvider).getCachedCityCode();
    if (cachedCode != null) {
      _citySetupShown = true;
      return;
    }

    _citySetupShown = true;
    if (!mounted) return;

    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Where are you?'),
        content: const Text(
          'Set your city to see the local leaderboard and compete with players near you.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('pick'),
            child: const Text('Pick manually'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop('detect'),
            child: const Text('Use location'),
          ),
        ],
      ),
    );
    if (!mounted) return;

    if (action == 'detect') {
      await _detectCity();
    } else if (action == 'pick') {
      await _pickCity();
    }
  }

  Future<void> _detectCity() async {
    final cityService = ref.read(cityServiceProvider);
    final cityName = await cityService.detectCity();
    if (cityName == null || !mounted) {
      await _pickCity();
      return;
    }

    final cityCode = await cityService.setCity(cityName);
    final uid = ref.read(authRepositoryProvider).currentUserId;
    if (uid != null) {
      await ref
          .read(authRepositoryProvider)
          .updateUserCity(uid: uid, city: cityName, cityCode: cityCode);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City set to $cityName')),
      );
    }
  }

  Future<void> _pickCity() async {
    final result = await CityPickerSheet.show(context);
    if (result == null || !mounted) return;

    final cityService = ref.read(cityServiceProvider);
    final cityCode = await cityService.setCity(result);
    final uid = ref.read(authRepositoryProvider).currentUserId;
    if (uid != null) {
      await ref
          .read(authRepositoryProvider)
          .updateUserCity(uid: uid, city: result, cityCode: cityCode);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City set to $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(roomControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuestHub'),
        actions: [
          IconButton(
            tooltip: 'Leaderboard',
            icon: const Icon(Icons.leaderboard),
            onPressed: () => context.go(AppRoutes.leaderboard),
          ),
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
                    onPressed: () => _quickMatch(),
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
