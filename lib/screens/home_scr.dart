import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/models/game_state.dart';
import 'package:tincture_proto/widgets/controls_panel.dart';
import 'package:tincture_proto/widgets/distillation_matrix.dart';
import 'package:tincture_proto/widgets/language_selector.dart';
import 'package:tincture_proto/widgets/round_summary.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'T',
              style: TextStyle(
                fontFamily: 'Optima',
                color: gameState.bgColor,
                fontSize: 28,
              ),
            ),
            Text(
              'incture',
              style: TextStyle(
                fontFamily: 'Optima',
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: gameState.bgColor,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: LanguageSelector(),
                ),
              ),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 860) {
                      return _DesktopLayout();
                    } else {
                      return _MobileLayout();
                    }
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerRight,
                child: Text(
                  'by Hugo Bler',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (gameState.isGameActive && _shouldShowRoundSummary(gameState))
            const RoundSummaryOverlay(),
        ],
      ),
    );
  }

  bool _shouldShowRoundSummary(GameState gameState) {
    return gameState.tiles.isNotEmpty &&
        gameState.tiles.every((tile) => tile.isMatched);
  }
}

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Flexible(flex: 23, child: ControlsPanel()),

          const SizedBox(width: 24),

          const Flexible(flex: 75, child: DistillationMatrix()),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ControlsPanel(),

            const SizedBox(width: 24),

            const DistillationMatrix(),
          ],
        ),
      ),
    );
  }
}
