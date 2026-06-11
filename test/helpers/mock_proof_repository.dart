import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/proof/data/image_compressor.dart';
import 'package:questhub/features/proof/domain/proof.dart' show Proof, ProofStatus;
import 'package:questhub/features/proof/domain/proof_repository.dart';

class MockProofRepository extends Mock implements ProofRepository {}

class MockImageCompressor extends Mock implements ImageCompressor {}

Proof createTestProof({
  ProofStatus status = ProofStatus.pending,
}) {
  return Proof(
    id: 'test-proof-01',
    submitterId: 'user-01',
    submitterName: 'TestPlayer',
    submitterAvatarUrl: null,
    questId: 'test-quest-01',
    questTitle: 'Do 10 jumping jacks',
    questPoints: 25,
    imageUrl: 'https://example.com/proof.jpg',
    thumbnailUrl: 'https://example.com/proof.jpg',
    votes: {},
    status: status,
    submittedAt: DateTime.now().toUtc(),
  );
}
