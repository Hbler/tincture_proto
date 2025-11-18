import 'package:flutter/material.dart';
import 'package:tincture_proto/models/color_sigil.dart';
import 'package:tincture_proto/models/difficulty.dart';

class GameTile {
  final String id;
  final Color color;
  final DifficultyLevel difficulty;
  final ColorSigil sigil;
  bool isMatched;

  GameTile({
    required this.id,
    required this.color,
    required this.difficulty,
    ColorSigil? sigil,
    this.isMatched = false,
  }) : sigil = sigil ?? _generateSigil(difficulty);

  String get iconPath => sigil.assetPath;

  static ColorSigil _generateSigil(DifficultyLevel difficulty) {
    final factory = SigilFactory();

    switch (difficulty) {
      case DifficultyLevel.apprentice:
        return factory.createForDifficulty('apprentice');
      case DifficultyLevel.adept:
        return factory.createForDifficulty('adept');
      case DifficultyLevel.alchemist:
        return factory.createForDifficulty('alchemist');
      case DifficultyLevel.artifex:
        return factory.createForDifficulty('artifex');
    }
  }

  GameTile copyWith({
    String? id,
    Color? color,
    DifficultyLevel? difficulty,
    ColorSigil? sigil,
    bool? isMatched,
  }) {
    return GameTile(
      id: id ?? this.id,
      color: color ?? this.color,
      difficulty: difficulty ?? this.difficulty,
      sigil: sigil ?? this.sigil,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  String toString() {
    return 'GameTile(id: $id, color: $color, isMathced: $isMatched)';
  }
}
