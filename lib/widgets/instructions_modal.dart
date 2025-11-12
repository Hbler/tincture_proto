import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/l10n/app_localizations.dart';
import 'package:tincture_proto/models/game_state.dart';

class InstructionsModal extends StatelessWidget {
  const InstructionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gameState = context.watch<GameState>();

    return Dialog(
      backgroundColor: gameState.uiColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white70, width: 2),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.instructions,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _InstructionSection(
              title: l10n.instructionsColorMode,
              items: [l10n.colorModePrismatic, l10n.colorModeSpectral],
            ),

            const SizedBox(height: 16),

            _InstructionSection(
              title: l10n.instructionsDifficulty,
              items: [
                l10n.instructionsDifficultyApprentice,
                l10n.instructionsDifficultyAdept,
                l10n.instructionsDifficultyAlchemist,
              ],
            ),

            const SizedBox(height: 16),

            _InstructionText(text: l10n.instructionsStart),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _InstructionSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Colors.white70)),
                Expanded(
                  child: Text(item, style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InstructionText extends StatelessWidget {
  final String text;

  const _InstructionText({required this.text});

  @override
  Widget build(BuildContext constex) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, height: 1.5),
    );
  }
}
