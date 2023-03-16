import 'dart:async';
import 'dart:math';

import 'package:cells/cell_painter.dart';
import 'package:flutter/material.dart';

import 'cell.dart';
import 'food.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool resetting = false;

  void _reset() {
    setState(() {
      averageLifespan = 0;
      cellCount = 0;
      resetting = true;
    });
    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        resetting = false;
      });
    });
  }

  int averageLifespan = 0;
  int cellCount = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cells!'),
        backgroundColor: Colors.blue,
        actions: [
          Text('Cell Count: $cellCount'),
          SizedBox(
            width: 10,
          ),
          Text('Average Lifespan: $averageLifespan'),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: _reset,
            child: Text('Reset'),
          )
        ],
      ),
      body: SizedBox.expand(
          child: resetting
              ? null
              : Cells(
                  size: size,
                  setAverageLifespan: (int lifespan) => setState(() {
                    averageLifespan = lifespan;
                  }),
                  setCellCount: (int count) => setState(() {
                    cellCount = count;
                  }),
                )),
    );
  }
}

class Cells extends StatefulWidget {
  final Size size;
  final Function(int) setAverageLifespan;
  final Function(int) setCellCount;
  const Cells(
      {super.key,
      required this.size,
      required this.setAverageLifespan,
      required this.setCellCount});

  @override
  State<Cells> createState() => _CellsState();
}

class _CellsState extends State<Cells> {
  List<Cell> cells = [];
  List<Food> food = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final height = widget.size.height;
    final width = widget.size.width;
    final foodY = List.generate(100, (index) => index * height / 100);
    final foodX = List.generate(200, (index) => index * width / 200);

    for (final x in foodX) {
      for (final y in foodY) {
        food.add(Food(x: x, y: y));
      }
    }

    final initialCell = Cell(x: width / 2, y: height / 2);

    cells = [initialCell];
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      bool randomFactor(int length) {
        return Random().nextDouble() < 5000 / length;
      }

      setState(() {
        final oldCells = [
          ...cells.where((element) {
            return randomFactor(cells.length) && element.alive;
          })
        ];
        for (final cell in oldCells) {
          for (final food in food) {
            food.eat(cell);
          }
        }
        final newCells = oldCells
            .map((cell) => cell.divide())
            .expand((element) => element)
            .where((element) => randomFactor(cells.length));
        cells = [...oldCells, ...newCells];
        widget.setCellCount(cells.length);
        if (cells.length > 0) {
          final avgLifespan = cells
                  .map((c) => c.lifespan)
                  .fold(0, (value, element) => value + element) /
              cells.length;
          widget.setAverageLifespan(avgLifespan.ceil());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CellPainter(cells: cells, food: food),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
