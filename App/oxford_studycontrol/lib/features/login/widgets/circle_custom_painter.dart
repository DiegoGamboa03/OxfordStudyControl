import 'dart:math';

import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue // Color del semicírculo
      ..style = PaintingStyle.fill; // Relleno

    final double radius = size.width / 2; // Radio del semicírculo
    final Offset center =
        Offset(size.width / 2, size.height / 2); // Centro del semicírculo

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi, // Ángulo inicial (pi negativo para el semicírculo)
      pi, // Ángulo final (pi para un semicírculo completo)
      true, // Dibuja en el sentido de las agujas del reloj
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
