import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/proof/presentation/screens/proof_capture_screen.dart';
import '../../features/proof/presentation/screens/voting_screen.dart';
import '../../features/quest/domain/quest.dart';
import '../../features/quest/presentation/screens/active_quest_screen.dart';
import '../../features/room/presentation/screens/create_or_join_screen.dart';
import '../../features/room/presentation/screens/join_room_screen.dart';
import '../../features/room/presentation/screens/lobby_screen.dart';
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../features/scoreboard/presentation/screens/post_game_screen.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const join = '/join';
  static const leaderboard = '/leaderboard';

  /// Lobby (and later, game session) for a room: `/room/{roomId}`.
  static String room(String roomId) => '/room/$roomId';

  /// Active quest screen: `/room/{roomId}/quest`.
  static String quest(String roomId) => '/room/$roomId/quest';

  /// Proof capture screen: `/room/{roomId}/proof-capture`.
  static String proofCapture(String roomId) => '/room/$roomId/proof-capture';

  /// Voting screen: `/room/{roomId}/vote/{proofId}`.
  static String vote(String roomId, String proofId) =>
      '/room/$roomId/vote/$proofId';

  /// Post-game results screen: `/room/{roomId}/results`.
  static String results(String roomId) => '/room/$roomId/results';
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
        path: AppRoutes.leaderboard,
        builder: (context, state) => const LeaderboardScreen(),
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
      GoRoute(
        path: '/room/:roomId/quest',
        builder: (context, state) => ActiveQuestScreen(
          roomId: state.pathParameters['roomId']!,
        ),
      ),
      GoRoute(
        path: '/room/:roomId/proof-capture',
        builder: (context, state) => ProofCaptureScreen(
          roomId: state.pathParameters['roomId']!,
          quest: state.extra! as QuestAssignment,
        ),
      ),
      GoRoute(
        path: '/room/:roomId/vote/:proofId',
        builder: (context, state) => VotingScreen(
          roomId: state.pathParameters['roomId']!,
          proofId: state.pathParameters['proofId']!,
        ),
      ),
      GoRoute(
        path: '/room/:roomId/results',
        builder: (context, state) => PostGameScreen(
          roomId: state.pathParameters['roomId']!,
        ),
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
