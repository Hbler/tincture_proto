import 'package:flutter/material.dart';
import 'package:tincture_proto/l10n/app_localizations.dart';

enum DifficultyLevel { apprentice, adept, alchemist, artifex }

class Difficulty {
  final DifficultyLevel level;
  final int points;
  final int elements;

  const Difficulty({
    required this.level,
    required this.points,
    required this.elements,
  });

  factory Difficulty.apprentice() =>
      Difficulty(level: DifficultyLevel.apprentice, points: 2, elements: 6);
  factory Difficulty.adept() =>
      Difficulty(level: DifficultyLevel.adept, points: 3, elements: 8);
  factory Difficulty.alchemist() =>
      Difficulty(level: DifficultyLevel.alchemist, points: 4, elements: 12);
  factory Difficulty.artifex() =>
      Difficulty(level: DifficultyLevel.artifex, points: 1, elements: 36);

  factory Difficulty.fromLevel(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.apprentice:
        return Difficulty.apprentice();
      case DifficultyLevel.adept:
        return Difficulty.adept();
      case DifficultyLevel.alchemist:
        return Difficulty.alchemist();
      case DifficultyLevel.artifex:
        return Difficulty.artifex();
    }
  }

  double get tileSize {
    switch (level) {
      case DifficultyLevel.apprentice:
        return 150.0;
      case DifficultyLevel.adept:
        return 130.0;
      case DifficultyLevel.alchemist:
        return 105.0;
      case DifficultyLevel.artifex:
        return 45.0;
    }
  }

  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (level) {
      case DifficultyLevel.apprentice:
        return l10n.difficultyApprentice;
      case DifficultyLevel.adept:
        return l10n.difficultyAdept;
      case DifficultyLevel.alchemist:
        return l10n.difficultyAlchemist;
      case DifficultyLevel.artifex:
        return l10n.difficultyArtifex;
    }
  }
}
