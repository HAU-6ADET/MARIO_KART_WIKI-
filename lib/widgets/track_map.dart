import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/track_layouts.dart';
import '../theme/theme.dart';

/// Top-down course map drawn with a CustomPainter: asphalt road with kerbs,
/// a dashed center line, direction arrows, a checkered start/finish line
/// and sector / shortcut / hazard markers, plus a small legend.
class TrackMap extends StatelessWidget {
  final TrackLayout layout;
  final Color color;

  const TrackMap({super.key, required this.layout, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md - 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: _TrackMapPainter(layout: layout, color: color),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          const Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: 6,
            children: [
              _LegendDot(color: Colors.white, text: 'Sector'),
              _LegendDot(color: AppColors.success, text: 'Shortcut'),
              _LegendDot(color: AppColors.secondary, text: 'Hazard'),
              _LegendFlag(),
            ],
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            'Schematic layout, not to scale. Marker spots are approximate.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendDot({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(text, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _LegendFlag extends StatelessWidget {
  const _LegendFlag();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.sports_score_rounded, size: 14, color: Colors.white),
        const SizedBox(width: 4),
        Text('Start / finish', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _TrackMapPainter extends CustomPainter {
  final TrackLayout layout;
  final Color color;

  _TrackMapPainter({required this.layout, required this.color});

  /// Closed Catmull-Rom spline through [pts], sampled into a polyline.
  List<Offset> _sample(List<Offset> pts, Size size) {
    final n = pts.length;
    final out = <Offset>[];
    const steps = 18;
    for (var i = 0; i < n; i++) {
      final p0 = pts[(i - 1 + n) % n];
      final p1 = pts[i];
      final p2 = pts[(i + 1) % n];
      final p3 = pts[(i + 2) % n];
      for (var s = 0; s < steps; s++) {
        final u = s / steps;
        final u2 = u * u;
        final u3 = u2 * u;
        double c(double a, double b, double cc, double d) =>
            0.5 *
            ((2 * b) +
                (-a + cc) * u +
                (2 * a - 5 * b + 4 * cc - d) * u2 +
                (-a + 3 * b - 3 * cc + d) * u3);
        out.add(
          Offset(
            c(p0.dx, p1.dx, p2.dx, p3.dx) * size.width,
            c(p0.dy, p1.dy, p2.dy, p3.dy) * size.height,
          ),
        );
      }
    }
    return out;
  }

  /// Point and direction at fraction [t] (0-1) of the loop's length.
  (Offset, Offset) _at(List<Offset> poly, List<double> cum, double t) {
    final total = cum.last;
    var target = (t % 1.0) * total;
    var i = 1;
    while (i < cum.length - 1 && cum[i] < target) {
      i++;
    }
    final a = poly[i - 1];
    final b = poly[i];
    final segLen = cum[i] - cum[i - 1];
    final f = segLen == 0 ? 0.0 : (target - cum[i - 1]) / segLen;
    final pos = Offset.lerp(a, b, f)!;
    final d = b - a;
    final len = d.distance == 0 ? 1.0 : d.distance;
    return (pos, Offset(d.dx / len, d.dy / len));
  }

  void _label(Canvas canvas, String text, Offset center, Color c, double fs) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: c,
          fontSize: fs,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Backdrop with a faint grid.
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.background.withValues(alpha: 0.9),
    );
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final poly = _sample(layout.points, size);
    final cum = <double>[0];
    for (var i = 1; i < poly.length; i++) {
      cum.add(cum.last + (poly[i] - poly[i - 1]).distance);
    }
    // Close the loop.
    poly.add(poly.first);
    cum.add(cum.last + (poly.last - poly[poly.length - 2]).distance);

    final path = Path()..moveTo(poly.first.dx, poly.first.dy);
    for (final p in poly.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    path.close();

    final roadW = math.min(size.width, size.height) * 0.075;

    // Kerb, then asphalt, then dashed center line.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = roadW + 5
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = roadW
        ..strokeJoin = StrokeJoin.round
        ..color = const Color(0xFF2A3042),
    );
    final dash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.5);
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 6), dash);
        d += 12;
      }
    }

    // Direction arrows.
    for (final t in [0.22, 0.47, 0.72, 0.95]) {
      final (pos, dir) = _at(poly, cum, t);
      final normal = Offset(-dir.dy, dir.dx);
      final tip = pos + dir * 6;
      final arrow = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(
          (pos - dir * 4 + normal * 4.5).dx,
          (pos - dir * 4 + normal * 4.5).dy,
        )
        ..lineTo(
          (pos - dir * 4 - normal * 4.5).dx,
          (pos - dir * 4 - normal * 4.5).dy,
        )
        ..close();
      canvas.drawPath(
        arrow,
        Paint()..color = Colors.white.withValues(alpha: 0.85),
      );
    }

    // Start / finish: a checkered bar across the road.
    final (sPos, sDir) = _at(poly, cum, 0);
    final sNormal = Offset(-sDir.dy, sDir.dx);
    const cells = 4;
    final cell = (roadW + 4) / cells;
    for (var i = 0; i < cells; i++) {
      for (var j = 0; j < 2; j++) {
        final center =
            sPos +
            sNormal * ((i - (cells - 1) / 2) * cell) +
            sDir * ((j - 0.5) * cell);
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(math.atan2(sDir.dy, sDir.dx));
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: cell, height: cell),
          Paint()..color = (i + j).isEven ? Colors.white : Colors.black,
        );
        canvas.restore();
      }
    }

    // Markers.
    for (final m in layout.markers) {
      final (pos, _) = _at(poly, cum, m.t);
      late final Color fill;
      late final Color ink;
      late final String text;
      switch (m.type) {
        case MapMarkerType.sector:
          fill = Colors.white;
          ink = Colors.black87;
          text = m.label;
        case MapMarkerType.shortcut:
          fill = AppColors.success;
          ink = Colors.black87;
          text = '»';
        case MapMarkerType.hazard:
          fill = AppColors.secondary;
          ink = Colors.black87;
          text = '!';
      }
      canvas.drawCircle(pos, 10, Paint()..color = Colors.black54);
      canvas.drawCircle(pos, 8.5, Paint()..color = fill);
      _label(canvas, text, pos, ink, 11);
    }
  }

  @override
  bool shouldRepaint(_TrackMapPainter old) =>
      old.layout != layout || old.color != color;
}
