import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();
    paint.color = const Color(0xff33455B);
    path = Path();
    path.lineTo(size.width * 0.41, -0.62);
    path.cubicTo(size.width * 0.61, -0.61, size.width * 0.59, -0.4, size.width * 0.69, -0.29);
    path.cubicTo(size.width * 0.74, -0.23, size.width * 0.83, -0.18, size.width * 0.85, -0.11);
    path.cubicTo(size.width * 0.86, -0.03, size.width * 0.81, size.height * 0.04, size.width * 0.75, size.height * 0.11);
    path.cubicTo(size.width * 0.66, size.height / 5, size.width * 0.59, size.height * 0.35, size.width * 0.41, size.height * 0.37);
    path.cubicTo(size.width * 0.22, size.height * 0.4, 0, size.height * 0.35, -0.11, size.height * 0.24);
    path.cubicTo(-0.21, size.height * 0.14, -0.11, size.height * 0.01, -0.06, -0.11);
    path.cubicTo(-0.03, -0.19, size.width * 0.04, -0.24, size.width * 0.1, -0.31);
    path.cubicTo(size.width / 5, -0.42, size.width * 0.22, -0.63, size.width * 0.41, -0.62);
    path.cubicTo(size.width * 0.41, -0.62, size.width * 0.41, -0.62, size.width * 0.41, -0.62);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
