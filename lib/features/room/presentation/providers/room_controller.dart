import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/room_repository.dart';
import 'room_providers.dart';

/// Drives room actions. Join/create methods return the room id on success
/// (null on failure) so screens can navigate; errors land in the
/// [AsyncValue] state for banners.
class RoomController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  RoomRepository get _repository => ref.read(roomRepositoryProvider);

  Future<String?> createRoom({
    required bool isPublic,
    required int maxPlayers,
  }) =>
      _runForId(
        () => _repository.createRoom(isPublic: isPublic, maxPlayers: maxPlayers),
      );

  Future<String?> joinByCode(String code) =>
      _runForId(() => _repository.joinByCode(code));

  Future<String?> joinPublic() => _runForId(() => _repository.joinPublic());

  Future<void> leaveRoom(String roomId) =>
      _run(() => _repository.leaveRoom(roomId));

  Future<void> setReady(String roomId, {required bool isReady}) =>
      _run(() => _repository.setReady(roomId, isReady: isReady));

  Future<void> startGame(String roomId) =>
      _run(() => _repository.startGame(roomId));

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
  }

  Future<String?> _runForId(Future<String> Function() action) async {
    state = const AsyncLoading();
    String? roomId;
    state = await AsyncValue.guard(() async {
      roomId = await action();
    });
    return roomId;
  }
}

final roomControllerProvider =
    AsyncNotifierProvider<RoomController, void>(RoomController.new);
