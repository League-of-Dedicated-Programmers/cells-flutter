import 'package:flutter/material.dart';

import 'cell.dart';

class Food {
  final double x;
  final double y;
  bool eaten = false;

  Food({required this.x, required this.y});

  void paint(Canvas canvas, Size size) {
    if (eaten) return;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: 10.0, height: 10.0),
        paint);
  }

  void eat(Cell cell) {
    if (!eaten) {
      eaten = cell.eat(this);
    }
  }
}
