import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/l10n/app_localizations.dart';
import 'package:tincture_proto/models/game_state.dart';

class RoundSummaryOverlay extends StatelessWidget {
  const RoundSummaryOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gameState = context.watch<GameState>();

    final currentRound = gameState.roundHistory[gameState.currentRound];

    if (currentRound == null) return const SizedBox.shrink();

    final summary = currentRound.getSummary(context);

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: gameState.uiColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.roundSummaryTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              ...summary.map(
                (line) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    line,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => gameState.nextRound(),
                    label: Text(l10n.nextRound),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => gameState.resetGame(),
                    label: Text(l10n.resetGame),
                    icon: const Icon(Icons.refresh),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
