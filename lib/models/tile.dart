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
    'assets/icons/CR_F.svg',
    'assets/icons/DC_F.svg',
    'assets/icons/HX_F.svg',
    'assets/icons/OC_F.svg',
    'assets/icons/SQ_F.svg',
  ];

  GameTile({
    required this.id,
    required this.color,
    required this.difficulty,
    String? iconPath,
    this.isMatched = false,
  }) : iconPath = iconPath ?? _getRandomIconPath();

  static String _getRandomIconPath() {
    final random = Random();
    final maxIndex = 4;

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
