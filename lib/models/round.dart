import 'package:flutter/material.dart';
import 'package:tincture_proto/l10n/app_localizations.dart';

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

  List<String> getSummary(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      l10n.endOfRound(roundNumber.toString().padLeft(2, '0')),
      l10n.currentScore(totalPoints),
      l10n.pointsWon(pointsWon),
      l10n.pointsLost(pointsLost),
      l10n.timeTaken(getFormattedTime()),
    ];
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
