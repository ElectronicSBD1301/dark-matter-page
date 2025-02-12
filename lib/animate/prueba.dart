// 📌 Widget para visualizar el efecto 3D del anillo antes de usarlo como fondo
import 'dart:math';

import 'package:flutter/material.dart';

// 📌 Widget de previsualización del anillo 3D antes de ponerlo de fondo
class Preview3DRing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 400,
      //   child: Rotating3DRing(), // Llamar a la animación 3D
    );
  }
}
/*
// 📌 Widget principal con el anillo volumétrico en 3D
class Rotating3DRing extends StatefulWidget {
  @override
  _Rotating3DRingState createState() => _Rotating3DRingState();
}

class _Rotating3DRingState extends State<Rotating3DRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _rotationAnimation =
        Tween<double>(begin: 0, end: pi * 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateX(0.4) // Inclinación inicial en X para perspectiva
            ..rotateY(
                _rotationAnimation.value * 0.6) // Rotación más pronunciada en Y
            ..rotateZ(sin(_rotationAnimation.value) *
                0.3) // Deformación dinámica en Z
            ..scale(
                1.2, 0.8), // Aplana un poco el anillo para simular profundidad
          child: CustomPaint(
            size: const Size(400, 400),
            painter: Thick3DRingPainter(),
          ),
        );
      },
    );
  }
}

// 📌 CustomPainter para dibujar el anillo volumétrico con efecto 3D realista
class Thick3DRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = min(size.width, size.height) * 0.48;
    final innerRadius =
        outerRadius * 0.55; // Reducimos más para aumentar el grosor

    // 🔹 Fondo con iluminación radial
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.purple.shade900.withOpacity(0.85),
          Colors.black.withOpacity(0.3),
        ],
        radius: 1.5,
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius));

    canvas.drawCircle(center, outerRadius, backgroundPaint);

    // 🔹 Creación del anillo con volumen y reflejos metálicos
    final ringPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.tealAccent.shade400.withOpacity(1),
          Colors.pinkAccent.withOpacity(0.9),
          Colors.tealAccent.shade400.withOpacity(1),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRadius - innerRadius // Grosor aumentado
      ..maskFilter = const MaskFilter.blur(
          BlurStyle.solid, 10); // Difuminado para profundidad

    canvas.drawCircle(center, (outerRadius + innerRadius) / 2, ringPaint);

    // 🔹 Sombras internas para mejorar el efecto de volumen
    final shadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.black.withOpacity(0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius));

    canvas.drawCircle(center, innerRadius, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant Thick3DRingPainter oldDelegate) => false;
}
*/