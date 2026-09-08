import 'dart:math';
import 'package:flutter/cupertino.dart';
import '../models/dimension_scores.dart';
import '../theme/colors.dart';

/// A calm, minimal radar/spider chart of the 7 [DimensionScores] — no
/// gradients, no glow, just a filled polygon on a hairline grid, in
/// keeping with Percept's "no confetti" visual language.
class DimensionRadarChart extends StatelessWidget {
  const DimensionRadarChart({super.key, required this.scores, this.size = 260});

  final DimensionScores scores;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadarPainter(
          values: DimensionScores.dimensionKeys.map((k) => scores[k]).toList(),
          labels: DimensionScores.dimensionKeys
              .map((k) => DimensionMeta.glyphs[k] ?? '•')
              .toList(),
          gridColor: isDark ? PerceptColors.hairlineDark : PerceptColors.hairlineLight,
          fillColor: (isDark ? PerceptColors.primaryDark : PerceptColors.primaryLight)
              .withValues(alpha: 0.22),
          strokeColor: isDark ? PerceptColors.primaryDark : PerceptColors.primaryLight,
          labelColor: isDark ? PerceptColors.textSecondaryDark : PerceptColors.textSecondaryLight,
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.values,
    required this.labels,
    required this.gridColor,
    required this.fillColor,
    required this.strokeColor,
    required this.labelColor,
  });

  final List<int> values;
  final List<String> labels;
  final Color gridColor;
  final Color fillColor;
  final Color strokeColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 24;
    final n = values.length;
    if (n == 0) return;
    final angleStep = 2 * pi / n;

    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Concentric rings at 25/50/75/100%.
    for (final fraction in [0.25, 0.5, 0.75, 1.0]) {
      final path = Path();
      for (var i = 0; i < n; i++) {
        final angle = -pi / 2 + angleStep * i;
        final point = center +
            Offset(cos(angle), sin(angle)) * radius * fraction;
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Spokes.
    for (var i = 0; i < n; i++) {
      final angle = -pi / 2 + angleStep * i;
      final point = center + Offset(cos(angle), sin(angle)) * radius;
      canvas.drawLine(center, point, gridPaint);
    }

    // Data polygon.
    final dataPath = Path();
    for (var i = 0; i < n; i++) {
      final angle = -pi / 2 + angleStep * i;
      final fraction = (values[i].clamp(0, 100)) / 100;
      final point = center + Offset(cos(angle), sin(angle)) * radius * fraction;
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, Paint()..color = fillColor);
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Glyph labels just outside the outer ring.
    for (var i = 0; i < n; i++) {
      final angle = -pi / 2 + angleStep * i;
      final point = center + Offset(cos(angle), sin(angle)) * (radius + 16);
      final painter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(fontSize: 15, color: labelColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        point - Offset(painter.width / 2, painter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.values != values;
}
