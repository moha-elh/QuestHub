class PlayerScore {
  const PlayerScore({
    required this.playerId,
    required this.displayName,
    this.avatarUrl,
    required this.score,
    required this.rank,
    this.previousRank,
    required this.questsCompleted,
  });

  final String playerId;
  final String displayName;
  final String? avatarUrl;
  final int score;
  final int rank;
  final int? previousRank;
  final int questsCompleted;

  int get rankDelta => previousRank != null ? previousRank! - rank : 0;
  bool get rankImproved => rankDelta > 0;
  bool get rankDeclined => rankDelta < 0;
}
