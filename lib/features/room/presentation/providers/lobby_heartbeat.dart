import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'room_providers.dart';

/// Keeps `players.{uid}.lastSeenAt` fresh while the lobby is open so the
/// stale-player Cloud Function doesn't evict us. Watched by LobbyScreen;
/// the timer dies with the screen.
final lobbyHeartbeatProvider = Provider.autoDispose.family<void, String>(
  (ref, roomId) {
    final repository = ref.watch(roomRepositoryProvider);
    final timer = Timer.periodic(const Duration(seconds: 10), (_) {
      // Best-effort: a missed beat (e.g. brief offline) is fine.
      unawaited(
        repository.heartbeat(roomId).catchError((Object _) {}),
      );
    });
    ref.onDispose(timer.cancel);
  },
);
