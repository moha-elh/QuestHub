import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class QuestCountdownTimer extends StatefulWidget {
  const QuestCountdownTimer({
    required this.totalSeconds,
    required this.remainingSeconds,
    super.key,
  });

  final int totalSeconds;
  final int remainingSeconds;

  @override
  State<QuestCountdownTimer> createState() => _QuestCountdownTimerState();
}

class _QuestCountdownTimerState extends State<QuestCountdownTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(QuestCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ratio = _ratio;
    if (ratio <= 0.25) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double get _ratio =>
      widget.totalSeconds > 0
          ? widget.remainingSeconds / widget.totalSeconds
          : 0;

  Color get _color {
    if (_ratio > 0.5) {
      final diff = widget.totalSeconds - widget.remainingSeconds;
      return Color.lerp(
        AppColors.primary,
        AppColors.tierEasy,
        diff / (widget.totalSeconds * 0.5),
      )!;
    }
    if (_ratio > 0.25) return AppColors.warning;
    return AppColors.danger;
  }

  String get _formattedTime {
    final minutes = widget.remainingSeconds ~/ 60;
    final seconds = widget.remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const size = 200.0;
    const strokeWidth = 10.0;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final opacity = _ratio <= 0.25 ? _pulseAnimation.value : 1.0;
        return Opacity(
          opacity: opacity,
          child: SizedBox.square(
            dimension: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size.square(size),
                  painter: _TimerArcPainter(
                    backgroundColor: AppColors.outline,
                    foregroundColor: _color,
                    sweepAngle: 2 * math.pi * _ratio,
                    strokeWidth: strokeWidth,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formattedTime,
                      style: AppTypography.code.copyWith(
                        fontSize: 40,
                        color: _color,
                      ),
                    ),
                    Text(
                      'remaining',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimerArcPainter extends CustomPainter {
  _TimerArcPainter({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.sweepAngle,
    required this.strokeWidth,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final double sweepAngle;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      Paint()
        ..color = foregroundColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(_TimerArcPainter oldDelegate) =>
      oldDelegate.sweepAngle != sweepAngle ||
      oldDelegate.foregroundColor != foregroundColor;
}
