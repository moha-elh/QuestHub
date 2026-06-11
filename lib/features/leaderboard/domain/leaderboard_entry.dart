import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry.freezed.dart';
part 'leaderboard_entry.g.dart';

@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required int rank,
    required String userId,
    required String displayName,
    String? avatarUrl,
    required int totalPoints,
    @Default(0) int weeklyPoints,
    @Default(0) int gamesPlayed,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}
