import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/leaderboard_entry.dart';
import '../domain/leaderboard_repository.dart';

class FirebaseLeaderboardRepository implements LeaderboardRepository {
  FirebaseLeaderboardRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  static const _usersCollection = 'users';
  static const _leaderboardsCollection = 'leaderboards';

  @override
  Future<List<LeaderboardEntry>> fetchLeaderboard(
    String cityCode, {
    bool weekly = false,
  }) async {
    final today = _dateKey(DateTime.now());
    final docRef = _firestore
        .collection(_leaderboardsCollection)
        .doc(cityCode)
        .collection('daily')
        .doc(today);

    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      final entries = (data['entries'] as List<dynamic>?) ?? [];
      return entries.map((e) {
        final entry = LeaderboardEntry.fromJson(e as Map<String, dynamic>);
        return entry;
      }).toList();
    }

    // Fallback: query users collection directly.
    return _fetchFromUsers(cityCode, weekly: weekly);
  }

  Future<List<LeaderboardEntry>> _fetchFromUsers(
    String cityCode, {
    bool weekly = false,
  }) async {
    final query = _firestore
        .collection(_usersCollection)
        .where('cityCode', isEqualTo: cityCode)
        .orderBy(weekly ? 'weeklyPoints' : 'totalPoints', descending: true)
        .limit(100);

    final snapshot = await query.get();
    if (snapshot.docs.isEmpty) return [];

    final entries = <LeaderboardEntry>[];
    var rank = 1;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      entries.add(LeaderboardEntry(
        rank: rank,
        userId: doc.id,
        displayName: (data['username'] as String?) ?? 'Unknown',
        avatarUrl: data['avatarUrl'] as String?,
        totalPoints: (data['totalPoints'] as num?)?.toInt() ?? 0,
        weeklyPoints: (data['weeklyPoints'] as num?)?.toInt() ?? 0,
        gamesPlayed: (data['gamesPlayed'] as num?)?.toInt() ?? 0,
      ));
      rank++;
    }
    return entries;
  }

  @override
  Stream<int?> listenToUserRank(String cityCode, String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .snapshots()
        .asyncMap((doc) async {
      if (!doc.exists) return null;
      final data = doc.data()!;
      final userCityCode = data['cityCode'] as String?;
      if (userCityCode != cityCode) return null;

      final userPoints = (data['totalPoints'] as num?)?.toInt() ?? 0;
      if (userPoints == 0) return null;

      // Count users in the same city with more points.
      final higherQuery = await _firestore
          .collection(_usersCollection)
          .where('cityCode', isEqualTo: cityCode)
          .where('totalPoints', isGreaterThan: userPoints)
          .count()
          .get();
      return (higherQuery.count ?? 0) + 1;
    });
  }

  static String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
