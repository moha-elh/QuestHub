import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/proof/domain/proof.dart' show Proof, ProofStatus;

void main() {
  group('Proof model', () {
    test('fromJson round-trips correctly', () {
      final json = {
        'id': 'proof-01',
        'submitterId': 'user-01',
        'submitterName': 'Alice',
        'submitterAvatarUrl': null,
        'questId': 'quest-01',
        'questTitle': 'Do a flip',
        'questPoints': 25,
        'imageUrl': 'https://example.com/img.jpg',
        'thumbnailUrl': 'https://example.com/img.jpg',
        'votes': <String, String>{},
        'status': 'pending',
        'submittedAt': DateTime.now().toUtc().toIso8601String(),
      };

      final proof = Proof.fromJson(json);
      expect(proof.id, 'proof-01');
      expect(proof.submitterName, 'Alice');
      expect(proof.questPoints, 25);
      expect(proof.status, ProofStatus.pending);
    });

    test('toJson contains expected keys', () {
      final proof = Proof(
        id: 'p1',
        submitterId: 'u1',
        submitterName: 'Bob',
        submitterAvatarUrl: null,
        questId: 'q1',
        questTitle: 'Quest',
        questPoints: 10,
        imageUrl: 'https://example.com/img.jpg',
        thumbnailUrl: 'https://example.com/img.jpg',
        votes: {},
        status: ProofStatus.pending,
        submittedAt: DateTime.now().toUtc(),
      );

      final json = proof.toJson();
      expect(json.containsKey('id'), false);
      expect(json['status'], 'pending');
    });

    group('ProofStatus', () {
      test('pending maps to pending string', () {
        expect(ProofStatus.pending.name, 'pending');
      });

      test('approved maps to approved string', () {
        expect(ProofStatus.approved.name, 'approved');
      });

      test('rejected maps to rejected string', () {
        expect(ProofStatus.rejected.name, 'rejected');
      });
    });
  });
}
