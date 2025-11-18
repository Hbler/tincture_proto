import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/models/difficulty.dart';
import 'package:tincture_proto/models/game_state.dart';
import 'package:tincture_proto/models/tile.dart';
import 'package:tincture_proto/services/feedback.dart';

class ChromaPhial extends StatefulWidget {
  final GameTile tile;

  const ChromaPhial({super.key, required this.tile});

  @override
  State<ChromaPhial> createState() => _ChromaPhialState();
}

class _ChromaPhialState extends State<ChromaPhial>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _showError = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (widget.tile.isMatched) return;

    final gameState = context.read<GameState>();
    final feedbackService = FeedbackService();

    gameState.onTileTap(widget.tile.id);

    final currentTile = gameState.tiles.firstWhere(
      (t) => t.id == widget.tile.id,
    );

    if (currentTile.isMatched) {
      feedbackService.onCorrectMatch();
    } else {
      feedbackService.onWrongMatch();

      setState(() => _showError = true);
      _shakeController.forward(from: 0.0);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _showError = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final difficulty = Difficulty.fromLevel(widget.tile.difficulty);
    final size = difficulty.tileSize;

    if (widget.tile.isMatched) {
      return SizedBox(width: size, height: size);
    }

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedOpacity(
          opacity: widget.tile.isMatched ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: _showError
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: _showError
                  ? Border.all(color: Colors.red, width: 2)
                  : null,
            ),
            child: Center(
              child: SvgPicture.asset(
                widget.tile.iconPath,
                width: size * 0.9,
                height: size * 0.9,
                colorFilter: ColorFilter.mode(
                  widget.tile.color,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
