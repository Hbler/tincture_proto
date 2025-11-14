import 'package:flutter/material.dart';
import 'package:tincture_proto/l10n/app_localizations.dart';

/// The four difficulty levels in Tincture Proto.
///
/// * [apprentice] - 6 tiles, 2 points per match
/// * [adept] - 8 tiles, 3 points per match
/// * [alchemist] - 12 tiles, 4 points per match
/// * [artifex] - 36 tiles, 1 point per match (unlocks at 100 points)
enum DifficultyLevel { apprentice, adept, alchemist, artifex }

/// Difficulty configuration defining tile count, points, and sizing.
///
/// Use factory constructors to create instances for each difficulty level.
/// Each level has specific characteristics optimized for gameplay balance.
class Difficulty {
  /// The difficulty level enum value.
  final DifficultyLevel level;

  /// Points awarded per correct match (also deducted per wrong match).
  final int points;

  /// Number of tiles to generate for this difficulty.
  final int elements;

  const Difficulty({
    required this.level,
    required this.points,
    required this.elements,
  });

  /// Creates Apprentice difficulty (6 tiles, 2 points, easiest).
  factory Difficulty.apprentice() =>
      Difficulty(level: DifficultyLevel.apprentice, points: 2, elements: 6);

  /// Creates Adept difficulty (8 tiles, 3 points, medium).
  factory Difficulty.adept() =>
      Difficulty(level: DifficultyLevel.adept, points: 3, elements: 8);

  /// Creates Alchemist difficulty (12 tiles, 4 points, hard).
  factory Difficulty.alchemist() =>
      Difficulty(level: DifficultyLevel.alchemist, points: 4, elements: 12);

  /// Creates Artifex difficulty (36 tiles, 1 point, expert - unlocks at 100 points).
  factory Difficulty.artifex() =>
      Difficulty(level: DifficultyLevel.artifex, points: 1, elements: 36);

  /// Creates a Difficulty instance from a DifficultyLevel enum.
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

  /// Recommended tile size in logical pixels for this difficulty.
  ///
  /// Smaller tiles for higher tile counts to fit on screen.
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

  /// Returns the localized name of this difficulty level.
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
