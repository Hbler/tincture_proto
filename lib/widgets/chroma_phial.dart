import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/models/difficulty.dart';
import 'package:tincture_proto/models/game_state.dart';
import 'package:tincture_proto/models/tile.dart';

class ChromaPhial extends StatelessWidget {
  final GameTile tile;

  const ChromaPhial({super.key, required this.tile});

  @override
  Widget build(BuildContext context) {
    final gameState = context.read<GameState>();
    final difficulty = Difficulty.fromLevel(tile.difficulty);
    final size = difficulty.tileSize;

    return GestureDetector(
      onTap: tile.isMatched ? null : () => gameState.onTileTap(tile.id),
      child: AnimatedOpacity(
        opacity: tile.isMatched ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              tile.icon,
              style: TextStyle(
                fontSize: size * 1.2,
                color: tile.color,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
