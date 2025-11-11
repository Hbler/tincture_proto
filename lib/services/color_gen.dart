import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tincture_proto/models/difficulty.dart';

enum ColorMode { prismatic, spectral }

class ColorGenerator {
  final ColorMode mode;
  final Difficulty difficulty;
  final Random _random = Random();

  static const Map<String, List<int>> _hueRanges = {
    'red': [10, 50],
    'yellow': [70, 110],
    'green': [130, 170],
    'cyan': [190, 230],
    'blue': [250, 290],
    'magenta': [310, 350],
  };

  ColorGenerator({required this.mode, required this.difficulty});

  List<Color> generateColors() {
    final amount = difficulty.elements;

    if (mode == ColorMode.prismatic) {
      return _generatePrismaticColors(amount);
    } else {
      return _generateSpectralColors(amount);
    }
  }

  List<Color> _generatePrismaticColors(int amount) {
    final colors = <Color>[];

    for (int i = 0; i < amount; i++) {
      final h = _random.nextInt(361);
      final s = _random.nextInt(81) + 20;
      final l = _random.nextInt(21) + 40;

      colors.add(
        HSLColor.fromAHSL(1.0, h.toDouble(), s / 100, l / 100).toColor(),
      );
    }

    return colors;
  }

  List<Color> _generateSpectralColors(int amount) {
    final colors = <Color>[];

    final hueKeys = _hueRanges.keys.toList();
    final selectedHue = hueKeys[_random.nextInt(hueKeys.length)];
    final hueRange = _hueRanges[selectedHue]!;

    for (int i = 0; i < amount; i++) {
      final h = _random.nextInt(hueRange[1] - hueRange[0] + 1) + hueRange[0];
      final s = _random.nextInt(81) + 20;
      final l = _random.nextInt(21) + 40;

      colors.add(
        HSLColor.fromAHSL(1.0, h.toDouble(), s / 100, l / 100).toColor(),
      );
    }

    return colors;
  }

  static Color getLighter(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(0.9).toColor();
  }

  static Color getDarker(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(0.25).toColor();
  }
}
