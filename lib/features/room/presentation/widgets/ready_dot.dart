import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Ready indicator: pulsing green when ready, static grey otherwise.
class ReadyDot extends StatefulWidget {
  const ReadyDot({required this.isReady, super.key});

  final bool isReady;

  @override
  State<ReadyDot> createState() => _ReadyDotState();
}

class _ReadyDotState extends State<ReadyDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(ReadyDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isReady != widget.isReady) _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.isReady) {
      _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isReady ? AppColors.success : AppColors.textFaint;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Pulse between 60% and 100% opacity with a soft glow.
        final t = widget.isReady ? _controller.value : 0.0;
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.6 + 0.4 * t),
            boxShadow: widget.isReady
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5 * t),
                      blurRadius: 8,
                      spreadRadius: 2 * t,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}
