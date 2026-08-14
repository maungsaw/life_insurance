import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

/// Confetti that bursts from the top corners, then falls off the bottom.
class SuccessCornerConfetti extends StatelessWidget {
  const SuccessCornerConfetti({
    super.key,
    required this.progress,
  });

  /// 0 → 1 full flight (burst + fall).
  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _CornerConfettiPainter(progress: progress.clamp(0.0, 1.0)),
      ),
    );
  }
}

enum _Shape { circle, rect }

class _Particle {
  const _Particle({
    required this.fromLeft,
    required this.midX,
    required this.midY,
    required this.endX,
    required this.endY,
    required this.size,
    required this.color,
    required this.spin,
    required this.delay,
    required this.shape,
  });

  final bool fromLeft;
  /// Normalized mid / end positions (0–1 of canvas).
  final double midX;
  final double midY;
  final double endX;
  final double endY;
  final double size;
  final Color color;
  final double spin;
  final double delay;
  final _Shape shape;
}

final List<_Particle> _kParticles = _buildParticles();

List<_Particle> _buildParticles() {
  final rng = math.Random(42);
  const colors = <Color>[
    Color(0xFFF8A5C2),
    Color(0xFFF9E79F),
    AppColors.lightPrimary,
    Color(0xFF7DCFB6),
    Color(0xFFFFC9B5),
  ];

  _Particle one({required bool fromLeft}) {
    final midX = fromLeft
        ? 0.06 + rng.nextDouble() * 0.42
        : 0.52 + rng.nextDouble() * 0.42;
    final midY = 0.08 + rng.nextDouble() * 0.22;
    final drift = (rng.nextDouble() - 0.5) * 0.18;
    return _Particle(
      fromLeft: fromLeft,
      midX: midX,
      midY: midY,
      endX: (midX + drift).clamp(0.02, 0.98),
      // Past the bottom so pieces leave the screen.
      endY: 1.05 + rng.nextDouble() * 0.25,
      size: 5 + rng.nextDouble() * 8,
      color: colors[rng.nextInt(colors.length)],
      spin: (rng.nextDouble() - 0.5) * 4.5,
      delay: rng.nextDouble() * 0.18,
      shape: rng.nextBool() ? _Shape.circle : _Shape.rect,
    );
  }

  return [
    for (var i = 0; i < 9; i++) one(fromLeft: true),
    for (var i = 0; i < 9; i++) one(fromLeft: false),
  ];
}

class _CornerConfettiPainter extends CustomPainter {
  _CornerConfettiPainter({required this.progress});

  final double progress;

  /// Burst from corners → mid (top band), then fall to bottom.
  static const double _burstEnd = 0.28;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || size.isEmpty) return;

    for (final p in _kParticles) {
      final span = 1.0 - p.delay;
      if (span <= 0) continue;
      final local = ((progress - p.delay) / span).clamp(0.0, 1.0);
      if (local <= 0) continue;

      final ox = p.fromLeft ? -16.0 : size.width + 16.0;
      final oy = -12.0;
      final mx = p.midX * size.width;
      final my = p.midY * size.height;
      final ex = p.endX * size.width;
      final ey = p.endY * size.height;

      late final double x;
      late final double y;
      late final double rot;

      if (local <= _burstEnd) {
        final u = Curves.easeOutCubic.transform(local / _burstEnd);
        x = ox + (mx - ox) * u;
        y = oy + (my - oy) * u;
        rot = p.spin * 0.35 * u;
      } else {
        final u = Curves.easeInCubic.transform(
          (local - _burstEnd) / (1 - _burstEnd),
        );
        x = mx + (ex - mx) * u;
        y = my + (ey - my) * u;
        rot = p.spin * (0.35 + 0.65 * u);
      }

      // Fade in quickly, hold, then fade out as pieces leave.
      final double alpha;
      if (local < 0.08) {
        alpha = local / 0.08;
      } else if (local > 0.72) {
        alpha = (1 - local) / 0.28;
      } else {
        alpha = 1;
      }

      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha.clamp(0.0, 1.0) * 0.95)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);

      if (p.shape == _Shape.circle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        final w = p.size * 1.7;
        final h = p.size * 0.55;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: w, height: h),
            const Radius.circular(2),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CornerConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
