import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/room/presentation/screens/create_or_join_screen.dart';
import '../../features/room/presentation/screens/join_room_screen.dart';
import '../../features/room/presentation/screens/lobby_screen.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const join = '/join';

  /// Lobby (and later, game session) for a room: `/room/{roomId}`.
  static String room(String roomId) => '/room/$roomId';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  // Re-evaluate redirects whenever auth state changes (login/logout).
  final refresh = _StreamListenable(authRepository.authStateChanges());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final signedIn = authRepository.currentUserId != null;
      final onAuthScreen = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      if (!signedIn && !onAuthScreen) return AppRoutes.login;
      if (signedIn && onAuthScreen) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const CreateOrJoinScreen(),
      ),
      GoRoute(
        path: AppRoutes.join,
        builder: (context, state) => const JoinRoomScreen(),
      ),
      GoRoute(
        path: '/room/:roomId',
        builder: (context, state) =>
            LobbyScreen(roomId: state.pathParameters['roomId']!),
      ),
    ],
  );
});

/// Adapts a [Stream] to a [Listenable] for GoRouter's `refreshListenable`.
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
