import 'dart:async';
import 'dart:math';

import 'cell.dart';
import 'food.dart';

class PetriDish {
  final double _height;
  final double _width;
  var _cells = List<Cell>.empty(growable: true);
  final _food = List<Food>.empty(growable: true);
  late Timer _timer;

  PetriDish(this._height, this._width);

  void start({void Function()? notifyChanged}) {
    _initFood(_height, _width);
    _cells.clear();
    final initialCell = Cell(x: _width / 2, y: _height / 2);
    _cells.add(initialCell);
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _next();
      if (notifyChanged != null) {
        notifyChanged();
      }
    });
  }

  void stop() {
    _timer.cancel();
  }

  void _initFood(double height, double width) {
    _food.clear();
    final foodY = List.generate(100, (index) => index * height / 100);
    final foodX = List.generate(200, (index) => index * width / 200);

    for (final x in foodX) {
      for (final y in foodY) {
        _food.add(Food(x: x, y: y));
      }
    }
  }

  void _next() {
    bool limitCellPopulation(int length) {
      return Random().nextDouble() < 5000 / length;
    }

    final oldCells = [
      ..._cells.where((element) {
        return limitCellPopulation(_cells.length) && element.alive;
      })
    ];
    for (final cell in oldCells) {
      for (final food in _food) {
        food.eat(cell);
      }
    }
    final newCells = oldCells
        .map((cell) => cell.divide())
        .expand((element) => element)
        .where((element) => limitCellPopulation(_cells.length));

    _cells = [...oldCells, ...newCells];
  }

  int get cellCount => _cells.length;

  int get averageLifespan {
    if (_cells.isEmpty) return 0;

    final avgLifespan = _cells
            .map((c) => c.lifespan)
            .fold(0, (value, element) => value + element) /
        _cells.length;
    return avgLifespan.ceil();
  }

  List<Cell> get cells => _cells;
  List<Food> get food => _food;
}
