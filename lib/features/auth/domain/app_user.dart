import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// A QuestHub player profile, persisted at `users/{uid}` in Firestore.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String username,
    required String email,
    required DateTime createdAt,
    String? avatarUrl,
    String? city,
    String? cityCode,
    @Default(0) int totalPoints,
    @Default(0) int weeklyPoints,
    @Default(0) int gamesPlayed,
    @Default(0) int questsCompleted,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
