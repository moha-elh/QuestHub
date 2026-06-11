import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/room.dart';
import '../domain/room_repository.dart';
import 'room_code_generator.dart';

/// Production [RoomRepository] backed by Firestore.
class FirebaseRoomRepository implements RoomRepository {
  FirebaseRoomRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const _roomsCollection = 'rooms';
  static const _codeRetries = 5;

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _firestore.collection(_roomsCollection);

  User get _user {
    final user = _auth.currentUser;
    if (user == null) {
      throw const RoomUnknownException(); // signed-out users can't reach here
    }
    return user;
  }

  RoomPlayer _selfAsPlayer() {
    final user = _user;
    final now = DateTime.now().toUtc();
    return RoomPlayer(
      displayName:
          user.displayName ?? user.email?.split('@').first ?? 'player',
      avatarUrl: user.photoURL,
      joinedAt: now,
      lastSeenAt: now,
    );
  }

  @override
  Future<String> createRoom({
    required bool isPublic,
    required int maxPlayers,
  }) async {
    final code = await _uniqueCode();
    final room = Room(
      id: '', // not serialized; Firestore assigns the doc id
      hostId: _user.uid,
      code: code,
      isPublic: isPublic,
      maxPlayers: maxPlayers,
      players: {_user.uid: _selfAsPlayer()},
      createdAt: DateTime.now().toUtc(),
    );
    final doc = await _rooms.add(room.toJson());
    return doc.id;
  }

  /// Rolls codes until one isn't held by a live (non-finished) room.
  Future<String> _uniqueCode() async {
    for (var attempt = 0; attempt < _codeRetries; attempt++) {
      final code = generateRoomCode();
      final clash = await _rooms
          .where('code', isEqualTo: code)
          .where('status', whereIn: ['waiting', 'in_progress'])
          .limit(1)
          .get();
      if (clash.docs.isEmpty) return code;
    }
    throw const RoomUnknownException();
  }

  @override
  Future<String> joinByCode(String code) async {
    final snapshot = await _rooms
        .where('code', isEqualTo: code)
        .where('status', isEqualTo: 'waiting')
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) throw const RoomNotFoundException();
    return _joinRoom(snapshot.docs.first.reference);
  }

  @override
  Future<String> joinPublic() async {
    final snapshot = await _rooms
        .where('isPublic', isEqualTo: true)
        .where('status', isEqualTo: 'waiting')
        .limit(10)
        .get();

    // Capacity can't be expressed in the query; filter client-side.
    for (final doc in snapshot.docs) {
      final room = _fromDoc(doc);
      if (!room.isFull) {
        try {
          return await _joinRoom(doc.reference);
        } on RoomException {
          continue; // filled up or closed since the query — try the next one
        }
      }
    }

    // No open public room: become the host of a fresh one.
    return createRoom(isPublic: true, maxPlayers: 8);
  }

  /// Transactionally adds the current user to [roomRef], re-validating
  /// capacity and status against the latest snapshot.
  Future<String> _joinRoom(
    DocumentReference<Map<String, dynamic>> roomRef,
  ) async {
    final uid = _user.uid;
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(roomRef);
      if (!doc.exists) throw const RoomNotFoundException();
      final room = _fromDoc(doc);

      if (room.status != RoomStatus.waiting) {
        throw const RoomAlreadyStartedException();
      }
      if (room.players.containsKey(uid)) return; // re-join is a no-op
      if (room.isFull) throw const RoomFullException();

      tx.update(roomRef, {'players.$uid': _selfAsPlayer().toJson()});
    });
    return roomRef.id;
  }

  @override
  Stream<Room> listenToRoom(String roomId) {
    return _rooms.doc(roomId).snapshots().map((doc) {
      if (!doc.exists) throw const RoomNotFoundException();
      return _fromDoc(doc);
    });
  }

  @override
  Future<void> leaveRoom(String roomId) async {
    final uid = _user.uid;
    final roomRef = _rooms.doc(roomId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(roomRef);
      if (!doc.exists) return;
      final room = _fromDoc(doc);
      if (!room.players.containsKey(uid)) return;

      final remaining = Map<String, RoomPlayer>.from(room.players)
        ..remove(uid);
      if (remaining.isEmpty) {
        tx.delete(roomRef);
        return;
      }

      final updates = <String, dynamic>{
        'players.$uid': FieldValue.delete(),
      };
      if (room.hostId == uid) {
        // Promote the earliest joiner. The Cloud Function covers the case
        // where the host disconnects without a clean leave.
        final nextHost = room.sortedPlayerEntries
            .firstWhere((entry) => entry.key != uid)
            .key;
        updates['hostId'] = nextHost;
      }
      tx.update(roomRef, updates);
    });
  }

  @override
  Future<void> setReady(String roomId, {required bool isReady}) {
    return _rooms.doc(roomId).update({
      'players.${_user.uid}.isReady': isReady,
    });
  }

  @override
  Future<void> startGame(String roomId) async {
    final roomRef = _rooms.doc(roomId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(roomRef);
      if (!doc.exists) throw const RoomNotFoundException();
      final room = _fromDoc(doc);

      if (room.hostId != _user.uid || !room.canStart) {
        throw const RoomUnknownException();
      }
      if (room.status != RoomStatus.waiting) {
        throw const RoomAlreadyStartedException();
      }

      tx.update(roomRef, {
        'status': 'in_progress',
        'startedAt': DateTime.now().toUtc().toIso8601String(),
      });
    });
  }

  @override
  Future<void> heartbeat(String roomId) {
    return _rooms.doc(roomId).update({
      'players.${_user.uid}.lastSeenAt':
          DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> endGame(String roomId) async {
    final roomRef = _rooms.doc(roomId);
    Map<String, RoomPlayer>? players;
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(roomRef);
      if (!doc.exists) throw const RoomNotFoundException();
      final room = _fromDoc(doc);
      if (room.hostId != _user.uid) throw const RoomUnknownException();
      if (room.status != RoomStatus.inProgress) {
        throw const RoomUnknownException();
      }
      players = room.players;
      tx.update(roomRef, {
        'status': 'finished',
        'endedAt': DateTime.now().toUtc().toIso8601String(),
      });
    });

    // Aggregate room scores into user profiles.
    if (players != null) {
      final batch = _firestore.batch();
      for (final entry in players!.entries) {
        final userId = entry.key;
        final player = entry.value;
        final userRef = _firestore.collection('users').doc(userId);
        batch.update(userRef, {
          'totalPoints': FieldValue.increment(player.score),
          'weeklyPoints': FieldValue.increment(player.score),
          'gamesPlayed': FieldValue.increment(1),
          'questsCompleted': FieldValue.increment(player.questsCompleted),
        });
      }
      await batch.commit();
    }
  }

  @override
  Future<void> resetGame(String roomId) async {
    final roomRef = _rooms.doc(roomId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(roomRef);
      if (!doc.exists) throw const RoomNotFoundException();
      final room = _fromDoc(doc);
      if (room.hostId != _user.uid) throw const RoomUnknownException();
      if (room.status != RoomStatus.finished) {
        throw const RoomUnknownException();
      }

      final resetPlayers = room.players.map((key, player) =>
          MapEntry(key, player.copyWith(score: 0, skipUsed: false, questsCompleted: 0)));

      tx.update(roomRef, {
        'status': 'waiting',
        'endedAt': FieldValue.delete(),
        'startedAt': FieldValue.delete(),
        for (final entry in resetPlayers.entries)
          'players.${entry.key}.score': 0,
        for (final entry in resetPlayers.entries)
          'players.${entry.key}.skipUsed': false,
        for (final entry in resetPlayers.entries)
          'players.${entry.key}.questsCompleted': 0,
      });
    });
  }

  Room _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Room.fromJson({...doc.data()!, 'id': doc.id});
}
