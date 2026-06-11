import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:questhub/features/quest/presentation/providers/quest_providers.dart';
import 'package:questhub/features/quest/presentation/screens/active_quest_screen.dart';
import 'package:questhub/features/room/domain/room.dart';
import 'package:questhub/features/room/presentation/providers/room_providers.dart';

import '../../helpers/mock_auth_repository.dart';
import '../../helpers/mock_quest_repository.dart';
import '../../helpers/mock_room_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockQuestRepository questRepository;
  late MockRoomRepository roomRepository;

  const testRoomId = 'room-123';
  const testUserId = 'user-1';

  Room createRoomWithPlayer({bool skipUsed = false}) {
    return Room(
      id: testRoomId,
      hostId: 'host-1',
      code: 'ABC123',
      createdAt: DateTime.now().toUtc(),
      players: {
        testUserId: RoomPlayer(
          displayName: 'Player 1',
          joinedAt: DateTime.now().toUtc(),
          lastSeenAt: DateTime.now().toUtc(),
          skipUsed: skipUsed,
        ),
      },
    );
  }

  setUp(() {
    authRepository = MockAuthRepository();
    questRepository = MockQuestRepository();
    roomRepository = MockRoomRepository();

    when(() => authRepository.currentUserId).thenReturn(testUserId);
    when(() => authRepository.authStateChanges()).thenAnswer(
      (_) => const Stream.empty(),
    );
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    bool skipUsed = false,
  }) {
    when(() => questRepository.listenToMyQuest(testRoomId, testUserId))
        .thenAnswer((_) => Stream.value(
              createTestQuestAssignment(durationSeconds: 300),
            ));
    when(() => roomRepository.listenToRoom(testRoomId)).thenAnswer(
      (_) => Stream.value(createRoomWithPlayer(skipUsed: skipUsed)),
    );

    return tester.pumpApp(
      ActiveQuestScreen(roomId: testRoomId),
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        questRepositoryProvider.overrideWithValue(questRepository),
        roomRepositoryProvider.overrideWithValue(roomRepository),
      ],
    );
  }

  group('Skip quest button', () {
    testWidgets('shows skip button when skip has not been used',
        (tester) async {
      await pumpScreen(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.ensureVisible(find.text('Skip quest (-10 pts)'));
      await tester.pump();

      expect(find.text('Skip quest (-10 pts)'), findsOneWidget);
    });

    testWidgets('shows confirmation dialog when skip is tapped',
        (tester) async {
      await pumpScreen(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.ensureVisible(find.text('Skip quest (-10 pts)'));
      await tester.pump();
      await tester.tap(find.text('Skip quest (-10 pts)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Skip quest?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('calls skipQuest when confirmed', (tester) async {
      when(() => questRepository.skipQuest(testRoomId, testUserId))
          .thenAnswer((_) async {});

      await pumpScreen(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.ensureVisible(find.text('Skip quest (-10 pts)'));
      await tester.pump();
      await tester.tap(find.text('Skip quest (-10 pts)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Cancel'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      verifyNever(() => questRepository.skipQuest(any(), any()));
    });

    testWidgets('hides skip button when skip has been used', (tester) async {
      await pumpScreen(tester, skipUsed: true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Skip quest (-10 pts)'), findsNothing);
    });
  });
}
