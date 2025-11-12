// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Tincture Proto';

  @override
  String get instructions => 'Instruções';

  @override
  String get instructionsColorMode => 'Escolha o modo:';

  @override
  String get instructionsColorModePrismatic =>
      'Prismático (cores aleatórias) ou';

  @override
  String get instructionsColorModeSpectral => 'Espectral (cores parecidas);';

  @override
  String get instructionsDifficulty => 'Escolha a dificuldade:';

  @override
  String get instructionsDifficultyApprentice => 'aprendiz (6 cores),';

  @override
  String get instructionsDifficultyAdept => 'adepto (8 cores),';

  @override
  String get instructionsDifficultyAlchemist => 'alquimista (12 cores)...';

  @override
  String get instructionsStart =>
      'E finalmente inicie um jogo e encontre entre as cores na tela a cor igual a cor principal! As coisas podem ficar... extremas, se você conseguir pontos suficientes.';

  @override
  String get colorMode => 'Escolha o Modo';

  @override
  String get chooseDifficulty => 'Escolha a Dificuldade';

  @override
  String get difficultyApprentice => 'Aprendiz';

  @override
  String get difficultyAdept => 'Adepto';

  @override
  String get difficultyAlchemist => 'Alquimista';

  @override
  String get difficultyArtifex => 'Artífice';

  @override
  String get colorModePrismatic => 'Prismátco';

  @override
  String get colorModeSpectral => 'Espectral';

  @override
  String get startGame => 'Começar Partida';

  @override
  String get newGame => 'Nova Partida';

  @override
  String get nextRound => 'Próxima Rondada';

  @override
  String get resetGame => 'Zerar Partida';

  @override
  String get points => 'Pontos';

  @override
  String get round => 'Rodada';

  @override
  String get roundSummaryTitle => 'Resumo da Rodada:';

  @override
  String endOfRound(String roundNumber) {
    return 'Fim da rodada $roundNumber';
  }

  @override
  String currentScore(int points) {
    return 'Pontuação atual: $points Pontos';
  }

  @override
  String pointsWon(int points) {
    return 'Pontos ganhos: $points';
  }

  @override
  String pointsLost(int points) {
    return 'Pontos perdidos: $points';
  }

  @override
  String timeTaken(String time) {
    return 'Você levou $time pra acabar.';
  }
}
