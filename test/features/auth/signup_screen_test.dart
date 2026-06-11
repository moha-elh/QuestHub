import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:questhub/features/auth/presentation/screens/signup_screen.dart';

import '../../helpers/mock_auth_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  Future<void> pumpSignup(WidgetTester tester) => tester.pumpApp(
        const SignupScreen(),
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );

  Future<void> fillForm(
    WidgetTester tester, {
    String username = 'quester',
    String email = 'player@questhub.app',
    String password = 'password123',
    String? confirm,
  }) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), username);
    await tester.enterText(fields.at(1), email);
    await tester.enterText(fields.at(2), password);
    await tester.enterText(fields.at(3), confirm ?? password);
  }

  testWidgets('shows validation errors when submitting empty form',
      (tester) async {
    await pumpSignup(tester);

    await tester.tap(find.text('Sign up'));
    await tester.pump();

    expect(find.text('Choose a username.'), findsOneWidget);
    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter a password.'), findsOneWidget);
  });

  testWidgets('rejects mismatched password confirmation', (tester) async {
    await pumpSignup(tester);

    await fillForm(tester, confirm: 'different123');
    await tester.tap(find.text('Sign up'));
    await tester.pump();

    expect(find.text('Passwords do not match.'), findsOneWidget);
    verifyNever(
      () => repository.signUpWithEmail(
        username: any(named: 'username'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('rejects invalid username', (tester) async {
    await pumpSignup(tester);

    await fillForm(tester, username: 'no spaces!');
    await tester.tap(find.text('Sign up'));
    await tester.pump();

    expect(
      find.text('3–20 characters: letters, numbers, underscores.'),
      findsOneWidget,
    );
  });

  testWidgets('valid form calls signUpWithEmail', (tester) async {
    when(
      () => repository.signUpWithEmail(
        username: any(named: 'username'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await pumpSignup(tester);

    await fillForm(tester);
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    verify(
      () => repository.signUpWithEmail(
        username: 'quester',
        email: 'player@questhub.app',
        password: 'password123',
      ),
    ).called(1);
  });
}
