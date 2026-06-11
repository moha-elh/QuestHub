import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/proof/domain/vote_logic.dart';
import 'package:questhub/features/proof/presentation/widgets/vote_result_overlay.dart';

void main() {
  group('VoteResultOverlay', () {
    testWidgets('approved verdict: shows PROOF APPROVED and +points',
        (tester) async {
      final result = VoteResult(
        approved: true,
        pointDelta: 25,
        fakeVoterIds: [],
        fakeCount: 0,
        totalVotes: 3,
        eligibleCount: 3,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VoteResultOverlay(
            result: result,
            fakeVoterNames: const [],
            onDismiss: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PROOF APPROVED'), findsOneWidget);
      expect(find.textContaining('+'), findsOneWidget);
    });

    testWidgets('rejected verdict: shows PROOF REJECTED and -points',
        (tester) async {
      final result = VoteResult(
        approved: false,
        pointDelta: -12,
        fakeVoterIds: ['user2'],
        fakeCount: 2,
        totalVotes: 3,
        eligibleCount: 3,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VoteResultOverlay(
            result: result,
            fakeVoterNames: const ['Player2'],
            onDismiss: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PROOF REJECTED'), findsOneWidget);
      expect(find.textContaining('-'), findsOneWidget);
    });

    testWidgets('rejected with fake voters: shows voter names',
        (tester) async {
      final result = VoteResult(
        approved: false,
        pointDelta: -12,
        fakeVoterIds: ['user2', 'user3'],
        fakeCount: 2,
        totalVotes: 3,
        eligibleCount: 3,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VoteResultOverlay(
            result: result,
            fakeVoterNames: const ['Player2', 'Player3'],
            onDismiss: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PROOF REJECTED'), findsOneWidget);
      expect(find.text('Player2'), findsOneWidget);
      expect(find.text('Player3'), findsOneWidget);
    });

    testWidgets('dismisses after 3 seconds', (tester) async {
      var dismissed = false;
      final result = VoteResult(
        approved: true,
        pointDelta: 25,
        fakeVoterIds: [],
        fakeCount: 0,
        totalVotes: 3,
        eligibleCount: 3,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VoteResultOverlay(
            result: result,
            fakeVoterNames: const [],
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(dismissed, false);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(dismissed, true);
    });
  });
}
