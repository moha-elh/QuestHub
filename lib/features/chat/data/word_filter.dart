class WordFilter {
  WordFilter._();

  static const _banned = <String>[
    'spam',
    'badword',
  ];

  static String apply(String input) {
    var result = input;
    for (final word in _banned) {
      result = result.replaceAll(
        RegExp(RegExp.escape(word), caseSensitive: false),
        '*' * word.length,
      );
    }
    return result;
  }
}
