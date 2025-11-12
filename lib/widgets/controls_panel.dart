import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/l10n/app_localizations.dart';
import 'package:tincture_proto/models/difficulty.dart';
import 'package:tincture_proto/models/game_state.dart';
import 'package:tincture_proto/services/color_gen.dart';
import 'package:tincture_proto/widgets/instructions_modal.dart';

class ControlsPanel extends StatelessWidget {
  const ControlsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: gameState.uiColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InstructionsButton(),
          const SizedBox(height: 32),
          _ColorModeSelector(),
          const SizedBox(height: 32),
          _DifficultySelector(),
          const SizedBox(height: 32),
          _ActionButtons(),
          if (gameState.isGameActive) const SizedBox(height: 32),
          if (gameState.isGameActive) _ScoreDisplay(),
        ],
      ),
    );
  }
}

class _InstructionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) => InstructionsModal());
      },
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            l10n.instructions,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OCR_A',
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorModeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gameState = context.watch<GameState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.colorMode,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'OCR_A',
          ),
        ),
        const SizedBox(height: 12),
        _RadioOption(
          label: l10n.colorModePrismatic,
          value: ColorMode.prismatic,
          groupValue: gameState.colorMode,
          onChanged: (value) => gameState.setColorMode(value!),
        ),
        _RadioOption(
          label: l10n.colorModeSpectral,
          value: ColorMode.spectral,
          groupValue: gameState.colorMode,
          onChanged: (value) => gameState.setColorMode(value!),
        ),
      ],
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gameState = context.watch<GameState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chooseDifficulty,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'OCR_A',
          ),
        ),
        const SizedBox(height: 12),
        _RadioOption(
          label: l10n.difficultyApprentice,
          value: DifficultyLevel.apprentice,
          groupValue: gameState.difficultyLevel,
          onChanged: (value) => gameState.setDifficulty(value!),
        ),
        _RadioOption(
          label: l10n.difficultyAdept,
          value: DifficultyLevel.adept,
          groupValue: gameState.difficultyLevel,
          onChanged: (value) => gameState.setDifficulty(value!),
        ),
        _RadioOption(
          label: l10n.difficultyAlchemist,
          value: DifficultyLevel.alchemist,
          groupValue: gameState.difficultyLevel,
          onChanged: (value) => gameState.setDifficulty(value!),
        ),
        if (gameState.isArtifexUnlocked)
          _RadioOption(
            label: l10n.difficultyArtifex,
            value: DifficultyLevel.artifex,
            groupValue: gameState.difficultyLevel,
            onChanged: (value) => gameState.setDifficulty(value!),
          ),
      ],
    );
  }
}

class _RadioOption<T> extends StatelessWidget {
  final String label;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const _RadioOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              fillColor: WidgetStatePropertyAll(Colors.white),
            ),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gameState = context.watch<GameState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!gameState.isGameActive)
          ElevatedButton(
            onPressed: () => gameState.startGame(),
            child: Text(l10n.startGame),
          )
        else
          ElevatedButton(
            onPressed: () => gameState.resetGame(),
            child: Text(l10n.newGame),
          ),
      ],
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            gameState.getFormattedPoints(context),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'OCR_A',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            gameState.getFormattedRound(context),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OCR_A',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
