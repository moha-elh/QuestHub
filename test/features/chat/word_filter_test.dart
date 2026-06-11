import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/chat/data/word_filter.dart';

void main() {
  group('WordFilter', () {
    test('passes clean text through unchanged', () {
      expect(WordFilter.apply('hello world'), 'hello world');
    });

    test('replaces banned word with asterisks', () {
      expect(WordFilter.apply('this is spam'), 'this is ****');
    });

    test('replaces banned word case-insensitively', () {
      expect(WordFilter.apply('SPAM'), '****');
    });

    test('replaces multiple occurrences', () {
      expect(WordFilter.apply('spam spam spam'), '**** **** ****');
    });

    test('replaces multiple distinct banned words', () {
      expect(
        WordFilter.apply('spam and badword'),
        '**** and *******',
      );
    });

    test('handles partial word matches safely via RegExp.escape', () {
      // "spam" within "spammer" should still be matched
      expect(WordFilter.apply('spammer'), '****mer');
    });
  });
}
