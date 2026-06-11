import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questhub/features/room/domain/room_repository.dart';
import 'package:questhub/features/room/presentation/providers/room_providers.dart';
import 'package:questhub/features/room/presentation/screens/join_room_screen.dart';

import '../../helpers/mock_room_repository.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockRoomRepository repository;

  setUp(() {
    repository = MockRoomRepository();
  });

  Future<void> pumpJoin(WidgetTester tester) => tester.pumpApp(
        const JoinRoomScreen(),
        overrides: [roomRepositoryProvider.overrideWithValue(repository)],
      );

  Future<void> enterCode(WidgetTester tester, String code) async {
    final fields = find.byType(TextField);
    for (var i = 0; i < code.length; i++) {
      await tester.enterText(fields.at(i), code[i]);
    }
  }

  testWidgets('shows inline error when the room code is invalid',
      (tester) async {
    when(() => repository.joinByCode(any()))
        .thenThrow(const RoomNotFoundException());

    await pumpJoin(tester);
    await enterCode(tester, '123456');
    await tester.pumpAndSettle();

    expect(
      find.text('No room found with that code. Double-check and try again.'),
      findsOneWidget,
    );
    verify(() => repository.joinByCode('123456')).called(1);
  });

  testWidgets('shows inline error when the room is full', (tester) async {
    when(() => repository.joinByCode(any()))
        .thenThrow(const RoomFullException());

    await pumpJoin(tester);
    await enterCode(tester, '654321');
    await tester.pumpAndSettle();

    expect(find.text('That room is already full.'), findsOneWidget);
  });

  testWidgets('renders six code boxes', (tester) async {
    await pumpJoin(tester);
    expect(find.byType(TextField), findsNWidgets(6));
  });
}
