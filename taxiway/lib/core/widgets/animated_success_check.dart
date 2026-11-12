import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// The recurring "success" badge (Booking Confirmed, Ride Completed, Bulk
/// Booking Confirmed): the disc scales in, the checkmark draws itself, and a
/// short radial burst fades out, with a light haptic tap on arrival.
class AnimatedSuccessCheck extends StatefulWidget {
  final double size;
  final double iconSize;

  const AnimatedSuccessCheck({super.key, this.size = 44, this.iconSize = 22});

  @override
  State<AnimatedSuccessCheck> createState() => _AnimatedSuccessCheckState();
}

class _AnimatedSuccessCheckState extends State<AnimatedSuccessCheck> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final diameter = widget.iconSize + widget.size * 0.4;

    return Semantics(
      label: 'Success',
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _SuccessPainter(
              t: _controller.value,
              color: colors.success,
              background: colors.successBackground,
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessPainter extends CustomPainter {
  _SuccessPainter({required this.t, required this.color, required this.background});

  final double t;
  final Color color;
  final Color background;

  double _phase(double begin, double end, Curve curve) =>
      curve.transform(((t - begin) / (end - begin)).clamp(0.0, 1.0));

  @override
  void paint(Canvas canvas, Size size) {
    final d = size.width;
    final center = size.center(Offset.zero);

    final disc = _phase(0, 0.35, Curves.easeOutBack);
    canvas.drawCircle(center, d / 2 * (0.4 + 0.6 * disc), Paint()..color = background);

    final burst = _phase(0.35, 1, Curves.easeOut);
    if (burst > 0 && burst < 1) {
      final spark = Paint()
        ..color = color.withValues(alpha: 1 - burst)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = d * 0.05;
      for (var i = 0; i < 8; i++) {
        final direction = Offset(math.cos(i * math.pi / 4), math.sin(i * math.pi / 4));
        final start = d * (0.56 + 0.22 * burst);
        final end = start + d * 0.10 * (1 - burst);
        canvas.drawLine(center + direction * start, center + direction * end, spark);
      }
    }

    final check = _phase(0.30, 0.65, Curves.easeOut);
    if (check > 0) {
      final path = Path()
        ..moveTo(d * 0.30, d * 0.52)
        ..lineTo(d * 0.45, d * 0.66)
        ..lineTo(d * 0.72, d * 0.38);
      final metric = path.computeMetrics().first;
      canvas.drawPath(
        metric.extractPath(0, metric.length * check),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = d * 0.085
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_SuccessPainter oldDelegate) => oldDelegate.t != t;
}
