import 'app_user.dart';

/// Auth boundary for the app. Implementations live in `data/`.
///
/// The domain layer deliberately avoids Firebase types: auth state is exposed
/// as the signed-in uid (or null).
abstract interface class AuthRepository {
  /// Emits the signed-in user's uid, or null when signed out.
  Stream<String?> authStateChanges();

  /// Synchronous snapshot of the signed-in uid, used by router redirects.
  String? get currentUserId;

  /// Creates the account, sets the display name, and writes the initial
  /// `users/{uid}` profile document.
  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  });

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Google OAuth. Creates the profile document on first sign-in.
  ///
  /// Throws [AuthCancelledException] if the user dismisses the Google sheet.
  Future<void> signInWithGoogle();

  Future<void> signOut();

  /// Writes the user's chosen city to their `users/{uid}` profile doc.
  Future<void> updateUserCity({
    required String uid,
    required String city,
    required String cityCode,
  });

  /// Reads the user's profile doc from Firestore.
  Future<AppUser?> fetchUserProfile(String uid);
}

/// User-facing auth failure. [message] is safe to render directly.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The user aborted the flow (e.g. closed the Google account picker).
/// Callers should reset to idle without showing an error.
class AuthCancelledException implements Exception {
  const AuthCancelledException();
}
