// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    _LeaderboardEntry(
      rank: (json['rank'] as num).toInt(),
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalPoints: (json['totalPoints'] as num).toInt(),
      weeklyPoints: (json['weeklyPoints'] as num?)?.toInt() ?? 0,
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LeaderboardEntryToJson(_LeaderboardEntry instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'totalPoints': instance.totalPoints,
      'weeklyPoints': instance.weeklyPoints,
      'gamesPlayed': instance.gamesPlayed,
    };
