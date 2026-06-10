import 'package:firebase_auth/firebase_auth.dart';

import '../domain/auth_repository.dart';

/// Maps Firebase error codes to messages we're happy to show users.
AuthException mapFirebaseAuthException(FirebaseAuthException e) {
  final message = switch (e.code) {
    'invalid-email' => 'That email address looks invalid.',
    'user-disabled' => 'This account has been disabled.',
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' =>
      'Email or password is incorrect.',
    'email-already-in-use' => 'An account already exists for that email.',
    'weak-password' => 'Password is too weak — use at least 8 characters.',
    'too-many-requests' => 'Too many attempts. Try again in a few minutes.',
    'network-request-failed' => 'No connection. Check your network and retry.',
    'operation-not-allowed' =>
      'This sign-in method is not enabled for QuestHub.',
    _ => 'Something went wrong signing you in. Please try again.',
  };
  return AuthException(message);
}
