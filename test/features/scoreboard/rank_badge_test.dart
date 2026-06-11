import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/scoreboard/presentation/widgets/rank_badge.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('RankBadge', () {
    testWidgets('rank 1 shows gold trophy icon', (tester) async {
      await tester.pumpApp(const RankBadge(rank: 1));
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('rank 2 shows silver trophy icon', (tester) async {
      await tester.pumpApp(const RankBadge(rank: 2));
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('rank 3 shows bronze trophy icon', (tester) async {
      await tester.pumpApp(const RankBadge(rank: 3));
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('rank 4+ shows plain number badge', (tester) async {
      await tester.pumpApp(const RankBadge(rank: 4));
      expect(find.text('4'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsNothing);
    });

    testWidgets('rank 10 shows plain number badge', (tester) async {
      await tester.pumpApp(const RankBadge(rank: 10));
      expect(find.text('10'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsNothing);
    });
  });
}
