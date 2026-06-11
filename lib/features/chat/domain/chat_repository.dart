import 'message.dart';

abstract interface class ChatRepository {
  Future<void> sendMessage({
    required String roomId,
    required String content,
  });

  Stream<List<Message>> listenToMessages(String roomId);

  Future<void> addReaction({
    required String roomId,
    required String messageId,
    required String emoji,
  });

  Future<void> removeReaction({
    required String roomId,
    required String messageId,
    required String emoji,
  });

  Future<void> updateTyping(String roomId);

  Stream<Map<String, DateTime>> listenToTyping(String roomId);
}
