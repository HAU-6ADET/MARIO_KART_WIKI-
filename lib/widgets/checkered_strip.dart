import 'package:flutter/material.dart';

/// A thin black-and-white checkered-flag strip, used as a racing divider.
class CheckeredStrip extends StatelessWidget {
  final double height;
  final double opacity;

  const CheckeredStrip({super.key, this.height = 10, this.opacity = 0.9});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _CheckeredPainter(opacity)),
    );
  }
}

class _CheckeredPainter extends CustomPainter {
  final double opacity;

  _CheckeredPainter(this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.height / 2;
    final light = Paint()..color = Colors.white.withValues(alpha: opacity);
    final dark = Paint()..color = Colors.black.withValues(alpha: opacity);
    final cols = (size.width / cell).ceil();
    for (var row = 0; row < 2; row++) {
      for (var col = 0; col < cols; col++) {
        canvas.drawRect(
          Rect.fromLTWH(col * cell, row * cell, cell, cell),
          (row + col).isEven ? light : dark,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CheckeredPainter old) => old.opacity != opacity;
}
