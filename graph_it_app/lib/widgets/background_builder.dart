import 'package:flutter/material.dart';

import '../background_painter.dart';

class BackgroundBuilder extends StatelessWidget {
  final Scaffold child;

  BackgroundBuilder({required this.child});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomPaint(
          foregroundPainter: BackgroundPainter(),
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            color: Colors.white,
          ),
        ),
        child,
      ],
    );
  }
}
