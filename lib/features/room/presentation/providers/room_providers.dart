import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/firebase_room_repository.dart';
import '../../domain/room.dart';
import '../../domain/room_repository.dart';

final roomRepositoryProvider = Provider<RoomRepository>(
  (ref) => FirebaseRoomRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  ),
);

/// Live room state for the lobby (and later, the game session).
final roomProvider = StreamProvider.family<Room, String>(
  (ref, roomId) => ref.watch(roomRepositoryProvider).listenToRoom(roomId),
);
