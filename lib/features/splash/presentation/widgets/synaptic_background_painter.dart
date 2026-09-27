import 'package:flutter/material.dart';

import '../../../../config/stitch_colors.dart';

class SynapticBackgroundPainter extends CustomPainter {
  const SynapticBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          StitchColors.primaryFixed.withValues(alpha: 0.45),
          StitchColors.surfaceContainer.withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.35),
          radius: size.width * 0.45,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.35),
      size.width * 0.45,
      auraPaint,
    );

    final linePaint = Paint()
      ..color = StitchColors.primaryContainer.withValues(alpha: 0.12)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.18)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.12,
        size.width,
        size.height * 0.22,
      );
    canvas.drawPath(path1, linePaint);

    final path2 = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.58,
        size.width,
        size.height * 0.45,
      );
    canvas.drawPath(path2, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
