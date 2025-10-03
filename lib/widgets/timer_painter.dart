// lib/widgets/timer_painter.dart

import 'dart:math';
import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color progressColor;
  final Color backgroundColor;

  TimerPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //print('PAINT METHOD: Progress is $progress');
    // General paint setup
    final strokeWidth = 20.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Paint for the background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw the full background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Paint for the progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Makes the ends of the arc rounded

    // Calculate the angle for the arc
    final sweepAngle = 2 * pi * progress;

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from the top (12 o'clock)
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
bool shouldRepaint(covariant TimerPainter oldDelegate) {
  // This tells the painter to only redraw itself if the progress value
  // or the colors have actually changed between frames.
  return oldDelegate.progress != progress ||
         oldDelegate.progressColor != progressColor ||
         oldDelegate.backgroundColor != backgroundColor;
}
}