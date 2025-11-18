import 'dart:math';

import 'package:flutter/widgets.dart';

enum SigilShape {
  square('SQ'),
  hexagon('HX'),
  octagon('OC'),
  decagon('DC'),
  circle('CR');

  final String code;
  const SigilShape(this.code);
}

enum SigilGrid {
  full('F'),
  block2x2('22'),
  block2x3('23');

  final String code;
  const SigilGrid(this.code);
}

enum Position2x2 {
  topLeft('TL'),
  topRight('TR'),
  bottomLeft('BL'),
  bottomRight('BR'),
  center('C');

  final String code;
  const Position2x2(this.code);
}

enum Position2x3 {
  top('T'),
  right('R'),
  bottom('B'),
  left('L'),
  horizontalCenter('HC'),
  verticalCenter('VC');

  final String code;
  const Position2x3(this.code);
}

class ColorSigil {
  final SigilShape shape;
  final SigilGrid grid;
  final String? position;

  const ColorSigil({required this.shape, required this.grid, this.position});

  String get assetPath {
    final shapePart = shape.code;
    final gridPart = grid.code;

    if (grid == SigilGrid.full) {
      return 'icons/${shapePart}_$gridPart.svg';
    } else {
      if (position == null) {
        throw StateError('Position required for grid type: ${grid.code}');
      }
      return 'icons/${shapePart}_${gridPart}_$position.svg';
    }
  }

  @override
  String toString() =>
      'ColorSigil(${shape.code}_${grid.code}${position != null ? '_$position' : ''})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorSigil &&
          shape == other.shape &&
          grid == other.grid &&
          position == other.position;

  @override
  int get hashCode => Object.hash(shape, grid, position);
}

class SigilFactory {
  final Random _random = Random();

  ColorSigil createRandom({SigilShape? shape, SigilGrid? grid}) {
    final selectedShape = shape ?? _randomShape();
    final selectedGrid = grid ?? _randomGrid();

    String? position;
    if (selectedGrid == SigilGrid.block2x2) {
      position = _randomPosition2x2().code;
    } else if (selectedGrid == SigilGrid.block2x3) {
      position = _randomPosition2x3().code;
    }

    final sigil = ColorSigil(
      shape: selectedShape,
      grid: selectedGrid,
      position: position,
    );

    debugPrint('Generated sigil: $sigil');

    return sigil;
  }

  ColorSigil createRandomWithShapeLimit(int maxShapeIndex) {
    final availableShapes = SigilShape.values.take(maxShapeIndex + 1).toList();
    final selectedShape =
        availableShapes[_random.nextInt(availableShapes.length)];

    return createRandom(shape: selectedShape);
  }

  ColorSigil createSpecific({
    required SigilShape shape,
    required SigilGrid grid,
    String? position,
  }) {
    return ColorSigil(shape: shape, grid: grid, position: position);
  }

  List<ColorSigil> createUniqueBatch(int count, {int? maxShapeIndex}) {
    final Set<ColorSigil> sigils = {};
    int attempts = 0;
    final maxAttempts = count * 100;

    while (sigils.length < count && attempts < maxAttempts) {
      final sigil = maxShapeIndex != null
          ? createRandomWithShapeLimit(maxShapeIndex)
          : createRandom();

      sigils.add(sigil);
      attempts++;
    }

    if (sigils.length < count) {
      throw StateError(
        'Could not generate $count unique sigils. '
        'Only ${sigils.length} unique combinations available with current constraints.',
      );
    }

    return sigils.toList();
  }

  SigilShape _randomShape() {
    return SigilShape.values[_random.nextInt(SigilShape.values.length)];
  }

  SigilGrid _randomGrid() {
    return SigilGrid.values[_random.nextInt(SigilGrid.values.length)];
  }

  Position2x2 _randomPosition2x2() {
    return Position2x2.values[_random.nextInt(Position2x2.values.length)];
  }

  Position2x3 _randomPosition2x3() {
    return Position2x3.values[_random.nextInt(Position2x3.values.length)];
  }
}

extension DifficultyGridLimit on SigilFactory {
  ColorSigil createForDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'apprentice':
        return createRandom(grid: SigilGrid.full);
      case 'adept':
        return createRandom(grid: SigilGrid.block2x3);
      case 'alchemist':
        final allowedGrids = [SigilGrid.block2x2, SigilGrid.block2x3];
        final selectedGrid = allowedGrids[_random.nextInt(allowedGrids.length)];
        return createRandom(grid: selectedGrid);
      case 'artifex':
        return createRandom(grid: SigilGrid.full);
      default:
        throw ArgumentError('Unknown difficutly: $difficulty');
    }
  }
}
