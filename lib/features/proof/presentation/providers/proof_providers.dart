import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/firebase_proof_repository.dart';
import '../../data/image_compressor.dart';
import '../../domain/proof.dart';
import '../../domain/proof_repository.dart';

final firebaseStorageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final imageCompressorProvider =
    Provider<ImageCompressor>((ref) => const DefaultImageCompressor());

final proofRepositoryProvider = Provider<ProofRepository>((ref) {
  return FirebaseProofRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
    storage: ref.watch(firebaseStorageProvider),
    compressor: ref.watch(imageCompressorProvider),
  );
});

final activeProofProvider = StreamProvider.family<Proof?, String>(
  (ref, roomId) =>
      ref.watch(proofRepositoryProvider).listenToActiveProof(roomId),
);
