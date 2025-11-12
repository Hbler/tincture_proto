import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/models/game_state.dart';
import 'package:tincture_proto/models/tile.dart';
import 'package:tincture_proto/widgets/chroma_phial.dart';
import 'package:tincture_proto/widgets/lead_color.dart';

class DistillationMatrix extends StatelessWidget {
  const DistillationMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 860;

        if (isMobile) {
          return _MobileMatrix(gameState: gameState);
        } else {
          return _DesktopMatrix(gameState: gameState);
        }
      },
    );
  }
}

class _DesktopMatrix extends StatelessWidget {
  final GameState gameState;

  const _DesktopMatrix({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(flex: 30, child: LeadColor()),

        const SizedBox(width: 24),

        Flexible(flex: 70, child: _TilesGrid(gameState: gameState)),
      ],
    );
  }
}

class _MobileMatrix extends StatelessWidget {
  final GameState gameState;

  const _MobileMatrix({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100, child: LeadColor()),

        const SizedBox(width: 24),

        _TilesGrid(gameState: gameState),
      ],
    );
  }
}

class _TilesGrid extends StatelessWidget {
  final GameState gameState;

  const _TilesGrid({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Selector<GameState, List<GameTile>>(
      selector: (_, gameState) => gameState.tiles,
      builder: (context, tiles, _) {
        if (tiles.isEmpty) {
          return const Center(
            child: Text(
              '...',
              style: TextStyle(fontSize: 48, color: Colors.black26),
            ),
          );
        }

        final crossAxisCount = _getCrossAxisCount(tiles.length);

        return Center(
          child: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                return ChromaPhial(
                  key: ValueKey(tiles[index].id),
                  tile: tiles[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

int _getCrossAxisCount(int tileCount) {
  if (tileCount <= 6) return 3;
  if (tileCount <= 8) return 4;
  if (tileCount <= 12) return 4;
  return 6;
}
