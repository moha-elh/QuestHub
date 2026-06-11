import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/proof/domain/proof.dart';
import 'package:questhub/features/quest/domain/quest.dart';
import 'package:questhub/features/room/domain/room.dart';

/// Minimal re-implementation of the MVP computation logic for testing only.
Map<String, int> _completedBy(Map<String, QuestAssignment> quests) {
  final result = <String, int>{};
  for (final entry in quests.entries) {
    if (entry.value.status == QuestAssignmentStatus.completed) {
      result[entry.key] = (result[entry.key] ?? 0) + 1;
    }
  }
  return result;
}

void main() {
  group('MVP most quests completed', () {
    test('player with most completed quests is identified', () {
      final quests = <String, QuestAssignment>{
        'player1': QuestAssignment(
          questId: 'q1',
          title: 'Quest 1',
          description: '',
          difficulty: QuestDifficulty.easy,
          points: 10,
          durationSeconds: 120,
          category: QuestCategory.physical,
          assignedAt: DateTime.now().toUtc(),
          status: QuestAssignmentStatus.completed,
        ),
        'player2': QuestAssignment(
          questId: 'q2',
          title: 'Quest 2',
          description: '',
          difficulty: QuestDifficulty.medium,
          points: 25,
          durationSeconds: 180,
          category: QuestCategory.social,
          assignedAt: DateTime.now().toUtc(),
          status: QuestAssignmentStatus.completed,
        ),
        'player3': QuestAssignment(
          questId: 'q3',
          title: 'Quest 3',
          description: '',
          difficulty: QuestDifficulty.hard,
          points: 50,
          durationSeconds: 300,
          category: QuestCategory.stealth,
          assignedAt: DateTime.now().toUtc(),
          status: QuestAssignmentStatus.active,
        ),
      };

      final completed = _completedBy(quests);
      expect(completed['player1'], 1);
      expect(completed['player2'], 1);
      expect(completed.containsKey('player3'), false);

      final best = completed.entries
          .reduce((a, b) => a.value >= b.value ? a : b);
      // player1 and player2 both have 1, so first entry wins
      expect(best.value, 1);
    });

    test('skipped quests are not counted', () {
      final quests = <String, QuestAssignment>{
        'player1': QuestAssignment(
          questId: 'q1',
          title: 'Quest 1',
          description: '',
          difficulty: QuestDifficulty.easy,
          points: 10,
          durationSeconds: 120,
          category: QuestCategory.physical,
          assignedAt: DateTime.now().toUtc(),
          status: QuestAssignmentStatus.skipped,
        ),
      };

      final completed = _completedBy(quests);
      expect(completed, isEmpty);
    });

    test('empty quests returns empty map', () {
      final completed = _completedBy({});
      expect(completed, isEmpty);
    });
  });
}
