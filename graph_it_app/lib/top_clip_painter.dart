import 'package:flutter/material.dart';

class TopClipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color.fromRGBO(191, 180, 222, 1)
      ..strokeWidth = 15;
    Offset centre = Offset(size.width / 2, -125);
    canvas.drawCircle(centre, 360, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
