import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/quest/domain/quest.dart';
import 'package:questhub/features/quest/domain/quest_repository.dart';

class MockQuestRepository extends Mock implements QuestRepository {}

QuestAssignment createTestQuestAssignment({
  QuestAssignmentStatus status = QuestAssignmentStatus.active,
  int durationSeconds = 180,
}) {
  final now = DateTime.now().toUtc();
  return QuestAssignment(
    questId: 'test-quest-01',
    title: 'Do 10 jumping jacks in a public space',
    description: 'Get someone to count for you.',
    difficulty: QuestDifficulty.medium,
    points: 25,
    durationSeconds: durationSeconds,
    category: QuestCategory.physical,
    assignedAt: now.subtract(const Duration(seconds: 10)),
    status: status,
  );
}
