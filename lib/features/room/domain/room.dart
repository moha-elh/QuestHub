import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

enum RoomStatus {
  @JsonValue('waiting')
  waiting,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('finished')
  finished,
}

/// A game room, persisted at `rooms/{roomId}` in Firestore.
@freezed
abstract class Room with _$Room {
  const Room._();

  const factory Room({
    /// Firestore doc id — injected when reading, never written into the doc.
    @JsonKey(includeToJson: false) required String id,
    required String hostId,
    required String code,
    required DateTime createdAt,
    @Default(RoomStatus.waiting) RoomStatus status,
    @Default(false) bool isPublic,
    @Default(8) int maxPlayers,
    @Default(<String, RoomPlayer>{}) Map<String, RoomPlayer> players,
    DateTime? startedAt,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  bool get isFull => players.length >= maxPlayers;

  /// Players in join order — stable ordering for the lobby list and for
  /// host promotion.
  List<MapEntry<String, RoomPlayer>> get sortedPlayerEntries =>
      players.entries.toList()
        ..sort((a, b) => a.value.joinedAt.compareTo(b.value.joinedAt));

  int get readyCount => players.values.where((p) => p.isReady).length;

  /// Host can start once at least two players have readied up.
  bool get canStart => readyCount >= 2;
}

/// A player entry inside a room's `players` map.
@freezed
abstract class RoomPlayer with _$RoomPlayer {
  const factory RoomPlayer({
    required String displayName,
    required DateTime joinedAt,
    required DateTime lastSeenAt,
    String? avatarUrl,
    @Default(false) bool isReady,
    @Default(0) int score,
    @Default(false) bool skipUsed,
  }) = _RoomPlayer;

  factory RoomPlayer.fromJson(Map<String, dynamic> json) =>
      _$RoomPlayerFromJson(json);
}
