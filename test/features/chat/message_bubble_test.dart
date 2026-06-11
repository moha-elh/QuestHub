import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questhub/features/chat/domain/message.dart';
import 'package:questhub/features/chat/presentation/widgets/message_bubble.dart';

import '../../helpers/pump_app.dart';

Message _textMessage({
  String id = 'm1',
  String senderId = 'user1',
  String senderName = 'Alice',
  String content = 'Hello',
  MessageType type = MessageType.text,
  Map<String, List<String>> reactions = const {},
}) {
  return Message(
    id: id,
    senderId: senderId,
    senderName: senderName,
    type: type,
    content: content,
    reactions: reactions,
    createdAt: DateTime.now().toUtc(),
  );
}

void main() {
  group('MessageBubble', () {
    testWidgets('renders own message right-aligned', (tester) async {
      await tester.pumpApp(Material(
        child: SizedBox(
          width: 400,
          height: 600,
          child: MessageBubble(
            message: _textMessage(senderId: 'me', senderName: 'Me'),
            isOwn: true,
          ),
        ),
      ));

      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.crossAxisAlignment, CrossAxisAlignment.end);
    });

    testWidgets('renders other message left-aligned', (tester) async {
      await tester.pumpApp(Material(
        child: SizedBox(
          width: 400,
          height: 600,
          child: MessageBubble(
            message: _textMessage(senderId: 'user1', senderName: 'Alice'),
            isOwn: false,
          ),
        ),
      ));

      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('renders system message centered pill-style', (tester) async {
      await tester.pumpApp(Material(
        child: SizedBox(
          width: 400,
          height: 600,
          child: MessageBubble(
            message: _textMessage(
              type: MessageType.system,
              content: 'Player joined',
            ),
            isOwn: false,
          ),
        ),
      ));

      expect(find.text('Player joined'), findsOneWidget);
    });

    testWidgets('shows reactions below message', (tester) async {
      await tester.pumpApp(Material(
        child: SizedBox(
          width: 400,
          height: 600,
          child: MessageBubble(
            message: _textMessage(reactions: {
              '🔥': ['user1', 'user2'],
            }),
            isOwn: false,
          ),
        ),
      ));

      expect(find.text('🔥 2'), findsOneWidget);
    });
  });
}
