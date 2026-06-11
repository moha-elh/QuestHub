import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// Stand-in used when Firebase fails to initialize (placeholder
/// `firebase_options.dart`). Lets the UI run for development; every auth
/// action explains what's missing instead of crashing.
class UnconfiguredAuthRepository implements AuthRepository {
  const UnconfiguredAuthRepository();

  static const _error = AuthException(
    'Firebase is not configured yet. Run `flutterfire configure` and rebuild.',
  );

  @override
  Stream<String?> authStateChanges() => Stream<String?>.value(null);

  @override
  String? get currentUserId => null;

  @override
  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) async =>
      throw _error;

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async =>
      throw _error;

  @override
  Future<void> signInWithGoogle() async => throw _error;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> updateUserCity({
    required String uid,
    required String city,
    required String cityCode,
  }) async {}

  @override
  Future<AppUser?> fetchUserProfile(String uid) async => null;
}
