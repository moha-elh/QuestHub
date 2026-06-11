import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:questhub/features/auth/domain/auth_repository.dart';
import 'package:questhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:questhub/features/leaderboard/domain/leaderboard_entry.dart';
import 'package:questhub/features/leaderboard/domain/leaderboard_repository.dart';
import 'package:questhub/features/leaderboard/presentation/providers/leaderboard_providers.dart';
import 'package:questhub/features/leaderboard/presentation/screens/leaderboard_screen.dart';

import '../../helpers/mock_auth_repository.dart';
import '../../helpers/mock_leaderboard_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockLeaderboardRepository mockLeaderboardRepo;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockLeaderboardRepo = MockLeaderboardRepository();
    mockAuthRepo = MockAuthRepository();

    when(() => mockAuthRepo.currentUserId).thenReturn('current-user');
    when(() => mockAuthRepo.authStateChanges())
        .thenAnswer((_) => const Stream.empty());
  });

  Future<void> pumpLeaderboardScreen(
    WidgetTester tester, {
    List<LeaderboardEntry> entries = const [],
    int? userRank,
  }) async {
    when(() => mockLeaderboardRepo.fetchLeaderboard(any(), weekly: any(named: 'weekly')))
        .thenAnswer((_) async => entries);
    when(() => mockLeaderboardRepo.listenToUserRank(any(), any()))
        .thenAnswer((_) => Stream.value(userRank));

    await tester.pumpApp(
      const LeaderboardScreen(),
      overrides: [
        leaderboardRepositoryProvider.overrideWithValue(mockLeaderboardRepo),
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
      ],
    );
  }

  group('LeaderboardScreen', () {
    testWidgets('shows empty state when entries list is empty', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'city_code': 'testcity',
        'city_name': 'Test City',
      });

      await pumpLeaderboardScreen(tester, entries: []);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Be the first in'), findsOneWidget);
      expect(find.text('Play a game to appear here.'), findsOneWidget);
    });

    testWidgets('shows top 3 ranked entries', (tester) async {
      SharedPreferences.setMockInitialValues({
        'city_code': 'testcity',
        'city_name': 'Test City',
      });

      final entries = [
        LeaderboardEntry(
          rank: 1,
          userId: 'user-1',
          displayName: 'GoldWinner',
          totalPoints: 300,
          gamesPlayed: 10,
        ),
        LeaderboardEntry(
          rank: 2,
          userId: 'user-2',
          displayName: 'SilverRunner',
          totalPoints: 200,
          gamesPlayed: 8,
        ),
        LeaderboardEntry(
          rank: 3,
          userId: 'user-3',
          displayName: 'BronzeFinisher',
          totalPoints: 100,
          gamesPlayed: 5,
        ),
      ];

      await pumpLeaderboardScreen(tester, entries: entries);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('GoldWinner'), findsOneWidget);
      expect(find.text('SilverRunner'), findsOneWidget);
      expect(find.text('BronzeFinisher'), findsOneWidget);
    });

    testWidgets('current user row is highlighted when rank outside top list', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'city_code': 'testcity',
        'city_name': 'Test City',
      });

      final entries = [
        LeaderboardEntry(
          rank: 1,
          userId: 'other-1',
          displayName: 'Player1',
          totalPoints: 500,
          gamesPlayed: 20,
        ),
      ];

      await pumpLeaderboardScreen(
        tester,
        entries: entries,
        userRank: 42,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Your rank'), findsOneWidget);
      expect(find.text('42'), findsWidgets);
    });
  });
}
