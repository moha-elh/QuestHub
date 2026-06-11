import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../proof/domain/proof.dart';
import '../../../proof/presentation/providers/proof_providers.dart';
import '../../../quest/domain/quest.dart';
import '../../../quest/presentation/providers/quest_providers.dart';
import '../../../room/domain/room.dart';
import '../../../room/presentation/providers/room_providers.dart';
import '../../domain/mvp_data.dart';
import '../../domain/player_score.dart';

final sortedPlayersProvider = Provider.family<List<PlayerScore>, String>(
  (ref, roomId) {
    final room = ref.watch(roomProvider(roomId)).asData?.value;
    if (room == null) return [];
    return _computeScores(room);
  },
);

final mvpStatsProvider = FutureProvider.family<MvpData?, String>(
  (ref, roomId) async {
    final room = ref.watch(roomProvider(roomId)).asData?.value;
    if (room == null) return null;
    final questsMap = await ref
        .watch(questRepositoryProvider)
        .listenToAllQuests(roomId)
        .first;
    final proofs = await ref
        .watch(proofRepositoryProvider)
        .listenToResolvedProofs(roomId)
        .first;
    return _computeMvp(proofs, questsMap, room);
  },
);

List<PlayerScore> _computeScores(Room room) {
  final sorted = room.players.entries.toList()
    ..sort((a, b) => b.value.score.compareTo(a.value.score));
  final scores = <PlayerScore>[];
  for (var i = 0; i < sorted.length; i++) {
    final entry = sorted[i];
    final player = entry.value;
    final rank = i + 1;
    scores.add(PlayerScore(
      playerId: entry.key,
      displayName: player.displayName,
      avatarUrl: player.avatarUrl,
      score: player.score,
      rank: rank,
      questsCompleted: player.questsCompleted,
    ));
  }
  return scores;
}

MvpData? _computeMvp(
  List<Proof> proofs,
  Map<String, QuestAssignment> questsMap,
  Room room,
) {
  final completedByPlayer = <String, int>{};
  final highestByPlayer = <String, int>{};
  final fakeVotesByPlayer = <String, int>{};
  final realVotesByPlayer = <String, int>{};
  for (final entry in questsMap.entries) {
    final userId = entry.key;
    final quest = entry.value;
    if (quest.status == QuestAssignmentStatus.completed) {
      completedByPlayer[userId] = (completedByPlayer[userId] ?? 0) + 1;
      highestByPlayer[userId] = [
        highestByPlayer[userId] ?? 0,
        quest.points,
      ].reduce((a, b) => a > b ? a : b);
    }
  }
  for (final proof in proofs) {
    for (final voteEntry in proof.votes.entries) {
      if (voteEntry.value == 'fake') {
        fakeVotesByPlayer[voteEntry.key] =
            (fakeVotesByPlayer[voteEntry.key] ?? 0) + 1;
      } else if (voteEntry.value == 'real') {
        realVotesByPlayer[voteEntry.key] =
            (realVotesByPlayer[voteEntry.key] ?? 0) + 1;
      }
    }
  }
  final mostQuestsPlayer = _bestBy(completedByPlayer);
  final highestScorePlayer = _bestBy(highestByPlayer);
  final mostSkepticalPlayer = _bestBy(fakeVotesByPlayer);
  final believerPlayer = _bestBy(realVotesByPlayer);
  if (mostQuestsPlayer == null && highestScorePlayer == null &&
      mostSkepticalPlayer == null && believerPlayer == null) {
    return null;
  }
  return MvpData(
    mostQuests: MvpCategory(
      title: 'Most quests completed',
      icon: '\u{1F3C6}',
      playerId: mostQuestsPlayer?.key ?? '',
      playerName: _playerName(mostQuestsPlayer?.key, room),
      value: '${mostQuestsPlayer?.value ?? 0} quests',
    ),
    highestScore: MvpCategory(
      title: 'Highest single quest score',
      icon: '\u{1F4A5}',
      playerId: highestScorePlayer?.key ?? '',
      playerName: _playerName(highestScorePlayer?.key, room),
      value: '${highestScorePlayer?.value ?? 0} pts',
    ),
    mostSkeptical: MvpCategory(
      title: 'Most skeptical voter',
      icon: '\u{1F50D}',
      playerId: mostSkepticalPlayer?.key ?? '',
      playerName: _playerName(mostSkepticalPlayer?.key, room),
      value: '${mostSkepticalPlayer?.value ?? 0} fake votes',
    ),
    theBeliever: MvpCategory(
      title: 'The Believer',
      icon: '\u{1F64F}',
      playerId: believerPlayer?.key ?? '',
      playerName: _playerName(believerPlayer?.key, room),
      value: '${believerPlayer?.value ?? 0} real votes',
    ),
  );
}

MapEntry<String, int>? _bestBy(Map<String, int> map) {
  if (map.isEmpty) return null;
  return map.entries.reduce((a, b) => a.value >= b.value ? a : b);
}

String _playerName(String? playerId, Room room) {
  if (playerId == null) return '\u{2014}';
  return room.players[playerId]?.displayName ?? '\u{2014}';
}
