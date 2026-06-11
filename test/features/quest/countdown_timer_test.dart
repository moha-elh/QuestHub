import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/quest/presentation/widgets/quest_countdown_timer.dart';

void main() {
  group('QuestCountdownTimer', () {
    testWidgets('displays correct MM:SS format', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuestCountdownTimer(
              totalSeconds: 180,
              remainingSeconds: 145,
            ),
          ),
        ),
      );

      // 145 seconds = 2 minutes 25 seconds
      expect(find.text('02:25'), findsOneWidget);
      expect(find.text('remaining'), findsOneWidget);
    });

    testWidgets('shows 00:00 when time runs out', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuestCountdownTimer(
              totalSeconds: 120,
              remainingSeconds: 0,
            ),
          ),
        ),
      );

      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('shows full time at start', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuestCountdownTimer(
              totalSeconds: 300,
              remainingSeconds: 300,
            ),
          ),
        ),
      );

      expect(find.text('05:00'), findsOneWidget);
    });

    testWidgets('displays 03:00 for 180 seconds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuestCountdownTimer(
              totalSeconds: 180,
              remainingSeconds: 180,
            ),
          ),
        ),
      );

      expect(find.text('03:00'), findsOneWidget);
    });
  });
}
