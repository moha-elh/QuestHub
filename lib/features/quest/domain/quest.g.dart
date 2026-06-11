// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quest _$QuestFromJson(Map<String, dynamic> json) => _Quest(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  difficulty: $enumDecode(_$QuestDifficultyEnumMap, json['difficulty']),
  category: $enumDecode(_$QuestCategoryEnumMap, json['category']),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$QuestToJson(_Quest instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'difficulty': _$QuestDifficultyEnumMap[instance.difficulty]!,
  'category': _$QuestCategoryEnumMap[instance.category]!,
  'tags': instance.tags,
};

const _$QuestDifficultyEnumMap = {
  QuestDifficulty.easy: 'easy',
  QuestDifficulty.medium: 'medium',
  QuestDifficulty.hard: 'hard',
  QuestDifficulty.legendary: 'legendary',
};

const _$QuestCategoryEnumMap = {
  QuestCategory.physical: 'physical',
  QuestCategory.social: 'social',
  QuestCategory.creative: 'creative',
  QuestCategory.stealth: 'stealth',
};

_QuestAssignment _$QuestAssignmentFromJson(Map<String, dynamic> json) =>
    _QuestAssignment(
      questId: json['questId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: $enumDecode(_$QuestDifficultyEnumMap, json['difficulty']),
      points: (json['points'] as num).toInt(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      category: $enumDecode(_$QuestCategoryEnumMap, json['category']),
      assignedAt: DateTime.parse(json['assignedAt'] as String),
      status:
          $enumDecodeNullable(_$QuestAssignmentStatusEnumMap, json['status']) ??
          QuestAssignmentStatus.active,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$QuestAssignmentToJson(_QuestAssignment instance) =>
    <String, dynamic>{
      'questId': instance.questId,
      'title': instance.title,
      'description': instance.description,
      'difficulty': _$QuestDifficultyEnumMap[instance.difficulty]!,
      'points': instance.points,
      'durationSeconds': instance.durationSeconds,
      'category': _$QuestCategoryEnumMap[instance.category]!,
      'assignedAt': instance.assignedAt.toIso8601String(),
      'status': _$QuestAssignmentStatusEnumMap[instance.status]!,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$QuestAssignmentStatusEnumMap = {
  QuestAssignmentStatus.active: 'active',
  QuestAssignmentStatus.completed: 'completed',
  QuestAssignmentStatus.skipped: 'skipped',
  QuestAssignmentStatus.expired: 'expired',
};
