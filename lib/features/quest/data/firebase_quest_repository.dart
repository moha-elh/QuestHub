import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/quest.dart';
import '../domain/quest_repository.dart';

class FirebaseQuestRepository implements QuestRepository {
  FirebaseQuestRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User get _user {
    final user = _auth.currentUser;
    if (user == null) throw const QuestRepositoryException('Not signed in');
    return user;
  }

  DocumentReference<Map<String, dynamic>> _questDoc(
    String roomId,
    String userId,
  ) =>
      _firestore.collection('rooms').doc(roomId).collection('quests').doc(userId);

  @override
  Stream<QuestAssignment?> listenToMyQuest(String roomId, String userId) {
    return _questDoc(roomId, userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return QuestAssignment.fromJson(doc.data()!);
    });
  }

  @override
  Future<void> markQuestComplete(String roomId, String userId) async {
    final uid = _user.uid;
    final docRef = _questDoc(roomId, userId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(docRef);
      if (!doc.exists) return;
      final data = doc.data()!;
      if (data['status'] != 'active') return;
      tx.update(docRef, {
        'status': 'completed',
        'completedAt': DateTime.now().toUtc().toIso8601String(),
      });
      tx.update(docRef.parent.parent!, {
        'players.$uid.score': FieldValue.increment(data['points'] as int),
      });
    });
  }

  @override
  Future<void> skipQuest(String roomId, String userId) async {
    final uid = _user.uid;
    final docRef = _questDoc(roomId, userId);
    final roomRef = _firestore.collection('rooms').doc(roomId);
    await _firestore.runTransaction((tx) async {
      final questDoc = await tx.get(docRef);
      final roomDoc = await tx.get(roomRef);

      if (!questDoc.exists) return;
      if (questDoc.data()!['status'] != 'active') return;

      if (!roomDoc.exists) throw const QuestRepositoryException('Room not found');
      final playerData =
          (roomDoc.data()!['players'] as Map<String, dynamic>)[uid]
              as Map<String, dynamic>?;
      if (playerData == null) {
        throw const QuestRepositoryException('Player not in room');
      }
      if (playerData['skipUsed'] == true) {
        throw const QuestRepositoryException('Skip already used this game');
      }

      tx.update(docRef, {
        'status': 'skipped',
        'completedAt': DateTime.now().toUtc().toIso8601String(),
      });
      tx.update(roomRef, {
        'players.$uid.score': FieldValue.increment(-10),
        'players.$uid.skipUsed': true,
      });
    });
  }
}

class QuestRepositoryException implements Exception {
  const QuestRepositoryException(this.message);
  final String message;
  @override
  String toString() => message;
}
