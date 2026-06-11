import 'quest.dart';

abstract interface class QuestRepository {
  Stream<QuestAssignment?> listenToMyQuest(String roomId, String userId);

  Future<void> markQuestComplete(String roomId, String userId);

  Future<void> skipQuest(String roomId, String userId);
}
