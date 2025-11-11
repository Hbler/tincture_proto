// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tincture Proto';

  @override
  String get instructions => 'Instructions';

  @override
  String get instructionsColorMode => 'Choose the color mode:';

  @override
  String get instructionsColorModePrismatic => 'prismatic (aleatory colors) or';

  @override
  String get instructionsColorModeSpectral => 'spectral (similar colors);';

  @override
  String get instructionsDifficulty => 'Choose the difficulty:';

  @override
  String get instructionsDifficultyApprentice => 'apprentice (6 tiles),';

  @override
  String get instructionsDifficultyAdept => 'adept (8 tiles),';

  @override
  String get instructionsDifficultyAlchemist => 'alchemist (12 tiles)...';

  @override
  String get instructionsStart =>
      'And finally start a game and find, among the tiles on the board, the color that matches the main one! Things might get a bit... extreme, if you get enough points';

  @override
  String get colorMode => 'Color Mode';

  @override
  String get chooseDifficulty => 'Choose Difficulty';

  @override
  String get difficultyApprentice => 'Apprentice';

  @override
  String get difficultyAdept => 'Adept';

  @override
  String get difficultyAlchemist => 'Alchemist';

  @override
  String get difficultyArtifex => 'Artifex';

  @override
  String get colorModePrismatic => 'Prismatic';

  @override
  String get colorModeSpectral => 'Spectral';

  @override
  String get startGame => 'Start Game';

  @override
  String get newGame => 'New Game';

  @override
  String get nextRound => 'Next Round';

  @override
  String get resetGame => 'Reset Game';

  @override
  String get points => 'Points';

  @override
  String get round => 'Round';

  @override
  String get roundSummaryTitle => 'Round Summary:';

  @override
  String endOfRound(String roundNumber) {
    return 'End of Round $roundNumber';
  }

  @override
  String currentScore(int points) {
    return 'Current Score: $points Points';
  }

  @override
  String pointsWon(int points) {
    return 'Points Won: $points';
  }

  @override
  String pointsLost(int points) {
    return 'Points Lost: $points';
  }

  @override
  String timeTaken(String time) {
    return 'You took $time to finish it.';
  }
}
