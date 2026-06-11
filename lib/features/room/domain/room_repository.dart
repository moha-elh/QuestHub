import 'room.dart';

/// Room/lobby boundary. Implementations live in `data/`.
abstract interface class RoomRepository {
  /// Creates a room with a fresh unique 6-digit code; the caller becomes host
  /// and first player. Returns the new room id.
  Future<String> createRoom({required bool isPublic, required int maxPlayers});

  /// Joins a waiting room by its 6-digit code. Returns the room id.
  ///
  /// Throws [RoomNotFoundException] or [RoomFullException].
  Future<String> joinByCode(String code);

  /// Quick match: joins any open public room, or creates a new public room
  /// (becoming host) when none is available. Returns the room id.
  Future<String> joinPublic();

  /// Realtime room updates. Errors with [RoomNotFoundException] if the room
  /// is deleted while listening.
  Stream<Room> listenToRoom(String roomId);

  /// Removes the current player. Last player out deletes the room; if the
  /// host leaves, the longest-present remaining player is promoted (the
  /// Cloud Function covers crash/disconnect cases).
  Future<void> leaveRoom(String roomId);

  Future<void> setReady(String roomId, {required bool isReady});

  /// Host only; requires [Room.canStart].
  Future<void> startGame(String roomId);

  /// Bumps the caller's `lastSeenAt` so the stale-player cleanup function
  /// knows they're still connected.
  Future<void> heartbeat(String roomId);

  /// Host only; sets room status to `finished`.
  Future<void> endGame(String roomId);

  /// Host only; resets room to `waiting`, clears per-player scores/stats.
  Future<void> resetGame(String roomId);
}

/// User-facing room failure. [message] is safe to render directly.
sealed class RoomException implements Exception {
  const RoomException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RoomNotFoundException extends RoomException {
  const RoomNotFoundException()
      : super('No room found with that code. Double-check and try again.');
}

class RoomFullException extends RoomException {
  const RoomFullException() : super('That room is already full.');
}

class RoomAlreadyStartedException extends RoomException {
  const RoomAlreadyStartedException()
      : super('That game has already started.');
}

class RoomUnknownException extends RoomException {
  const RoomUnknownException()
      : super('Something went wrong with the room. Please try again.');
}
