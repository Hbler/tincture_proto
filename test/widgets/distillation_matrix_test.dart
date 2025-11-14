import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/models/game_state.dart';
import 'package:tincture_proto/widgets/chroma_phial.dart';
import 'package:tincture_proto/widgets/distillation_matrix.dart';

void main() {
  group('DistillationMatrix', () {
    late GameState gameState;

    setUp(() {
      gameState = GameState();
    });

    testWidgets('renders the correct number of ChromaPhial widgets', (WidgetTester tester) async {
      // Set a larger screen size for the test environment
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      // Start the game to generate tiles
      gameState.startGame();

      await tester.pumpWidget(
        ChangeNotifierProvider<GameState>.value(
          value: gameState,
          child: const MaterialApp(
            home: Scaffold(
              body: DistillationMatrix(),
            ),
          ),
        ),
      );

      // The number of tiles is based on the default difficulty (apprentice), which is 6
      expect(find.byType(ChromaPhial), findsNWidgets(6));

      // Reset the screen size after the test
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
