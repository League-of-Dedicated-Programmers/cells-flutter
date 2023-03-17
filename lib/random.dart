import 'dart:math';

extension RandomCellExtensions on Random {
  /// [normalizedDouble]
  ///
  /// returns a random double ranging from -max to max exclusively.
  ///
  /// Usage:
  /// ```dart
  /// final x = Random().normalizedDouble(max: 100);
  /// ```
  double normalizedDouble({double max = 1.0}) {
    return (nextDouble() - 0.5) * 2 * max;
  }
}

// class Random {
//   final _random = math.Random();
//
//   static double normalizedDouble({double? max}) {
//     return (Random().nextDouble() - 0.5) * 2 * (max ?? 1.0);
//   }
// }
