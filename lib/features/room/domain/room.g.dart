// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String,
  hostId: json['hostId'] as String,
  code: json['code'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  status:
      $enumDecodeNullable(_$RoomStatusEnumMap, json['status']) ??
      RoomStatus.waiting,
  isPublic: json['isPublic'] as bool? ?? false,
  maxPlayers: (json['maxPlayers'] as num?)?.toInt() ?? 8,
  players:
      (json['players'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, RoomPlayer.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, RoomPlayer>{},
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'hostId': instance.hostId,
  'code': instance.code,
  'createdAt': instance.createdAt.toIso8601String(),
  'status': _$RoomStatusEnumMap[instance.status]!,
  'isPublic': instance.isPublic,
  'maxPlayers': instance.maxPlayers,
  'players': instance.players,
  'startedAt': instance.startedAt?.toIso8601String(),
};

const _$RoomStatusEnumMap = {
  RoomStatus.waiting: 'waiting',
  RoomStatus.inProgress: 'in_progress',
  RoomStatus.finished: 'finished',
};

_RoomPlayer _$RoomPlayerFromJson(Map<String, dynamic> json) => _RoomPlayer(
  displayName: json['displayName'] as String,
  joinedAt: DateTime.parse(json['joinedAt'] as String),
  lastSeenAt: DateTime.parse(json['lastSeenAt'] as String),
  avatarUrl: json['avatarUrl'] as String?,
  isReady: json['isReady'] as bool? ?? false,
  score: (json['score'] as num?)?.toInt() ?? 0,
  skipUsed: json['skipUsed'] as bool? ?? false,
  questsCompleted: (json['questsCompleted'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RoomPlayerToJson(_RoomPlayer instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'lastSeenAt': instance.lastSeenAt.toIso8601String(),
      'avatarUrl': instance.avatarUrl,
      'isReady': instance.isReady,
      'score': instance.score,
      'skipUsed': instance.skipUsed,
      'questsCompleted': instance.questsCompleted,
    };
