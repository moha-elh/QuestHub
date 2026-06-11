import 'dart:math';

/// Generates a 6-digit room code, zero-padded (e.g. "042781").
///
/// Uniqueness against live rooms is enforced by the repository, which
/// re-rolls on collision.
String generateRoomCode({Random? random}) {
  final rng = random ?? Random.secure();
  return rng.nextInt(1000000).toString().padLeft(6, '0');
}
