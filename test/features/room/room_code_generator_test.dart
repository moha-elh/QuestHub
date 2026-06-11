import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/room/data/room_code_generator.dart';

void main() {
  group('generateRoomCode', () {
    test('always produces exactly 6 characters, all digits', () {
      final rng = Random(42);
      for (var i = 0; i < 1000; i++) {
        final code = generateRoomCode(random: rng);
        expect(code, hasLength(6));
        expect(RegExp(r'^\d{6}$').hasMatch(code), isTrue, reason: code);
      }
    });

    test('zero-pads small values', () {
      // Random(seed) chosen so nextInt yields a value < 100000 is hard to
      // pin down; instead force it with a fake that returns a small number.
      final code = generateRoomCode(random: _FixedRandom(7));
      expect(code, '000007');
    });

    test('produces a spread of distinct codes', () {
      final rng = Random(1);
      final codes = {
        for (var i = 0; i < 500; i++) generateRoomCode(random: rng),
      };
      // Collisions in 500 draws from 1e6 values should be near zero.
      expect(codes.length, greaterThan(490));
    });
  });
}

/// Random stub whose nextInt always returns [value].
class _FixedRandom implements Random {
  _FixedRandom(this.value);

  final int value;

  @override
  int nextInt(int max) => value;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0;
}
