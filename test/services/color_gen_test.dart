import 'package:flutter_test/flutter_test.dart';
import 'package:tincture_proto/services/color_gen.dart';
import 'package:tincture_proto/models/difficulty.dart';
import 'package:flutter/material.dart';

void main() {
  group('ColorGenerator', () {
    test('generateColors should return the correct number of colors for each difficulty', () {
      final generator = ColorGenerator(mode: ColorMode.prismatic, difficulty: Difficulty.apprentice());
      var colors = generator.generateColors();
      expect(colors.length, 6);

      final generator2 = ColorGenerator(mode: ColorMode.prismatic, difficulty: Difficulty.adept());
      colors = generator2.generateColors();
      expect(colors.length, 8);

      final generator3 = ColorGenerator(mode: ColorMode.prismatic, difficulty: Difficulty.alchemist());
      colors = generator3.generateColors();
      expect(colors.length, 12);

      final generator4 = ColorGenerator(mode: ColorMode.prismatic, difficulty: Difficulty.artifex());
      colors = generator4.generateColors();
      expect(colors.length, 36);
    });

    test('getLighter should return a lighter color', () {
      final color = Colors.blue;
      final lighterColor = ColorGenerator.getLighter(color);
      expect(HSLColor.fromColor(lighterColor).lightness, greaterThan(HSLColor.fromColor(color).lightness));
    });

    test('getDarker should return a darker color', () {
      final color = Colors.blue;
      final darkerColor = ColorGenerator.getDarker(color);
      expect(HSLColor.fromColor(darkerColor).lightness, lessThan(HSLColor.fromColor(color).lightness));
    });
  });
}
