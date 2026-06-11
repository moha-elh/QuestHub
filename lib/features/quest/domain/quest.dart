import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

enum QuestDifficulty {
  @JsonValue('easy')
  easy,
  @JsonValue('medium')
  medium,
  @JsonValue('hard')
  hard,
  @JsonValue('legendary')
  legendary;

  int get points => switch (this) {
    QuestDifficulty.easy => 10,
    QuestDifficulty.medium => 25,
    QuestDifficulty.hard => 50,
    QuestDifficulty.legendary => 100,
  };

  int get durationSeconds => switch (this) {
    QuestDifficulty.easy => 120,
    QuestDifficulty.medium => 180,
    QuestDifficulty.hard => 300,
    QuestDifficulty.legendary => 480,
  };
}

enum QuestCategory {
  @JsonValue('physical')
  physical,
  @JsonValue('social')
  social,
  @JsonValue('creative')
  creative,
  @JsonValue('stealth')
  stealth;
}

enum QuestAssignmentStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('skipped')
  skipped,
  @JsonValue('expired')
  expired;
}

@freezed
abstract class Quest with _$Quest {
  const Quest._();

  const factory Quest({
    required String id,
    required String title,
    required String description,
    required QuestDifficulty difficulty,
    required QuestCategory category,
    @Default(<String>[]) List<String> tags,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

  int get points => difficulty.points;
  int get durationSeconds => difficulty.durationSeconds;
}

@freezed
abstract class QuestAssignment with _$QuestAssignment {
  const factory QuestAssignment({
    required String questId,
    required String title,
    required String description,
    required QuestDifficulty difficulty,
    required int points,
    required int durationSeconds,
    required QuestCategory category,
    required DateTime assignedAt,
    @Default(QuestAssignmentStatus.active) QuestAssignmentStatus status,
    DateTime? completedAt,
  }) = _QuestAssignment;

  factory QuestAssignment.fromJson(Map<String, dynamic> json) =>
      _$QuestAssignmentFromJson(json);
}
