import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/chat_repository.dart';
import '../domain/message.dart';
import 'word_filter.dart';

class FirebaseChatRepository implements ChatRepository {
  FirebaseChatRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User get _user {
    final user = _auth.currentUser;
    if (user == null) throw const ChatException('Not signed in');
    return user;
  }

  CollectionReference<Map<String, dynamic>> _messagesCol(String roomId) =>
      _firestore.collection('rooms').doc(roomId).collection('messages');

  DocumentReference<Map<String, dynamic>> _typingDoc(String roomId) =>
      _firestore.collection('rooms').doc(roomId).collection('typing').doc(_auth.currentUser!.uid);

  @override
  Future<void> sendMessage({
    required String roomId,
    required String content,
  }) async {
    final user = _user;
    final filtered = WordFilter.apply(content);
    final truncated = filtered.length > 500 ? '${filtered.substring(0, 500)}... read more' : filtered;

    await _messagesCol(roomId).add({
      'senderId': user.uid,
      'senderName': user.displayName ?? user.email?.split('@').first ?? 'player',
      'senderAvatarUrl': user.photoURL,
      'type': 'text',
      'content': truncated,
      'reactions': <String, List<String>>{},
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Message>> listenToMessages(String roomId) {
    return _messagesCol(roomId)
        .orderBy('createdAt', descending: false)
        .limitToLast(100)
        .snapshots()
        .map((snap) => snap.docs
            .where((doc) => doc.data()['createdAt'] != null)
            .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<void> addReaction({
    required String roomId,
    required String messageId,
    required String emoji,
  }) async {
    final uid = _user.uid;
    await _messagesCol(roomId).doc(messageId).update({
      'reactions.$emoji': FieldValue.arrayUnion([uid]),
    });
  }

  @override
  Future<void> removeReaction({
    required String roomId,
    required String messageId,
    required String emoji,
  }) async {
    final uid = _user.uid;
    await _messagesCol(roomId).doc(messageId).update({
      'reactions.$emoji': FieldValue.arrayRemove([uid]),
    });
  }

  @override
  Future<void> updateTyping(String roomId) async {
    await _typingDoc(roomId).set({
      'lastTypedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<Map<String, DateTime>> listenToTyping(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('typing')
        .snapshots()
        .map((snap) => {
              for (final doc in snap.docs)
                doc.id: (doc.data()['lastTypedAt'] as Timestamp).toDate().toUtc(),
            });
  }
}

class ChatException implements Exception {
  const ChatException(this.message);
  final String message;
  @override
  String toString() => message;
}
