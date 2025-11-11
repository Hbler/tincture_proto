class Round {
  final int roundNumber;
  final int totalPoints;
  final int pointsWon;
  final int pointsLost;
  final Duration elapsedTime;

  Round({
    required this.roundNumber,
    required this.totalPoints,
    required this.pointsWon,
    required this.pointsLost,
    required this.elapsedTime,
  });

  String getFormattedTime() {
    if (elapsedTime.inMilliseconds > 60000) {
      final minutes = elapsedTime.inMilliseconds / 60000;
      return '${minutes.toStringAsFixed(2)} m';
    } else {
      final seconds = elapsedTime.inMilliseconds / 1000;
      return '${seconds.toStringAsFixed(2)} s';
    }
  }

  List<String> getSummary() {
    return [
      'End of Round ${roundNumber.toString().padLeft(2, '0')}',
      'Current Score: $totalPoints Points',
      'Points Won: $pointsWon',
      'Points Lost: $pointsLost'
          'You took ${getFormattedTime()} to finish it.',
    ];
  }

  List<String> getResumo() {
    return [
      'Fim do round ${roundNumber.toString().padLeft(2, '0')}',
      'Pontuação atual: $totalPoints Points',
      'Pontos ganhos: $pointsWon',
      'Pontos perdidos: $pointsLost'
          'Você levou ${getFormattedTime()} pra acabar.',
    ];
  }

  List<String> getLocalizedSummary(String locale) {
    return locale == 'pt' ? getResumo() : getSummary();
  }

  @override
  String toString() {
    return 'Round $roundNumber: $totalPoints pts (won: $pointsWon, lost: $pointsLost, duration: $elapsedTime)';
  }

  Round copyWith({
    int? roundNumber,
    int? totalPoints,
    int? pointsWon,
    int? pointsLost,
    Duration? elapsedTime,
  }) {
    return Round(
      roundNumber: roundNumber ?? this.roundNumber,
      totalPoints: totalPoints ?? this.totalPoints,
      pointsWon: pointsWon ?? this.pointsWon,
      pointsLost: pointsLost ?? this.pointsLost,
      elapsedTime: elapsedTime ?? this.elapsedTime,
    );
  }
}
