import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tincture_proto/models/difficulty.dart';

/// Color generation modes for tile generation.
///
/// * [prismatic] - Completely different colors across entire spectrum
/// * [spectral] - Similar hues within a single color family
enum ColorMode { prismatic, spectral }

/// Generates colors for game tiles using HSL color space.
///
/// Supports two generation modes:
/// * **Prismatic**: Random colors across full hue spectrum (0-360°)
/// * **Spectral**: Colors within a single hue family (red, yellow, green, etc.)
///
/// All colors have controlled saturation (20-100%) and lightness (40-60%)
/// to ensure visibility and sufficient difficulty for matching.
///
/// Example:
/// ```dart
/// final generator = ColorGenerator(
///   mode: ColorMode.spectral,
///   difficulty: Difficulty.apprentice(),
/// );
/// final colors = generator.generateColors(); // Returns 6 colors
/// ```
class ColorGenerator {
  /// The color generation mode (prismatic or spectral).
  final ColorMode mode;

  /// The difficulty level determining number of colors to generate.
  final Difficulty difficulty;

  final Random _random = Random();

  /// Hue ranges (in degrees) for spectral color families.
  static const Map<String, List<int>> _hueRanges = {
    'red': [10, 50],
    'yellow': [70, 110],
    'green': [130, 170],
    'cyan': [190, 230],
    'blue': [250, 290],
    'magenta': [310, 350],
  };

  ColorGenerator({required this.mode, required this.difficulty});

  /// Generates a list of colors based on the current mode and difficulty.
  ///
  /// Returns a list with length equal to [difficulty.elements].
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

  /// Creates a lighter variant of the given color.
  ///
  /// Sets lightness to 90% in HSL color space, useful for backgrounds.
  static Color getLighter(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(0.9).toColor();
  }

  /// Creates a darker variant of the given color.
  ///
  /// Sets lightness to 25% in HSL color space, useful for UI accents.
  static Color getDarker(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(0.25).toColor();
  }
}
