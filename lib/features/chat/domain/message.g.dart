// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String,
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String,
  senderAvatarUrl: json['senderAvatarUrl'] as String?,
  type:
      $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
      MessageType.text,
  content: json['content'] as String,
  reactions: json['reactions'] == null
      ? const <String, List<String>>{}
      : _messageReactionsFromJson(json['reactions'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'senderId': instance.senderId,
  'senderName': instance.senderName,
  'senderAvatarUrl': instance.senderAvatarUrl,
  'type': _$MessageTypeEnumMap[instance.type]!,
  'content': instance.content,
  'reactions': instance.reactions,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.system: 'system',
  MessageType.reaction: 'reaction',
};
