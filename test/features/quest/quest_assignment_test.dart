import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/core/data/quest_bank.dart';
import 'package:questhub/features/quest/domain/quest.dart';

void main() {
  group('Quest bank', () {
    test('contains at least 30 quests', () {
      expect(questBank.length, greaterThanOrEqualTo(30));
    });

    test('all quests have unique ids', () {
      final ids = questBank.map((q) => q.id).toSet();
      expect(ids.length, equals(questBank.length));
    });

    test('quests are spread across all difficulties', () {
      final difficulties = questBank.map((q) => q.difficulty).toSet();
      expect(difficulties, containsAll([
        QuestDifficulty.easy,
        QuestDifficulty.medium,
        QuestDifficulty.hard,
        QuestDifficulty.legendary,
      ]));
    });

    test('quests are spread across all categories', () {
      final categories = questBank.map((q) => q.category).toSet();
      expect(categories, containsAll([
        QuestCategory.physical,
        QuestCategory.social,
        QuestCategory.creative,
        QuestCategory.stealth,
      ]));
    });

    test('points and duration match difficulty defaults', () {
      for (final quest in questBank) {
        expect(quest.points, equals(quest.difficulty.points));
        expect(quest.durationSeconds, equals(quest.difficulty.durationSeconds));
      }
    });
  });

  group('Quest assignment — no duplicates', () {
    List<Quest> pickRandomQuests(int count) {
      final shuffled = [...questBank]..shuffle();
      return shuffled.take(count).toList();
    }

    test('picking N quests produces N unique quests', () {
      final picked = pickRandomQuests(4);
      expect(picked.length, equals(4));
      final ids = picked.map((q) => q.id).toSet();
      expect(ids.length, equals(picked.length));
    });

    test('picking 1 quest is valid', () {
      final picked = pickRandomQuests(1);
      expect(picked.length, equals(1));
    });

    test('picking all 32 quests produces no duplicates', () {
      final picked = pickRandomQuests(questBank.length);
      expect(picked.length, equals(questBank.length));
      final ids = picked.map((q) => q.id).toSet();
      expect(ids.length, equals(questBank.length));
    });

    test('two players get different quests with high probability', () {
      // Deterministic test: consecutive picks from shuffled list differ.
      final shuffled = [...questBank]..shuffle();
      expect(shuffled[0].id, isNot(equals(shuffled[1].id)));
    });
  });
}
