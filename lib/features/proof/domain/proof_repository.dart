import 'dart:io';

import 'proof.dart';

abstract interface class ProofRepository {
  Future<String> submitProof({
    required String roomId,
    required String questId,
    required String questTitle,
    required int questPoints,
    required File imageFile,
  });

  Stream<Proof?> listenToActiveProof(String roomId);
}
