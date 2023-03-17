import 'dart:math';

import 'package:cells/random.dart';
import 'package:flutter/material.dart';

import 'food.dart';

class Cell {
  double _x;
  double _y;
  int ticks = 0;
  int lifespan;
  bool alive = true;
  bool justEaten = false;

  Cell({double? x, double? y})
      : _x = x ?? Random().normalizedDouble(max: 200),
        _y = y ?? Random().normalizedDouble(max: 200),
        lifespan = Random().nextInt(20);

  List<Cell> divide() {
    ticks++;
    if (ticks >= lifespan) {
      alive = false;
      return [];
    }
    _x += Random().normalizedDouble(max: 5);
    _y += Random().normalizedDouble(max: 5);

    if (!justEaten) return [];
    justEaten = false;

    int divisions = Random().nextInt(10);

    return List.generate(
        divisions,
        (index) => Cell(
            x: _x + Random().normalizedDouble(max: 10),
            y: _y + Random().normalizedDouble(max: 10)));
  }

  void paint(Canvas canvas, Size size) {
    if (!alive) return;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Color.fromARGB(255, 255 - ticks * 10, 0, 0);
    canvas.drawRect(
        Rect.fromCenter(center: Offset(_x, _y), width: 3.0, height: 3.0),
        paint);
  }

  bool eat(Food food) {
    if (!alive) return false;

    final distance =
        sqrt((food.x - _x) * (food.x - _x) + (food.y - _y) * (food.y - _y));
    if (distance < 10) {
      lifespan + 5;
      justEaten = true;
      return true;
    }
    return false;
  }
}
