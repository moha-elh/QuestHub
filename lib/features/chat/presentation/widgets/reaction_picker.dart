import 'package:flutter/material.dart';

class ReactionPicker extends StatelessWidget {
  const ReactionPicker({
    required this.onSelected,
    super.key,
  });

  final ValueChanged<String> onSelected;

  static const emojis = ['👀', '😂', '🔥', '💀', '👏', '😤'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: emojis
          .map((e) => InkWell(
                onTap: () => onSelected(e),
                child: Text(e, style: const TextStyle(fontSize: 28)),
              ))
          .toList(),
    );
  }
}
