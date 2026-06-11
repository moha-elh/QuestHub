import 'package:freezed_annotation/freezed_annotation.dart';

part 'proof.freezed.dart';
part 'proof.g.dart';

enum ProofStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected;
}

  @freezed
  abstract class Proof with _$Proof {
    const Proof._();

    const factory Proof({
      @JsonKey(includeToJson: false) required String id,
      required String submitterId,
      required String submitterName,
      String? submitterAvatarUrl,
      required String questId,
      required String questTitle,
      required int questPoints,
      required String imageUrl,
      required String thumbnailUrl,
      @Default(<String, String>{}) Map<String, String> votes,
      @Default(ProofStatus.pending) ProofStatus status,
      required DateTime submittedAt,
      DateTime? votingDeadline,
      DateTime? resolvedAt,
    }) = _Proof;

    factory Proof.fromJson(Map<String, dynamic> json) => _$ProofFromJson(json);

    bool get isResolved => status != ProofStatus.pending;
  }
