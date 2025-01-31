import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Ejemplo de gradiente radial
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = RadialGradient(
      colors: [
        Colors.purple.shade700,
        Colors.black,
      ],
      center: const Alignment(0.1, -0.3),
      radius: 1.0,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);

    // Podrías dibujar círculos, path con Bezier, etc.
    final paintCircle = Paint()..color = Colors.purpleAccent.withOpacity(0.3);
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.5),
      200,
      paintCircle,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
