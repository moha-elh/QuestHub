import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth_repository.dart';
import 'auth_providers.dart';

/// Drives all auth actions. Screens watch the [AsyncValue] state for
/// loading spinners and error banners — no business logic in widgets.
class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) =>
      _run(
        () => ref.read(authRepositoryProvider).signUpWithEmail(
              username: username,
              email: email,
              password: password,
            ),
      );

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _run(
        () => ref.read(authRepositoryProvider).signInWithEmail(
              email: email,
              password: password,
            ),
      );

  Future<void> signInWithGoogle() =>
      _run(() => ref.read(authRepositoryProvider).signInWithGoogle());

  Future<void> signOut() =>
      _run(() => ref.read(authRepositoryProvider).signOut());

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    // A user-cancelled flow (e.g. closing the Google sheet) is not an error.
    if (result.error is AuthCancelledException) {
      state = const AsyncData(null);
    } else {
      state = result;
    }
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);
