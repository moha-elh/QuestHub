import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/auth/presentation/auth_validators.dart';

void main() {
  group('AuthValidators.email', () {
    test('rejects empty', () => expect(AuthValidators.email(''), isNotNull));
    test('rejects null', () => expect(AuthValidators.email(null), isNotNull));
    test(
      'rejects missing domain',
      () => expect(AuthValidators.email('foo@'), isNotNull),
    );
    test(
      'accepts valid email',
      () => expect(AuthValidators.email('foo@bar.com'), isNull),
    );
    test(
      'trims surrounding whitespace',
      () => expect(AuthValidators.email(' foo@bar.com '), isNull),
    );
  });

  group('AuthValidators.password', () {
    test(
      'rejects empty',
      () => expect(AuthValidators.password(''), isNotNull),
    );
    test(
      'rejects shorter than 8 chars',
      () => expect(AuthValidators.password('1234567'), isNotNull),
    );
    test(
      'accepts 8+ chars',
      () => expect(AuthValidators.password('12345678'), isNull),
    );
  });

  group('AuthValidators.confirmPassword', () {
    test(
      'rejects mismatch',
      () => expect(
        AuthValidators.confirmPassword('abcdefgh', 'different'),
        isNotNull,
      ),
    );
    test(
      'accepts match',
      () => expect(
        AuthValidators.confirmPassword('abcdefgh', 'abcdefgh'),
        isNull,
      ),
    );
  });

  group('AuthValidators.username', () {
    test(
      'rejects empty',
      () => expect(AuthValidators.username(''), isNotNull),
    );
    test(
      'rejects too short',
      () => expect(AuthValidators.username('ab'), isNotNull),
    );
    test(
      'rejects special characters',
      () => expect(AuthValidators.username('bad name!'), isNotNull),
    );
    test(
      'accepts letters, digits, underscores',
      () => expect(AuthValidators.username('quest_42'), isNull),
    );
  });
}
