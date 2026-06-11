class MvpCategory {
  const MvpCategory({
    required this.title,
    required this.icon,
    required this.playerId,
    required this.playerName,
    this.avatarUrl,
    required this.value,
  });

  final String title;
  final String icon;
  final String playerId;
  final String playerName;
  final String? avatarUrl;
  final String value;
}

class MvpData {
  const MvpData({
    required this.mostQuests,
    required this.highestScore,
    required this.mostSkeptical,
    required this.theBeliever,
  });

  final MvpCategory mostQuests;
  final MvpCategory highestScore;
  final MvpCategory mostSkeptical;
  final MvpCategory theBeliever;

  List<MvpCategory> get all => [mostQuests, highestScore, mostSkeptical, theBeliever];
}
