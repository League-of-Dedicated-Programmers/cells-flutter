import 'package:flutter/material.dart';

import 'cell.dart';
import 'food.dart';

class CellPainter extends CustomPainter {
  List<Cell> cells;
  List<Food> food;
  CellPainter({required this.cells, required this.food});

  @override
  void paint(Canvas canvas, Size size) {
    for (var cell in cells) {
      cell.paint(canvas, size);
    }
    for (var f in food) {
      f.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
