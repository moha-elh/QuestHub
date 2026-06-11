import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/leaderboard/domain/leaderboard_entry.dart';
import 'package:questhub/features/leaderboard/presentation/widgets/leaderboard_row.dart';

import '../../helpers/pump_app.dart';

LeaderboardEntry _entry({int rank = 4}) {
  return LeaderboardEntry(
    rank: rank,
    userId: 'user-1',
    displayName: 'TestPlayer',
    totalPoints: 100,
    gamesPlayed: 5,
  );
}

void main() {
  group('LeaderboardRow', () {
    testWidgets('rank 1 shows gold trophy icon', (tester) async {
      await tester.pumpApp(LeaderboardRow(entry: _entry(rank: 1)));

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('rank 2 shows silver trophy icon', (tester) async {
      await tester.pumpApp(LeaderboardRow(entry: _entry(rank: 2)));

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('rank 3 shows bronze trophy icon', (tester) async {
      await tester.pumpApp(LeaderboardRow(entry: _entry(rank: 3)));

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('rank 4+ shows plain number badge', (tester) async {
      await tester.pumpApp(LeaderboardRow(entry: _entry(rank: 4)));

      expect(find.byIcon(Icons.emoji_events), findsNothing);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('current user row shows accent border', (tester) async {
      await tester.pumpApp(LeaderboardRow(
        entry: _entry(rank: 5),
        isCurrentUser: true,
      ));

      expect(find.text('TestPlayer'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });
  });
}
