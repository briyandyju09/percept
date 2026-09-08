import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../theme/typography.dart';

/// A calm countdown ring used by Observation Sprints, breathing drills,
/// and pressure drills. No urgency-red flashing — the ring simply drains,
/// consistent with the "low reactivity" brand.
class TimerRing extends StatefulWidget {
  const TimerRing({
    super.key,
    required this.totalSeconds,
    required this.onComplete,
    this.size = 120,
    this.autoStart = true,
  });

  final int totalSeconds;
  final VoidCallback onComplete;
  final double size;
  final bool autoStart;

  @override
  State<TimerRing> createState() => TimerRingState();
}

class TimerRingState extends State<TimerRing> {
  late double _remaining = widget.totalSeconds.toDouble();
  Timer? _timer;
  static const _tick = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) start();
  }

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(_tick, (t) {
      setState(() => _remaining -= 0.1);
      if (_remaining <= 0) {
        t.cancel();
        widget.onComplete();
      }
    });
  }

  void stop() => _timer?.cancel();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fraction = (_remaining / widget.totalSeconds).clamp(0.0, 1.0);
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _RingPainter(
              fraction: fraction,
              trackColor: context.perceptHairline,
              progressColor: context.perceptPrimary,
            ),
          ),
          Text(
            '${_remaining.ceil().clamp(0, widget.totalSeconds)}',
            style: TextStyle(
              fontSize: widget.size * 0.28,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.trackColor,
    required this.progressColor,
  });

  final double fraction;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -pi/2, start at top
      6.2832 * fraction, // 2*pi * fraction
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}
