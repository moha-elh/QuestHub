import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('system')
  system,
  @JsonValue('reaction')
  reaction;
}

Map<String, List<String>> _messageReactionsFromJson(Map<String, dynamic> json) =>
    json.map((k, v) => MapEntry(k, (v as List<dynamic>).cast<String>()));

@freezed
abstract class Message with _$Message {
  const Message._();

  const factory Message({
    @JsonKey(includeToJson: false) required String id,
    required String senderId,
    required String senderName,
    String? senderAvatarUrl,
    @Default(MessageType.text) MessageType type,
    required String content,
    @JsonKey(fromJson: _messageReactionsFromJson)
    @Default(<String, List<String>>{}) Map<String, List<String>> reactions,
    required DateTime createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  bool get isSystem => type == MessageType.system;
}
