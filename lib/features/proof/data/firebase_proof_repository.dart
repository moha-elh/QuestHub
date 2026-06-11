import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/proof.dart';
import '../domain/proof_repository.dart';
import 'image_compressor.dart';

class FirebaseProofRepository implements ProofRepository {
  FirebaseProofRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required ImageCompressor compressor,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage,
        _compressor = compressor;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ImageCompressor _compressor;

  User get _user {
    final user = _auth.currentUser;
    if (user == null) throw const ProofRepositoryException('Not signed in');
    return user;
  }

  CollectionReference<Map<String, dynamic>> _proofsCol(String roomId) =>
      _firestore.collection('rooms').doc(roomId).collection('proofs');

  @override
  Future<String> submitProof({
    required String roomId,
    required String questId,
    required String questTitle,
    required int questPoints,
    required File imageFile,
  }) async {
    final user = _user;
    final compressed = await _compressor.compress(imageFile);
    final proofRef = _proofsCol(roomId).doc();
    final proofId = proofRef.id;

    final storagePath = 'proofs/$roomId/$proofId.jpg';
    final uploadTask = _storage.ref(storagePath).putFile(compressed);
    final snapshot = await uploadTask;
    final imageUrl = await snapshot.ref.getDownloadURL();

    final now = DateTime.now().toUtc();
    final deadline = now.add(const Duration(seconds: 30));
    await proofRef.set({
      'submitterId': user.uid,
      'submitterName': user.displayName ?? user.email?.split('@').first ?? 'player',
      'submitterAvatarUrl': user.photoURL,
      'questId': questId,
      'questTitle': questTitle,
      'questPoints': questPoints,
      'imageUrl': imageUrl,
      'thumbnailUrl': imageUrl,
      'votes': <String, String>{},
      'status': 'pending',
      'submittedAt': now.toIso8601String(),
      'votingDeadline': deadline.toIso8601String(),
    });

    return proofId;
  }

  @override
  Stream<Proof?> listenToActiveProof(String roomId) {
    return _proofsCol(roomId)
        .where('status', isEqualTo: 'pending')
        .orderBy('submittedAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      return Proof.fromJson({...doc.data(), 'id': doc.id});
    });
  }

  @override
  Stream<Proof> listenToProof(String roomId, String proofId) {
    return _proofsCol(roomId)
        .doc(proofId)
        .snapshots()
        .map((doc) => Proof.fromJson({...doc.data()!, 'id': doc.id}));
  }

  @override
  Stream<List<Proof>> listenToResolvedProofs(String roomId) {
    return _proofsCol(roomId)
        .where('status', whereIn: ['approved', 'rejected'])
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Proof.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<void> castVote({
    required String roomId,
    required String proofId,
    required String vote,
  }) async {
    final uid = _user.uid;
    await _proofsCol(roomId).doc(proofId).update({
      'votes.$uid': vote,
    });
  }
}

class ProofRepositoryException implements Exception {
  const ProofRepositoryException(this.message);
  final String message;
  @override
  String toString() => message;
}
