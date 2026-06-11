import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// OTP-style 6-digit code entry: auto-advances per digit, backspace steps
/// back, and pasting a full 6-digit code fills every box.
class RoomCodeInput extends StatefulWidget {
  const RoomCodeInput({required this.onCompleted, this.enabled = true, super.key});

  /// Called with the full 6-digit code once every box is filled.
  final void Function(String code) onCompleted;
  final bool enabled;

  static const length = 6;

  @override
  State<RoomCodeInput> createState() => _RoomCodeInputState();
}

class _RoomCodeInputState extends State<RoomCodeInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      RoomCodeInput.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(RoomCodeInput.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // Paste: distribute the digits across all boxes.
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < RoomCodeInput.length; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      _focusNodes[digits.length.clamp(0, RoomCodeInput.length - 1)]
          .requestFocus();
    } else if (value.isNotEmpty && index < RoomCodeInput.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_code.length == RoomCodeInput.length) {
      FocusManager.instance.primaryFocus?.unfocus();
      widget.onCompleted(_code);
    }
  }

  /// Backspace on an empty box jumps to (and clears) the previous one.
  KeyEventResult _onKeyEvent(int index, FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(RoomCodeInput.length, (index) {
        return Container(
          width: 46,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Focus(
            onKeyEvent: (node, event) => _onKeyEvent(index, node, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              enabled: widget.enabled,
              onChanged: (value) => _onChanged(index, value),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTypography.code.copyWith(fontSize: 24, letterSpacing: 0),
              decoration: const InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              // Allow >1 char so paste events reach _onChanged intact.
              maxLength: index == 0 ? RoomCodeInput.length : 1,
              cursorColor: AppColors.primary,
            ),
          ),
        );
      }),
    );
  }
}
