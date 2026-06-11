import 'leaderboard_entry.dart';

abstract interface class LeaderboardRepository {
  Future<List<LeaderboardEntry>> fetchLeaderboard(
    String cityCode, {
    bool weekly = false,
  });

  Stream<int?> listenToUserRank(String cityCode, String userId);
}
