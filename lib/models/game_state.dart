import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tincture_proto/l10n/app_localizations.dart';
import 'package:tincture_proto/models/difficulty.dart';
import 'package:tincture_proto/models/round.dart';
import 'package:tincture_proto/models/tile.dart';
import 'package:tincture_proto/services/color_gen.dart';

/// Manages the complete game state for Tincture Proto.
///
/// This is the central state management class that extends [ChangeNotifier]
/// and is provided via Provider pattern. It handles all game logic including:
/// * Color generation and tile matching
/// * Points tracking and Artifex unlock mechanics
/// * Round progression and history
/// * Language preference persistence
/// * Dynamic UI theming based on current tile colors
///
/// The game state can be injected with [SharedPreferences] for testing.
class GameState extends ChangeNotifier {
  final Random _random = Random();
  final SharedPreferences? _prefs;

  ColorMode _colorMode = ColorMode.spectral;
  DifficultyLevel _difficultyLevel = DifficultyLevel.apprentice;

  Locale? _currentLocale;

  int _totalPoints = 0;
  int _currentRound = 1;
  int _pointsWonThisRound = 0;
  int _pointsLostThisRound = 0;
  bool _isGameActive = false;
  bool _isArtifexUnlocked = false;
  DateTime? _roundStartTime;

  List<GameTile> _tiles = [];
  Color _mainColor = Colors.white;
  Color _bgColor = Colors.white;
  Color _uiColor = Colors.black;

  final Map<int, Round> _roundHistory = {};

  GameState({SharedPreferences? prefs}) : _prefs = prefs;

  /// Current color generation mode (prismatic or spectral).
  ColorMode get colorMode => _colorMode;

  /// Current difficulty level (apprentice, adept, alchemist, or artifex).
  DifficultyLevel get difficultyLevel => _difficultyLevel;

  /// Currently selected language locale, persisted to SharedPreferences.
  Locale? get currentLocale => _currentLocale;

  /// Total accumulated points across all rounds.
  int get totalPoints => _totalPoints;

  /// Current round number, starting at 1.
  int get currentRound => _currentRound;

  /// Whether a game is currently active (tiles generated and playable).
  bool get isGameActive => _isGameActive;

  /// Whether Artifex difficulty has been unlocked (requires 100+ points).
  bool get isArtifexUnlocked => _isArtifexUnlocked;

  /// Unmodifiable list of current game tiles.
  List<GameTile> get tiles => List.unmodifiable(_tiles);

  /// The current lead color that players must match.
  Color get mainColor => _mainColor;

  /// Background color derived from the main color (lighter variant).
  Color get bgColor => _bgColor;

  /// UI accent color derived from the main color (darker variant).
  Color get uiColor => _uiColor;

  /// Unmodifiable map of completed rounds, keyed by round number.
  Map<int, Round> get roundHistory => Map.unmodifiable(_roundHistory);

  /// Sets the color generation mode and notifies listeners.
  ///
  /// [mode] can be either [ColorMode.prismatic] (completely different colors)
  /// or [ColorMode.spectral] (similar hues within a color family).
  void setColorMode(ColorMode mode) {
    _colorMode = mode;
    notifyListeners();
  }

  /// Sets the difficulty level and notifies listeners.
  ///
  /// Note: [DifficultyLevel.artifex] should only be selectable after unlocking
  /// at 100+ points, but this method doesn't enforce that restriction.
  void setDifficulty(DifficultyLevel level) {
    _difficultyLevel = level;
    notifyListeners();
  }

  /// Sets the language locale and persists it to SharedPreferences.
  ///
  /// Setting [locale] to null removes the saved preference and defaults
  /// to system locale. The locale change is saved asynchronously.
  void setLocale(Locale? locale) async {
    _currentLocale = locale;

    final prefs = _prefs ?? await SharedPreferences.getInstance();
    if (locale != null) {
      await prefs.setString('locale', locale.languageCode);
    } else {
      await prefs.remove('locale');
    }

    notifyListeners();
  }

  /// Loads the saved locale preference from SharedPreferences.
  ///
  /// Should be called during app initialization to restore user's language choice.
  /// If no preference is saved, [currentLocale] remains null (system default).
  Future<void> loadSavedLocale() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');

    if (savedLocale != null) {
      _currentLocale = Locale(savedLocale);
      notifyListeners();
    }
  }

  /// Starts a new game by generating the first round and activating the game.
  ///
  /// Generates tiles based on current difficulty and color mode, then selects
  /// a random tile as the lead color to match.
  void startGame() {
    _generateNewRound();
    _isGameActive = true;
    notifyListeners();
  }

  /// Advances to the next round after completing the current one.
  ///
  /// Saves the current round to history, increments the round counter,
  /// and generates new tiles for the next round.
  void nextRound() {
    _finishRound();
    _currentRound++;
    _generateNewRound();
    notifyListeners();
  }

  /// Resets all game state to initial values.
  ///
  /// Clears points, rounds, tiles, history, and Artifex unlock status.
  /// Returns colors to default white/black. Game becomes inactive.
  void resetGame() {
    _totalPoints = 0;
    _currentRound = 1;
    _pointsWonThisRound = 0;
    _pointsLostThisRound = 0;
    _isGameActive = false;
    _isArtifexUnlocked = false;
    _tiles.clear();
    _roundHistory.clear();
    _mainColor = Colors.white;
    _bgColor = Colors.white;
    _uiColor = Colors.black;
    notifyListeners();
  }

  void _generateNewRound() {
    _roundStartTime = DateTime.now();
    _pointsWonThisRound = 0;
    _pointsLostThisRound = 0;

    final difficulty = Difficulty.fromLevel(_difficultyLevel);
    final generator = ColorGenerator(mode: _colorMode, difficulty: difficulty);
    final colors = generator.generateColors();

    _tiles = List.generate(
      colors.length,
      (index) => GameTile(
        id: 'tile-$index',
        color: colors[index],
        difficulty: _difficultyLevel,
      ),
    );

    _updateMainColor();
  }

  void _updateMainColor() {
    final remainingTiles = _tiles.where((tile) => !tile.isMatched).toList();

    if (remainingTiles.isEmpty) {
      _mainColor = Colors.white;
      _bgColor = Colors.white;
      _uiColor = Colors.black;
      return;
    }

    final randomIndex = _random.nextInt(remainingTiles.length);
    final randomTile = remainingTiles[randomIndex];

    _mainColor = randomTile.color;
    _bgColor = ColorGenerator.getLighter(_mainColor);
    _uiColor = ColorGenerator.getDarker(_mainColor);
  }

  /// Handles tile tap events and processes game logic.
  ///
  /// Checks if the tapped tile matches the current [mainColor]. If it matches:
  /// * Marks the tile as matched
  /// * Awards points based on difficulty
  /// * Selects a new main color from remaining tiles
  /// * Completes the round if all tiles are matched
  ///
  /// If it doesn't match:
  /// * Deducts points (capped at current total, never goes negative)
  ///
  /// Invalid tile IDs or already-matched tiles are ignored.
  /// Unlocks Artifex difficulty at 100+ points.
  void onTileTap(String tileId) {
    final tileIndex = _tiles.indexWhere((tile) => tile.id == tileId);
    if (tileIndex == -1 || _tiles[tileIndex].isMatched) return;

    final tappedTile = _tiles[tileIndex];
    final isMatch = _colorsMatch(tappedTile.color, _mainColor);

    if (isMatch) {
      _tiles[tileIndex] = tappedTile.copyWith(isMatched: true);
      _updatePoints(true);
      _updateMainColor();

      if (_isRoundComplete()) {
        _finishRound();
      }
    } else {
      _updatePoints(false);
    }

    notifyListeners();
  }

  bool _colorsMatch(Color color1, Color color2) {
    return color1.r == color2.r && color1.g == color2.g && color1.b == color2.b;
  }

  void _updatePoints(bool isCorrect) {
    final difficulty = Difficulty.fromLevel(_difficultyLevel);

    if (isCorrect) {
      _totalPoints += difficulty.points;
      _pointsWonThisRound += difficulty.points;
    } else {
      final pointsToDeduct = _totalPoints >= difficulty.points
          ? difficulty.points
          : _totalPoints;
      _totalPoints -= pointsToDeduct;
      _pointsLostThisRound += pointsToDeduct;
    }
    if (_totalPoints >= 100 && !_isArtifexUnlocked) {
      _isArtifexUnlocked = true;
    }
  }

  bool _isRoundComplete() {
    return _tiles.every((tile) => tile.isMatched);
  }

  void _finishRound() {
    if (_roundStartTime == null) return;

    final elapsedTime = DateTime.now().difference(_roundStartTime!);
    final round = Round(
      roundNumber: _currentRound,
      totalPoints: _totalPoints,
      pointsLost: _pointsLostThisRound,
      pointsWon: _pointsWonThisRound,
      elapsedTime: elapsedTime,
    );

    _roundHistory[_currentRound] = round;
  }

  /// Returns formatted points string for display (e.g., "042 points").
  ///
  /// Points are zero-padded to 3 digits and localized based on [context].
  String getFormattedPoints(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return '${_totalPoints.toString().padLeft(3, '0')} ${l10n.points}';
  }

  /// Returns formatted round string for display (e.g., "Round 03").
  ///
  /// Round number is zero-padded to 2 digits and localized based on [context].
  String getFormattedRound(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return '${l10n.round} ${_currentRound.toString().padLeft(2, '0')}';
  }
}
