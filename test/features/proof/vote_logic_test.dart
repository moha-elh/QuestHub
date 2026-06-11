import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/proof/domain/proof.dart';
import 'package:questhub/features/proof/domain/vote_logic.dart';

void main() {
  group('evaluateVoteResult', () {
    Proof _baseProof({
      int points = 25,
      Map<String, String> votes = const {},
    }) {
      return Proof(
        id: 'p1',
        submitterId: 'submitter',
        submitterName: 'Player1',
        questId: 'q1',
        questTitle: 'Test quest',
        questPoints: points,
        imageUrl: 'https://example.com/img.jpg',
        thumbnailUrl: 'https://example.com/img.jpg',
        votes: votes,
        status: ProofStatus.pending,
        submittedAt: DateTime.now().toUtc(),
        votingDeadline: DateTime.now().toUtc().add(const Duration(seconds: 30)),
      );
    }

    test('0 fake votes with 3 eligible voters -> approved, full points', () {
      final proof = _baseProof(votes: {
        'voter1': 'real',
        'voter2': 'real',
        'voter3': 'real',
      });
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 3);

      expect(result.approved, true);
      expect(result.pointDelta, 25);
      expect(result.fakeCount, 0);
    });

    test('1 fake vote with 3 eligible voters -> approved, full points', () {
      final proof = _baseProof(votes: {
        'voter1': 'fake',
        'voter2': 'real',
        'voter3': 'real',
      });
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 3);

      expect(result.approved, true);
      expect(result.pointDelta, 25);
      expect(result.fakeCount, 1);
    });

    test('2 fake votes -> rejected, 50% penalty', () {
      final proof = _baseProof(votes: {
        'voter1': 'fake',
        'voter2': 'fake',
        'voter3': 'real',
      });
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 3);

      expect(result.approved, false);
      expect(result.isRejected, true);
      expect(result.pointDelta, -12); // floor(25 * 0.5) = 12
      expect(result.fakeCount, 2);
    });

    test('3 fake votes -> rejected, 50% penalty', () {
      final proof = _baseProof(votes: {
        'voter1': 'fake',
        'voter2': 'fake',
        'voter3': 'fake',
      });
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 3);

      expect(result.approved, false);
      expect(result.pointDelta, -12);
      expect(result.fakeCount, 3);
    });

    test('0 votes with 0 eligible voters -> approved, full points', () {
      final proof = _baseProof(votes: {});
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 0);

      expect(result.approved, true);
      expect(result.pointDelta, 25);
      expect(result.fakeCount, 0);
    });

    test('only abstain votes -> approved, full points', () {
      // No votes at all = nobody voted fake
      final proof = _baseProof(votes: {});
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 3);

      expect(result.approved, true);
      expect(result.pointDelta, 25);
      expect(result.fakeCount, 0);
    });

    test('odd points: floor(25 * 0.5) = 12', () {
      final proof = _baseProof(points: 25, votes: {
        'voter1': 'fake',
        'voter2': 'fake',
      });
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 2);

      expect(result.pointDelta, -12);
    });

    test('even points: floor(50 * 0.5) = 25', () {
      final proof = _baseProof(points: 50, votes: {
        'voter1': 'fake',
        'voter2': 'fake',
      });
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 2);

      expect(result.pointDelta, -25);
    });

    test('fakeVoterIds contains correct voter IDs', () {
      final proof = _baseProof(votes: {
        'voter1': 'fake',
        'voter2': 'real',
        'voter3': 'fake',
      });
      final result = evaluateVoteResult(proof: proof, eligibleVoterCount: 3);

      expect(result.fakeVoterIds, ['voter1', 'voter3']);
    });
  });
}
