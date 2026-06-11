import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Typing indicator expiry', () {
    test('entries older than 3 seconds are filtered', () {
      final now = DateTime.now().toUtc();

      final typingMap = <String, DateTime>{
        'user1': now.subtract(const Duration(seconds: 1)),
        'user2': now.subtract(const Duration(seconds: 4)),
        'user3': now.subtract(const Duration(seconds: 2)),
        'user4': now.subtract(const Duration(seconds: 5)),
      };

      final currentUserId = 'self';
      final recent = typingMap.entries
          .where((e) => e.key != currentUserId)
          .where((e) => now.difference(e.value).inSeconds < 3)
          .map((e) => e.key)
          .toSet();

      expect(recent, {'user1', 'user3'});
    });

    test('current user is excluded from typing list', () {
      final now = DateTime.now().toUtc();

      final typingMap = <String, DateTime>{
        'self': now,
        'user1': now.subtract(const Duration(seconds: 1)),
      };

      final currentUserId = 'self';
      final recent = typingMap.entries
          .where((e) => e.key != currentUserId)
          .where((e) => now.difference(e.value).inSeconds < 3)
          .map((e) => e.key)
          .toSet();

      expect(recent, {'user1'});
      expect(recent, isNot(contains('self')));
    });

    test('empty map returns empty set', () {
      final typingMap = <String, DateTime>{};
      final currentUserId = 'self';
      final recent = typingMap.entries
          .where((e) => e.key != currentUserId)
          .where((e) => DateTime.now().toUtc().difference(e.value).inSeconds < 3)
          .map((e) => e.key)
          .toSet();

      expect(recent, isEmpty);
    });
  });
}
