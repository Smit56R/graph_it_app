import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()..color = Color.fromRGBO(225, 216, 245, 1);
    var paint2 = Paint()..color = Color.fromRGBO(191, 180, 222, 1);
    Offset centre1 = Offset(size.width, size.height);
    Offset centre2 = Offset(0, size.height);
    canvas.drawCircle(centre1, size.width / 2 + 100, paint1);
    canvas.drawCircle(centre2, size.width / 2 + 50, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
