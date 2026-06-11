// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Proof _$ProofFromJson(Map<String, dynamic> json) => _Proof(
  id: json['id'] as String,
  submitterId: json['submitterId'] as String,
  submitterName: json['submitterName'] as String,
  submitterAvatarUrl: json['submitterAvatarUrl'] as String?,
  questId: json['questId'] as String,
  questTitle: json['questTitle'] as String,
  questPoints: (json['questPoints'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  votes:
      (json['votes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  status:
      $enumDecodeNullable(_$ProofStatusEnumMap, json['status']) ??
      ProofStatus.pending,
  submittedAt: DateTime.parse(json['submittedAt'] as String),
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
);

Map<String, dynamic> _$ProofToJson(_Proof instance) => <String, dynamic>{
  'submitterId': instance.submitterId,
  'submitterName': instance.submitterName,
  'submitterAvatarUrl': instance.submitterAvatarUrl,
  'questId': instance.questId,
  'questTitle': instance.questTitle,
  'questPoints': instance.questPoints,
  'imageUrl': instance.imageUrl,
  'thumbnailUrl': instance.thumbnailUrl,
  'votes': instance.votes,
  'status': _$ProofStatusEnumMap[instance.status]!,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'resolvedAt': instance.resolvedAt?.toIso8601String(),
};

const _$ProofStatusEnumMap = {
  ProofStatus.pending: 'pending',
  ProofStatus.approved: 'approved',
  ProofStatus.rejected: 'rejected',
};
