import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tincture_proto/models/difficulty.dart';

class GameTile {
  final String id;
  final Color color;
  final DifficultyLevel difficulty;
  final String iconPath;
  bool isMatched;

  static const List<String> _iconPaths = [
    'assets/icons/flask.svg',
    'assets/icons/vial.svg',
    'assets/icons/beaker.svg',
    'assets/icons/crucible.svg',
    'assets/icons/mortar.svg',
    'assets/icons/alembic.svg',
  ];

  GameTile({
    required this.id,
    required this.color,
    required this.difficulty,
    String? iconPath,
    this.isMatched = false,
  }) : iconPath = iconPath ?? _generateIconPath(difficulty);

  static String _generateIconPath(DifficultyLevel difficulty) {
    final random = Random();
    int maxIndex;

    switch (difficulty) {
      case DifficultyLevel.apprentice:
        maxIndex = 5;
        break;
      case DifficultyLevel.adept:
        maxIndex = 4;
        break;
      case DifficultyLevel.alchemist:
        maxIndex = 3;
        break;
      case DifficultyLevel.artifex:
        maxIndex = 2;
        break;
    }

    return _iconPaths[random.nextInt((maxIndex + 1))];
  }

  GameTile copyWith({
    String? id,
    Color? color,
    DifficultyLevel? difficulty,
    String? iconPath,
    bool? isMatched,
  }) {
    return GameTile(
      id: id ?? this.id,
      color: color ?? this.color,
      difficulty: difficulty ?? this.difficulty,
      iconPath: iconPath ?? this.iconPath,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  String toString() {
    return 'GameTile(id: $id, color: $color, isMathced: $isMatched)';
  }
}
