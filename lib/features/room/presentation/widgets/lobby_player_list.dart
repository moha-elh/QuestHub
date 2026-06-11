import 'package:flutter/material.dart';

import '../../domain/room.dart';
import 'player_card.dart';

/// Player list that animates cards sliding in/out as the realtime players
/// map changes. Diffs the incoming room state against an [AnimatedList].
class LobbyPlayerList extends StatefulWidget {
  const LobbyPlayerList({
    required this.room,
    required this.currentUserId,
    super.key,
  });

  final Room room;
  final String? currentUserId;

  @override
  State<LobbyPlayerList> createState() => _LobbyPlayerListState();
}

class _LobbyPlayerListState extends State<LobbyPlayerList> {
  final _listKey = GlobalKey<AnimatedListState>();

  /// Uids in display (join) order, mirroring what the AnimatedList shows.
  late List<String> _uids;

  /// Last-known player data, so exit animations can still render a card for
  /// players that just disappeared from the room document.
  late Map<String, RoomPlayer> _knownPlayers;

  @override
  void initState() {
    super.initState();
    _uids = _sortedUids(widget.room);
    _knownPlayers = Map.of(widget.room.players);
  }

  static List<String> _sortedUids(Room room) =>
      room.sortedPlayerEntries.map((e) => e.key).toList();

  @override
  void didUpdateWidget(LobbyPlayerList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _applyDiff(_sortedUids(widget.room));
    _knownPlayers.addAll(widget.room.players);
  }

  void _applyDiff(List<String> next) {
    // Removals first (iterate a copy — _uids mutates).
    for (final uid in List.of(_uids)) {
      if (!next.contains(uid)) {
        final index = _uids.indexOf(uid);
        final removedPlayer = _knownPlayers[uid];
        _uids.removeAt(index);
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => removedPlayer == null
              ? const SizedBox.shrink()
              : _animatedCard(animation, player: removedPlayer, uid: uid),
          duration: const Duration(milliseconds: 250),
        );
      }
    }
    // Then insertions, in order.
    for (var i = 0; i < next.length; i++) {
      final uid = next[i];
      if (!_uids.contains(uid)) {
        _uids.insert(i, uid);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  Widget _animatedCard(
    Animation<double> animation, {
    required RoomPlayer player,
    required String uid,
  }) {
    final curved =
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero)
          .animate(curved),
      child: FadeTransition(
        opacity: curved,
        child: PlayerCard(
          player: player,
          isHost: uid == widget.room.hostId,
          isSelf: uid == widget.currentUserId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _uids.length,
      itemBuilder: (context, index, animation) {
        final uid = _uids[index];
        final player = widget.room.players[uid] ?? _knownPlayers[uid];
        if (player == null) return const SizedBox.shrink();
        return _animatedCard(animation, player: player, uid: uid);
      },
    );
  }
}
