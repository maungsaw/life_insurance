import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show AppColors;

class DotIndicator extends Decoration {
  final Color color;
  final double radius;

  const DotIndicator({this.color = AppColors.darkPrimary, this.radius = 3.0});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(color: color, radius: radius);
  }
}

class _DotPainter extends BoxPainter {
  final Color color;
  final double radius;

  _DotPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Calculate the center point at the bottom of the active tab label
    final double x = offset.dx + configuration.size!.width / 2;
    final double y = offset.dy + configuration.size!.height - radius;

    canvas.drawCircle(Offset(x, y), radius, paint);
  }
}
