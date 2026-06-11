import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/auth/domain/auth_repository.dart';
import 'package:questhub/features/auth/presentation/providers/auth_controller.dart';
import 'package:questhub/features/auth/presentation/providers/auth_providers.dart';

import '../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  AuthController notifier() => container.read(authControllerProvider.notifier);

  group('signInWithEmail', () {
    test('sets data state on success', () async {
      when(
        () => repository.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});

      await notifier()
          .signInWithEmail(email: 'a@b.com', password: 'password123');

      expect(container.read(authControllerProvider).hasError, isFalse);
      expect(container.read(authControllerProvider).isLoading, isFalse);
      verify(
        () => repository.signInWithEmail(
          email: 'a@b.com',
          password: 'password123',
        ),
      ).called(1);
    });

    test('is loading while the repository call is in flight', () async {
      when(
        () => repository.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future.delayed(const Duration(milliseconds: 10)));

      final future = notifier()
          .signInWithEmail(email: 'a@b.com', password: 'password123');

      expect(container.read(authControllerProvider).isLoading, isTrue);
      await future;
      expect(container.read(authControllerProvider).isLoading, isFalse);
    });

    test('surfaces AuthException as error state', () async {
      when(
        () => repository.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthException('Email or password is incorrect.'));

      await notifier().signInWithEmail(email: 'a@b.com', password: 'wrong');

      final state = container.read(authControllerProvider);
      expect(state.hasError, isTrue);
      expect(
        (state.error! as AuthException).message,
        'Email or password is incorrect.',
      );
    });
  });

  group('signUpWithEmail', () {
    test('forwards all fields to the repository', () async {
      when(
        () => repository.signUpWithEmail(
          username: any(named: 'username'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});

      await notifier().signUpWithEmail(
        username: 'quester',
        email: 'a@b.com',
        password: 'password123',
      );

      verify(
        () => repository.signUpWithEmail(
          username: 'quester',
          email: 'a@b.com',
          password: 'password123',
        ),
      ).called(1);
      expect(container.read(authControllerProvider).hasError, isFalse);
    });
  });

  group('signInWithGoogle', () {
    test('cancellation resets to idle without an error', () async {
      when(() => repository.signInWithGoogle())
          .thenThrow(const AuthCancelledException());

      await notifier().signInWithGoogle();

      final state = container.read(authControllerProvider);
      expect(state.hasError, isFalse);
      expect(state.isLoading, isFalse);
    });

    test('failure surfaces error state', () async {
      when(() => repository.signInWithGoogle())
          .thenThrow(const AuthException('Google sign-in failed.'));

      await notifier().signInWithGoogle();

      expect(container.read(authControllerProvider).hasError, isTrue);
    });
  });

  test('signOut delegates to the repository', () async {
    when(() => repository.signOut()).thenAnswer((_) async {});

    await notifier().signOut();

    verify(() => repository.signOut()).called(1);
  });
}
