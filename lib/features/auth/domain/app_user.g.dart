// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  avatarUrl: json['avatarUrl'] as String?,
  city: json['city'] as String?,
  totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'username': instance.username,
  'email': instance.email,
  'createdAt': instance.createdAt.toIso8601String(),
  'avatarUrl': instance.avatarUrl,
  'city': instance.city,
  'totalPoints': instance.totalPoints,
};
