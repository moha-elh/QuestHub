import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/auth/domain/auth_repository.dart';
import 'package:questhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:questhub/features/proof/domain/proof.dart';
import 'package:questhub/features/proof/domain/proof_repository.dart';
import 'package:questhub/features/proof/presentation/providers/proof_providers.dart';
import 'package:questhub/features/proof/presentation/screens/voting_screen.dart';
import 'package:questhub/features/room/domain/room.dart';
import 'package:questhub/features/room/domain/room_repository.dart';
import 'package:questhub/features/room/presentation/providers/room_providers.dart';

import '../../helpers/mock_auth_repository.dart';
import '../../helpers/mock_proof_repository.dart';
import '../../helpers/mock_room_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockProofRepository mockProofRepo;
  late MockRoomRepository mockRoomRepo;
  late MockAuthRepository mockAuthRepo;
  late StreamController<Proof> proofController;
  late StreamController<Room> roomController;
  const testRoomId = 'room-01';
  const testProofId = 'proof-01';

  Proof _proof({
    String submitterId = 'other-user',
    ProofStatus status = ProofStatus.pending,
    Map<String, String> votes = const {},
  }) {
    return Proof(
      id: testProofId,
      submitterId: submitterId,
      submitterName:
          submitterId == 'current-user' ? 'Submitter' : 'OtherPlayer',
      questId: 'q1',
      questTitle: 'Test quest',
      questPoints: 25,
      imageUrl: 'https://example.com/img.jpg',
      thumbnailUrl: 'https://example.com/img.jpg',
      votes: votes,
      status: status,
      submittedAt: DateTime.now().toUtc(),
      votingDeadline: DateTime.now().toUtc().add(const Duration(seconds: 30)),
    );
  }

  Room _room() {
    return Room(
      id: testRoomId,
      hostId: 'current-user',
      code: '123456',
      createdAt: DateTime.now().toUtc(),
      players: {
        'current-user': RoomPlayer(
          displayName: 'CurrentUser',
          joinedAt: DateTime.now().toUtc(),
          lastSeenAt: DateTime.now().toUtc(),
        ),
        'other-user': RoomPlayer(
          displayName: 'OtherPlayer',
          joinedAt: DateTime.now().toUtc(),
          lastSeenAt: DateTime.now().toUtc(),
        ),
      },
    );
  }

  setUp(() {
    mockProofRepo = MockProofRepository();
    mockRoomRepo = MockRoomRepository();
    mockAuthRepo = MockAuthRepository();
    proofController = StreamController<Proof>.broadcast();
    roomController = StreamController<Room>.broadcast();

    when(() => mockAuthRepo.currentUserId).thenReturn('current-user');
    when(() => mockAuthRepo.authStateChanges())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockProofRepo.listenToProof(any(), any()))
        .thenAnswer((_) => proofController.stream);
    when(() => mockRoomRepo.listenToRoom(any()))
        .thenAnswer((_) => roomController.stream);
    when(() => mockRoomRepo.heartbeat(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    proofController.close();
    roomController.close();
  });

  Future<void> pumpVotingScreen(WidgetTester tester) async {
    await tester.pumpApp(
      VotingScreen(roomId: testRoomId, proofId: testProofId),
      overrides: [
        proofRepositoryProvider.overrideWithValue(mockProofRepo),
        roomRepositoryProvider.overrideWithValue(mockRoomRepo),
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
      ],
    );
  }

  group('VotingScreen', () {
    testWidgets('submitter does not see vote buttons (read-only mode)',
        (tester) async {
      await pumpVotingScreen(tester);
      proofController.add(_proof(submitterId: 'current-user'));
      roomController.add(_room());
      await tester.pump();

      expect(find.text('Real ✓'), findsNothing);
      expect(find.text('Fake ✗'), findsNothing);
      expect(find.text('Waiting for votes…'), findsOneWidget);
    });

    testWidgets('non-submitter sees vote buttons', (tester) async {
      await pumpVotingScreen(tester);
      proofController.add(_proof());
      roomController.add(_room());
      await tester.pump();

      expect(find.text('Real ✓'), findsOneWidget);
      expect(find.text('Fake ✗'), findsOneWidget);
    });

    testWidgets('tapping Real calls castVote', (tester) async {
      when(() => mockProofRepo.castVote(
            roomId: any(named: 'roomId'),
            proofId: any(named: 'proofId'),
            vote: any(named: 'vote'),
          )).thenAnswer((_) async {});

      await pumpVotingScreen(tester);
      proofController.add(_proof());
      roomController.add(_room());
      await tester.pump();

      await tester.ensureVisible(find.text('Real ✓'));
      await tester.pump();
      await tester.tap(find.text('Real ✓'));
      await tester.pump();

      verify(() => mockProofRepo.castVote(
            roomId: testRoomId,
            proofId: testProofId,
            vote: 'real',
          )).called(1);
    });

    testWidgets('tapping Fake calls castVote', (tester) async {
      when(() => mockProofRepo.castVote(
            roomId: any(named: 'roomId'),
            proofId: any(named: 'proofId'),
            vote: any(named: 'vote'),
          )).thenAnswer((_) async {});

      await pumpVotingScreen(tester);
      proofController.add(_proof());
      roomController.add(_room());
      await tester.pump();

      await tester.ensureVisible(find.text('Fake ✗'));
      await tester.pump();
      await tester.tap(find.text('Fake ✗'));
      await tester.pump();

      verify(() => mockProofRepo.castVote(
            roomId: testRoomId,
            proofId: testProofId,
            vote: 'fake',
          )).called(1);
    });

    testWidgets('shows vote count', (tester) async {
      await pumpVotingScreen(tester);
      proofController.add(_proof(votes: {'voter1': 'real'}));
      roomController.add(_room());
      await tester.pump();

      expect(find.textContaining('1 of 1 voted'), findsWidgets);
    });

    testWidgets('resolved proof shows overlay', (tester) async {
      await pumpVotingScreen(tester);
      proofController
          .add(_proof(status: ProofStatus.approved));
      roomController.add(_room());
      await tester.pump();
      // Post-frame callback fires during first pump.
      // setState rebuild + overlay animation need a second pump.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('PROOF APPROVED'), findsOneWidget);
    });
  });
}
