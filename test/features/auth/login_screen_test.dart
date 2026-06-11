import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/auth/domain/auth_repository.dart';
import 'package:questhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:questhub/features/auth/presentation/screens/login_screen.dart';

import '../../helpers/mock_auth_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  Future<void> pumpLogin(WidgetTester tester) => tester.pumpApp(
        const LoginScreen(),
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );

  testWidgets('shows validation errors when submitting empty form',
      (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter a password.'), findsOneWidget);
    verifyNever(
      () => repository.signInWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('rejects malformed email', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
  });

  testWidgets('submits trimmed credentials to the controller',
      (tester) async {
    when(
      () => repository.signInWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await pumpLogin(tester);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      '  player@questhub.app  ',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    verify(
      () => repository.signInWithEmail(
        email: 'player@questhub.app',
        password: 'password123',
      ),
    ).called(1);
  });

  testWidgets('shows the error banner when sign-in fails', (tester) async {
    when(
      () => repository.signInWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const AuthException('Email or password is incorrect.'));

    await pumpLogin(tester);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'player@questhub.app',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpassword');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Email or password is incorrect.'), findsOneWidget);
  });
}
