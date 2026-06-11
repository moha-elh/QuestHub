import 'proof.dart';

VoteResult evaluateVoteResult({
  required Proof proof,
  required int eligibleVoterCount,
}) {
  final fakeCount =
      proof.votes.values.where((v) => v == 'fake').length;

  final rejected = fakeCount >= 2;
  final pointDelta = rejected
      ? -(proof.questPoints / 2).floor()
      : proof.questPoints;

  final fakeVoterIds = proof.votes.entries
      .where((e) => e.value == 'fake')
      .map((e) => e.key)
      .toList();

  return VoteResult(
    approved: !rejected,
    pointDelta: pointDelta,
    fakeVoterIds: fakeVoterIds,
    fakeCount: fakeCount,
    totalVotes: proof.votes.length,
    eligibleCount: eligibleVoterCount,
  );
}

class VoteResult {
  const VoteResult({
    required this.approved,
    required this.pointDelta,
    required this.fakeVoterIds,
    required this.fakeCount,
    required this.totalVotes,
    required this.eligibleCount,
  });

  final bool approved;
  final int pointDelta;
  final List<String> fakeVoterIds;
  final int fakeCount;
  final int totalVotes;
  final int eligibleCount;

  bool get isRejected => !approved;
}
