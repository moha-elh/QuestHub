import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:questhub/features/room/domain/room.dart';
import 'package:questhub/features/room/presentation/providers/room_providers.dart';
import 'package:questhub/features/room/presentation/screens/lobby_screen.dart';
import 'package:questhub/features/room/presentation/widgets/player_card.dart';

import '../../helpers/mock_auth_repository.dart';
import '../../helpers/mock_room_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockRoomRepository roomRepository;
  late MockAuthRepository authRepository;

  final baseTime = DateTime.utc(2026, 6, 11);

  RoomPlayer player(String name, {bool isReady = false, int joinOrder = 0}) =>
      RoomPlayer(
        displayName: name,
        joinedAt: baseTime.add(Duration(seconds: joinOrder)),
        lastSeenAt: baseTime,
        isReady: isReady,
      );

  Room room({required Map<String, RoomPlayer> players, String hostId = 'u1'}) =>
      Room(
        id: 'room1',
        hostId: hostId,
        code: '123456',
        createdAt: baseTime,
        players: players,
      );

  setUp(() {
    roomRepository = MockRoomRepository();
    authRepository = MockAuthRepository();
    when(() => authRepository.currentUserId).thenReturn('u1');
    when(() => roomRepository.heartbeat(any())).thenAnswer((_) async {});
  });

  Future<void> pumpLobby(WidgetTester tester, Room testRoom) async {
    when(() => roomRepository.listenToRoom('room1'))
        .thenAnswer((_) => Stream.value(testRoom));
    await tester.pumpApp(
      const LobbyScreen(roomId: 'room1'),
      overrides: [
        roomRepositoryProvider.overrideWithValue(roomRepository),
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    await tester.pump(); // flush the room stream
  }

  testWidgets('renders one card per player', (tester) async {
    await pumpLobby(
      tester,
      room(
        players: {
          'u1': player('alice', joinOrder: 0),
          'u2': player('bob', joinOrder: 1),
          'u3': player('carol', joinOrder: 2),
        },
      ),
    );
    await tester.pump(const Duration(milliseconds: 350)); // insert animations

    expect(find.byType(PlayerCard), findsNWidgets(3));
    expect(find.text('alice'), findsOneWidget);
    expect(find.text('bob'), findsOneWidget);
    expect(find.text('carol'), findsOneWidget);
  });

  testWidgets('start button is disabled for the host until 2+ are ready',
      (tester) async {
    await pumpLobby(
      tester,
      room(
        players: {
          'u1': player('alice', isReady: true, joinOrder: 0),
          'u2': player('bob', joinOrder: 1),
        },
      ),
    );

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Start game (2+ ready needed)'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('start button enables once 2 players are ready',
      (tester) async {
    await pumpLobby(
      tester,
      room(
        players: {
          'u1': player('alice', isReady: true, joinOrder: 0),
          'u2': player('bob', isReady: true, joinOrder: 1),
        },
      ),
    );

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Start game'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('non-host never sees the start button', (tester) async {
    when(() => authRepository.currentUserId).thenReturn('u2');
    await pumpLobby(
      tester,
      room(
        players: {
          'u1': player('alice', isReady: true, joinOrder: 0),
          'u2': player('bob', isReady: true, joinOrder: 1),
        },
      ),
    );

    expect(find.textContaining('Start game'), findsNothing);
  });
}
