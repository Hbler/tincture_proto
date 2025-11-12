import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tincture_proto/models/difficulty.dart';

class GameTile {
  final String id;
  final Color color;
  final DifficultyLevel difficulty;
  final String icon;
  bool isMatched;

  static const List<String> _icons = ['▀', '▄', '█', '◼', '▮', '▪'];

  GameTile({
    required this.id,
    required this.color,
    required this.difficulty,
    String? icon,
    this.isMatched = false,
  }) : icon = icon ?? _generateIcon(difficulty);

  static String _generateIcon(DifficultyLevel difficulty) {
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

    return _icons[random.nextInt((maxIndex + 1))];
  }

  GameTile copyWith({
    String? id,
    Color? color,
    DifficultyLevel? difficulty,
    String? icon,
    bool? isMatched,
  }) {
    return GameTile(
      id: id ?? this.id,
      color: color ?? this.color,
      difficulty: difficulty ?? this.difficulty,
      icon: icon ?? this.icon,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  String toString() {
    return 'GameTile(id: $id, color: $color, isMathced: $isMatched)';
  }
}
