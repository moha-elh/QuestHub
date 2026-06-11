import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/city_service.dart';
import '../../data/firebase_leaderboard_repository.dart';
import '../../domain/leaderboard_entry.dart';
import '../../domain/leaderboard_repository.dart';

final cityServiceProvider = Provider<CityService>((ref) => CityService());

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return FirebaseLeaderboardRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

final leaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, String>(
  (ref, cityCode) {
    return ref.watch(leaderboardRepositoryProvider).fetchLeaderboard(cityCode);
  },
);

final weeklyLeaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, String>(
  (ref, cityCode) {
    return ref
        .watch(leaderboardRepositoryProvider)
        .fetchLeaderboard(cityCode, weekly: true);
  },
);

final userRankProvider = StreamProvider.family<int?, String>(
  (ref, cityCode) {
    final uid = ref.watch(authRepositoryProvider).currentUserId;
    if (uid == null) return const Stream.empty();
    return ref
        .watch(leaderboardRepositoryProvider)
        .listenToUserRank(cityCode, uid);
  },
);

final cachedCityCodeProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('city_code');
});

final cachedCityNameProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('city_name');
});
