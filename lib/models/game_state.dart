import 'package:flutter/material.dart';
import 'package:tincture_proto/models/difficulty.dart';
import 'package:tincture_proto/models/round.dart';
import 'package:tincture_proto/models/tile.dart';
import 'package:tincture_proto/services/color_gen.dart';

class GameState extends ChangeNotifier {
  ColorMode _colorMode = ColorMode.spectral;
  DifficultyLevel _difficultyLevel = DifficultyLevel.apprentice;
  String _locale = 'en';

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

  ColorMode get colorMode => _colorMode;
  DifficultyLevel get difficultyLeve => _difficultyLevel;
  String get locale => _locale;
  int get totalPoints => _totalPoints;
  int get currentRound => _currentRound;
  bool get isGameActive => _isGameActive;
  bool get isArtifexUnlocked => _isArtifexUnlocked;
  List<GameTile> get tiles => List.unmodifiable(_tiles);
  Color get mainColor => _mainColor;
  Color get bgColor => _bgColor;
  Color get uiColor => _uiColor;
  Map<int, Round> get roundHistory => Map.unmodifiable(_roundHistory);

  void setColorMode(ColorMode mode) {
    _colorMode = mode;
    notifyListeners();
  }

  void setDifficulty(DifficultyLevel level) {
    _difficultyLevel = level;
    notifyListeners();
  }

  void setLocale(String locale) {
    _locale = locale;
    notifyListeners();
  }

  void startGame() {
    _generateNewRound();
    _isGameActive = true;
    notifyListeners();
  }

  void nextRound() {
    _finishRound();
    _currentRound++;
    _generateNewRound();
    notifyListeners();
  }

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

    final randomTile =
        remainingTiles[DateTime.now().microsecond % remainingTiles.length];
    _mainColor = randomTile.color;
    _bgColor = ColorGenerator.getLighter(_mainColor);
    _uiColor = ColorGenerator.getDarker(_mainColor);
  }

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
    return (color1.r - color2.r).abs() <= 1 &&
        (color1.g - color2.g).abs() <= 1 &&
        (color1.b - color2.b).abs() <= 1;
  }

  void _updatePoints(bool isCorrect) {
    final difficulty = Difficulty.fromLevel(_difficultyLevel);

    if (isCorrect) {
      _totalPoints += difficulty.points;
      _pointsWonThisRound += difficulty.points;
    } else {
      if (_totalPoints >= difficulty.points) {
        _totalPoints -= difficulty.points;
        _pointsLostThisRound += difficulty.points;
      }

      if (_totalPoints >= 100 && !_isArtifexUnlocked) {
        _isArtifexUnlocked = true;
      }
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

  String getFormattedPoints() {
    final pointWord = _locale == 'pt' ? 'Pontos' : 'Points';
    return '${_totalPoints.toString().padLeft(3, '0')} $pointWord';
  }

  String getFormattedRound() {
    final roundWord = _locale == 'pt' ? 'Rodada' : 'Round';
    return '$roundWord ${_currentRound.toString().padLeft(2, '0')}';
  }
}
