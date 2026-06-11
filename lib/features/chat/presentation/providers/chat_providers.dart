import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/firebase_chat_repository.dart';
import '../../domain/chat_repository.dart';
import '../../domain/message.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return FirebaseChatRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final messagesProvider = StreamProvider.family<List<Message>, String>(
  (ref, roomId) => ref.watch(chatRepositoryProvider).listenToMessages(roomId),
);

final typingUsersProvider = StreamProvider.family<Set<String>, String>(
  (ref, roomId) {
    final currentUserId = ref.watch(authRepositoryProvider).currentUserId;
    final repo = ref.watch(chatRepositoryProvider);
    return repo.listenToTyping(roomId).map((typingMap) {
      final now = DateTime.now().toUtc();
      return typingMap.entries
          .where((e) => e.key != currentUserId)
          .where((e) => now.difference(e.value).inSeconds < 3)
          .map((e) => e.key)
          .toSet();
    });
  },
);
