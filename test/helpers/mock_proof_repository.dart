import 'dart:io';

import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/proof/data/image_compressor.dart';
import 'package:questhub/features/proof/domain/proof.dart' show Proof, ProofStatus;
import 'package:questhub/features/proof/domain/proof_repository.dart';

class MockProofRepository extends Mock implements ProofRepository {
  final _castVoteController = StreamController<String>.broadcast();

  Stream<String> get castVoteStream => _castVoteController.stream;

  void emitCastVote(String vote) => _castVoteController.add(vote);

  @override
  void dispose() {
    _castVoteController.close();
  }
}

class MockImageCompressor extends Mock implements ImageCompressor {}

Proof createTestProof({
  ProofStatus status = ProofStatus.pending,
  Map<String, String> votes = const {},
  String? submitterId,
}) {
  return Proof(
    id: 'test-proof-01',
    submitterId: submitterId ?? 'user-01',
    submitterName: 'TestPlayer',
    submitterAvatarUrl: null,
    questId: 'test-quest-01',
    questTitle: 'Do 10 jumping jacks',
    questPoints: 25,
    imageUrl: 'https://example.com/proof.jpg',
    thumbnailUrl: 'https://example.com/proof.jpg',
    votes: votes,
    status: status,
    submittedAt: DateTime.now().toUtc(),
    votingDeadline: DateTime.now().toUtc().add(const Duration(seconds: 30)),
  );
}
