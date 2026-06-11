import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../room/presentation/providers/room_providers.dart';
import '../../data/firebase_quest_repository.dart';
import '../../domain/quest.dart';
import '../../domain/quest_repository.dart';

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  return FirebaseQuestRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final myQuestProvider = StreamProvider.family<QuestAssignment?, String>(
  (ref, roomId) {
    final userId = ref.watch(authRepositoryProvider).currentUserId;
    if (userId == null) return const Stream.empty();
    return ref.watch(questRepositoryProvider).listenToMyQuest(roomId, userId);
  },
);

final hasSkippedInRoomProvider = Provider.family<bool, String>((ref, roomId) {
  final room = ref.watch(roomProvider(roomId)).asData?.value;
  if (room == null) return false;
  final userId = ref.watch(authRepositoryProvider).currentUserId;
  if (userId == null) return false;
  return room.players[userId]?.skipUsed ?? false;
});
