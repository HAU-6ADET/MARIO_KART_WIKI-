import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A speedometer-style half-circle gauge for a 0-100 rating. The arc sweeps
/// up to the value when the screen opens.
class OverallGauge extends StatelessWidget {
  final int rating;
  final Color color;
  final String caption;

  const OverallGauge({
    super.key,
    required this.rating,
    required this.color,
    this.caption = 'OVERALL',
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final target = (rating / 100).clamp(0.0, 1.0).toDouble();
    return SizedBox(
      width: 220,
      height: 120,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: target),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: _GaugePainter(value: value, color: color),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(value * 100).round()}',
                      style: textTheme.displaySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 34,
                      ),
                    ),
                    Text(
                      caption,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = math.min(size.width / 2, size.height - 10) - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..color = AppColors.surfaceHigh;
    canvas.drawArc(rect, math.pi, math.pi, false, base);

    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, math.pi, math.pi * value, false, active);

    // Tick marks inside the arc, like a dial.
    final tick = Paint()
      ..strokeWidth = 2
      ..color = AppColors.textTertiary;
    for (var i = 0; i <= 10; i++) {
      final angle = math.pi + math.pi * i / 10;
      final dir = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + dir * (radius - 14),
        center + dir * (radius - 22),
        tick,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.color != color;
}
