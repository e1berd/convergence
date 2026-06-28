import 'dart:math' as math;

import 'package:flutter/material.dart';

class SyncLogo extends StatelessWidget {
  const SyncLogo({
    super.key,
    this.size = 40,
    this.containerColor,
    this.onContainerColor,
  });

  final double size;
  final Color? containerColor;
  final Color? onContainerColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CustomPaint(
      size: Size.square(size),
      painter: _SyncLogoPainter(
        container: containerColor ?? colors.primaryContainer,
        onContainer: onContainerColor ?? colors.onPrimaryContainer,
      ),
    );
  }
}

class _SyncLogoPainter extends CustomPainter {
  _SyncLogoPainter({required this.container, required this.onContainer});

  final Color container;
  final Color onContainer;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 1024;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(230 * s),
    );
    canvas.drawRRect(rrect, Paint()..color = container);

    final center = Offset(512 * s, 512 * s);
    final radius = 230 * s;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 70 * s
      ..strokeCap = StrokeCap.round
      ..color = onContainer;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, _deg(-40), _deg(200), false, stroke);
    canvas.drawArc(rect, _deg(140), _deg(200), false, stroke);

    _arrow(canvas, center, radius, _deg(160), onContainer, s);
    _arrow(canvas, center, radius, _deg(-20), onContainer, s);
  }

  void _arrow(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    Color color,
    double s,
  ) {
    final tip = center + Offset(math.cos(angle), math.sin(angle)) * radius;
    final back = angle + math.pi / 2;
    final a = tip + Offset(math.cos(back), math.sin(back)) * 120 * s;
    final inward = angle + math.pi;
    final b = tip + Offset(math.cos(inward), math.sin(inward)) * 150 * s;
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  double _deg(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(_SyncLogoPainter old) =>
      old.container != container || old.onContainer != onContainer;
}
