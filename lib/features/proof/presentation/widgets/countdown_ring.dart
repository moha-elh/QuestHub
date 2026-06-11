import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CountdownRing extends StatelessWidget {
  const CountdownRing({
    required this.remainingSeconds,
    required this.totalSeconds,
    this.size = 48,
    super.key,
  });

  final int remainingSeconds;
  final int totalSeconds;
  final double size;

  Color get _ringColor {
    final ratio = remainingSeconds / totalSeconds;
    if (ratio > 0.5) return AppColors.primary;
    if (ratio > 0.25) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final progress = remainingSeconds / totalSeconds;

    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _CountdownPainter(
          progress: progress.clamp(0.0, 1.0),
          color: _ringColor,
        ),
        child: Center(
          child: Text(
            '$remainingSeconds',
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.w700,
              color: _ringColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownPainter extends CustomPainter {
  _CountdownPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    const strokeWidth = 3.5;

    final bgPaint = Paint()
      ..color = AppColors.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * pi * progress;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      -sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CountdownPainter old) =>
      old.progress != progress || old.color != color;
}
