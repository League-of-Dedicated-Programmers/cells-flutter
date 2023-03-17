import 'package:cells/cell_painter.dart';
import 'package:cells/petri_dish.dart';
import 'package:flutter/material.dart';

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
  PetriDish? _petriDish;
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _petriDish ??= PetriDish(size.height, size.width);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cells!'),
        backgroundColor: Colors.blue,
        actions: [
          Text('Cell Count: ${_petriDish!.cellCount}'),
          const SizedBox(
            width: 10,
          ),
          Text('Average Lifespan: ${_petriDish!.averageLifespan}'),
          const SizedBox(
            width: 10,
          ),
          _running
              ? ElevatedButton(
                  onPressed: () {
                    _petriDish!.stop();
                    setState(() {
                      _running = false;
                    });
                  },
                  child: const Text('Stop'),
                )
              : ElevatedButton(
                  onPressed: () {
                    _petriDish!.start(notifyChanged: () => setState(() {}));
                    setState(() {
                      _running = true;
                    });
                  },
                  child: const Text('Start'))
        ],
      ),
      body: SizedBox.expand(
          child: CustomPaint(
        painter: CellPainter(cells: _petriDish!.cells, food: _petriDish!.food),
      )),
    );
  }
}
