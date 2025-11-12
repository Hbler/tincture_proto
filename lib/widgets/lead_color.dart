import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/models/game_state.dart';

class LeadColor extends StatelessWidget {
  const LeadColor({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile =
            constraints.maxWidth < 860 || constraints.maxHeight < 200;
        final icon = isMobile ? '-' : '*';

        return Center(
          child: Text(
            icon,
            style: TextStyle(
              fontSize: isMobile ? 80 : 370,
              color: gameState.mainColor,
              height: 1.0,
            ),
          ),
        );
      },
    );
  }
}
