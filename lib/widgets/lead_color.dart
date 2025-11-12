import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/models/game_state.dart';

class LeadColor extends StatelessWidget {
  const LeadColor({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 860;

    final icon = isMobile ? '━' : '✦';
    final fontSize = isMobile ? 100.0 : 280.0;

    return Center(
      child: Text(
        icon,
        style: TextStyle(
          fontSize: fontSize,
          color: gameState.mainColor,
          height: 1.0,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
