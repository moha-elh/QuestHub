import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/auth/domain/auth_repository.dart';
import 'package:questhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:questhub/features/proof/domain/proof.dart';
import 'package:questhub/features/proof/domain/proof_repository.dart';
import 'package:questhub/features/proof/presentation/providers/proof_providers.dart';
import 'package:questhub/features/quest/domain/quest.dart';
import 'package:questhub/features/quest/domain/quest_repository.dart';
import 'package:questhub/features/quest/presentation/providers/quest_providers.dart';
import 'package:questhub/features/room/domain/room.dart';
import 'package:questhub/features/room/domain/room_repository.dart';
import 'package:questhub/features/room/presentation/providers/room_providers.dart';
import 'package:questhub/features/scoreboard/presentation/screens/post_game_screen.dart';

import '../../helpers/mock_auth_repository.dart';
import '../../helpers/mock_proof_repository.dart';
import '../../helpers/mock_quest_repository.dart';
import '../../helpers/mock_room_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockRoomRepository mockRoomRepo;
  late MockAuthRepository mockAuthRepo;
  late MockQuestRepository mockQuestRepo;
  late MockProofRepository mockProofRepo;
  late StreamController<Room> roomController;
  const testRoomId = 'room-01';

  Room _room({String hostId = 'host-user', int playerCount = 3}) {
    final players = <String, RoomPlayer>{};
    for (var i = 1; i <= playerCount; i++) {
      players['player-$i'] = RoomPlayer(
        displayName: 'Player $i',
        joinedAt: DateTime.now().toUtc(),
        lastSeenAt: DateTime.now().toUtc(),
        score: (playerCount - i + 1) * 10,
        questsCompleted: playerCount - i + 1,
      );
    }
    players[hostId] = RoomPlayer(
      displayName: 'HostPlayer',
      joinedAt: DateTime.now().toUtc(),
      lastSeenAt: DateTime.now().toUtc(),
      score: 100,
      questsCompleted: 5,
    );

    return Room(
      id: testRoomId,
      hostId: hostId,
      code: '123456',
      createdAt: DateTime.now().toUtc(),
      status: RoomStatus.finished,
      players: players,
    );
  }

  setUp(() {
    mockRoomRepo = MockRoomRepository();
    mockAuthRepo = MockAuthRepository();
    mockQuestRepo = MockQuestRepository();
    mockProofRepo = MockProofRepository();
    roomController = StreamController<Room>.broadcast();

    when(() => mockAuthRepo.authStateChanges())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockRoomRepo.listenToRoom(any()))
        .thenAnswer((_) => roomController.stream);
    when(() => mockQuestRepo.listenToAllQuests(any()))
        .thenAnswer((_) => Stream.value({}));
    when(() => mockProofRepo.listenToResolvedProofs(any()))
        .thenAnswer((_) => Stream.value(<Proof>[]));
  });

  tearDown(() {
    roomController.close();
  });

  Future<void> pumpPostGameScreen(
    WidgetTester tester, {
    String currentUserId = 'host-user',
  }) async {
    when(() => mockAuthRepo.currentUserId).thenReturn(currentUserId);
    await tester.pumpApp(
      PostGameScreen(roomId: testRoomId),
      overrides: [
        roomRepositoryProvider.overrideWithValue(mockRoomRepo),
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        questRepositoryProvider.overrideWithValue(mockQuestRepo),
        proofRepositoryProvider.overrideWithValue(mockProofRepo),
      ],
    );
  }

  group('PostGameScreen', () {
    testWidgets('shows podium with correct player order', (tester) async {
      await pumpPostGameScreen(tester);
      roomController.add(_room(playerCount: 4));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Game Over!'), findsOneWidget);
      expect(find.text('Player 1'), findsOneWidget);
      expect(find.text('HostPlayer'), findsOneWidget);
    });

    testWidgets('Play Again button visible only for host', (tester) async {
      await pumpPostGameScreen(tester, currentUserId: 'host-user');
      roomController.add(_room(hostId: 'host-user'));
      await tester.pump();

      expect(find.text('Play Again'), findsOneWidget);
    });

    testWidgets('Play Again button hidden for non-host', (tester) async {
      await pumpPostGameScreen(tester, currentUserId: 'non-host');
      roomController.add(_room(hostId: 'host-user'));
      await tester.pump();

      expect(find.text('Play Again'), findsNothing);
    });

    testWidgets('Leave button always visible', (tester) async {
      await pumpPostGameScreen(tester, currentUserId: 'non-host');
      roomController.add(_room(hostId: 'host-user'));
      await tester.pump();

      expect(find.text('Leave'), findsOneWidget);
    });

    testWidgets('shows rankings section when more than 3 players',
        (tester) async {
      await pumpPostGameScreen(tester);
      roomController.add(_room(playerCount: 5));
      await tester.pump();

      expect(find.text('Rankings'), findsOneWidget);
    });

    testWidgets('hides rankings section for 3 or fewer players',
        (tester) async {
      await pumpPostGameScreen(tester);
      roomController.add(_room(playerCount: 2));
      await tester.pump();

      expect(find.text('Rankings'), findsNothing);
    });

    testWidgets('shows MVPs section', (tester) async {
      await pumpPostGameScreen(tester);
      roomController.add(_room());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('MVPs'), findsOneWidget);
    });

    testWidgets('shows loading indicator while room loads',
        (tester) async {
      await pumpPostGameScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows Go Home button on error when room loads but has error',
        (tester) async {
      await pumpPostGameScreen(tester);
      roomController.add(_room());
      await tester.pump();
      await tester.pump();

      expect(find.text('Game Over!'), findsOneWidget);
      expect(find.text('Leave'), findsOneWidget);
    });
  });
}
