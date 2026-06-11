import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/app_user.dart';
import '../domain/auth_repository.dart';
import 'auth_exceptions.dart';

/// Production [AuthRepository] backed by Firebase Auth + Firestore.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  /// google_sign_in 7.x requires a one-time initialize() before authenticate.
  Future<void>? _googleInit;

  static const _usersCollection = 'users';

  @override
  Stream<String?> authStateChanges() =>
      _auth.authStateChanges().map((user) => user?.uid);

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(username);
      // TODO(profile-session): enforce username uniqueness via a
      // `usernames/{name}` reservation doc inside a transaction.
      await _createUserDoc(uid: user.uid, username: username, email: email);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final account = await _authenticateWithGoogle();
      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // First Google sign-in: bootstrap the profile document.
      final doc =
          await _firestore.collection(_usersCollection).doc(user.uid).get();
      if (!doc.exists) {
        await _createUserDoc(
          uid: user.uid,
          username: user.displayName ?? user.email?.split('@').first ?? 'player',
          email: user.email ?? '',
        );
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthCancelledException();
      }
      throw const AuthException('Google sign-in failed. Please try again.');
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  Future<GoogleSignInAccount> _authenticateWithGoogle() async {
    _googleInit ??= _googleSignIn.initialize();
    await _googleInit;
    return _googleSignIn.authenticate();
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> updateUserCity({
    required String uid,
    required String city,
    required String cityCode,
  }) async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'city': city,
      'cityCode': cityCode,
    });
  }

  @override
  Future<AppUser?> fetchUserProfile(String uid) async {
    final doc =
        await _firestore.collection(_usersCollection).doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromJson({...doc.data()!, 'uid': doc.id});
  }

  Future<void> _createUserDoc({
    required String uid,
    required String username,
    required String email,
  }) {
    final user = AppUser(
      uid: uid,
      username: username,
      email: email,
      createdAt: DateTime.now().toUtc(),
    );
    return _firestore.collection(_usersCollection).doc(uid).set(user.toJson());
  }
}
