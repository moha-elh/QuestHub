import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/leaderboard_entry.dart';
import '../providers/leaderboard_providers.dart';
import '../widgets/city_picker_sheet.dart';
import '../widgets/leaderboard_row.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  var _weekly = false;

  @override
  Widget build(BuildContext context) {
    final cityCodeAsync = ref.watch(cachedCityCodeProvider);
    final cityNameAsync = ref.watch(cachedCityNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            tooltip: 'Change city',
            icon: const Icon(Icons.edit_location),
            onPressed: () => _pickCity(),
          ),
        ],
      ),
      body: cityCodeAsync.when(
        data: (cityCode) {
          if (cityCode == null) {
            return _buildNoCity();
          }
          final cityName = cityNameAsync.asData?.value;
          return _buildLeaderboard(cityCode, cityName);
        },
        error: (_, _) => _buildNoCity(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildNoCity() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 48, color: AppColors.textFaint),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'No city selected',
              style: AppTypography.h2,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Set your city to see the local leaderboard.',
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () => _pickCity(),
              icon: const Icon(Icons.location_city),
              label: const Text('Select city'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard(String cityCode, String? cityName) {
    final leaderboard = ref.watch(
      _weekly
          ? weeklyLeaderboardProvider(cityCode)
          : leaderboardProvider(cityCode),
    );
    final userRank = ref.watch(userRankProvider(cityCode));
    final uid = ref.watch(authRepositoryProvider).currentUserId;
    final rank = userRank.asData?.value;

    return Column(
      children: [
        _buildHeader(cityName ?? cityCode),
        _buildTabs(),
        Expanded(
          child: leaderboard.when(
            data: (entries) {
              if (entries.isEmpty) {
                return _buildEmptyState(cityName ?? cityCode);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(
                    _weekly
                        ? weeklyLeaderboardProvider(cityCode)
                        : leaderboardProvider(cityCode),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: entries.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildUserRankPinned(uid, rank, entries);
                    }
                    final entry = entries[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: LeaderboardRow(
                        entry: entry,
                        isCurrentUser: entry.userId == uid,
                      ),
                    );
                  },
                ),
              );
            },
            error: (_, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Could not load leaderboard',
                    style: AppTypography.bodySecondary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(
                        _weekly
                            ? weeklyLeaderboardProvider(cityCode)
                            : leaderboardProvider(cityCode),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String cityName) {
    final today = DateTime.now();
    final dateStr = '${today.month}/${today.day}/${today.year}';

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sm,
        AppSpacing.screenPadding,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Text(
            cityName,
            style: AppTypography.h1.copyWith(fontSize: 22),
          ),
          const Spacer(),
          Icon(Icons.update, size: 14, color: AppColors.textFaint),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Updated $dateStr',
            style: AppTypography.caption.copyWith(color: AppColors.textFaint),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _tab('All time', !_weekly, () => setState(() => _weekly = false)),
        _tab('This week', _weekly, () => setState(() => _weekly = true)),
      ],
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: (active ? AppTypography.button : AppTypography.bodySecondary)
                .copyWith(
              color: active ? AppColors.textPrimary : AppColors.textFaint,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String cityName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, size: 48, color: AppColors.textFaint),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Be the first in $cityName!',
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Play a game to appear here.',
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRankPinned(
    String? uid,
    int? rank,
    List<LeaderboardEntry> entries,
  ) {
    if (uid == null || rank == null) return const SizedBox.shrink();

    final isInList = entries.any((e) => e.userId == uid);
    if (isInList) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
        left: AppSpacing.sm,
        right: AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          border: const Border(
            left: BorderSide(color: AppColors.accent, width: 3),
          ),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Your rank',
              style: AppTypography.body,
            ),
            const Spacer(),
            Text(
              '$rank',
              style: AppTypography.h3.copyWith(
                color: AppColors.accent,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCity() async {
    final currentCity = await ref.read(cachedCityNameProvider.future);
    if (!mounted) return;
    final result = await CityPickerSheet.show(
      context,
      currentCity: currentCity,
    );
    if (result == null) return;

    final code = await ref.read(cityServiceProvider).setCity(result);
    final uid = ref.read(authRepositoryProvider).currentUserId;
    if (uid != null) {
      await ref
          .read(authRepositoryProvider)
          .updateUserCity(uid: uid, city: result, cityCode: code);
    }
    if (!mounted) return;
    ref.invalidate(cachedCityCodeProvider);
    ref.invalidate(cachedCityNameProvider);
    ref.invalidate(leaderboardProvider);
    ref.invalidate(weeklyLeaderboardProvider);
  }
}
