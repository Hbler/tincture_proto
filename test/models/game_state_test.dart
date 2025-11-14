import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tincture_proto/models/difficulty.dart';
import 'package:tincture_proto/models/game_state.dart';

import 'game_state_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  group('GameState', () {
    late GameState gameState;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      gameState = GameState(prefs: mockSharedPreferences);
    });

    test('initial state is correct', () {
      expect(gameState.isGameActive, isFalse);
      expect(gameState.currentRound, 1);
      expect(gameState.roundHistory, isEmpty);
      expect(gameState.currentLocale, isNull);
      expect(gameState.totalPoints, 0);
      expect(gameState.tiles, isEmpty);
    });

    test('setLocale saves locale to shared preferences', () async {
      final locale = Locale('en');
      when(mockSharedPreferences.setString('locale', 'en')).thenAnswer((_) async => true);

      gameState.setLocale(locale);

      expect(gameState.currentLocale, locale);
      verify(mockSharedPreferences.setString('locale', 'en'));
    });

    test('loadSavedLocale loads locale from shared preferences', () async {
      when(mockSharedPreferences.getString('locale')).thenReturn('pt');

      await gameState.loadSavedLocale();

      expect(gameState.currentLocale, Locale('pt'));
      verify(mockSharedPreferences.getString('locale'));
    });

    test('startGame starts the game and generates a new round', () {
      gameState.startGame();

      expect(gameState.isGameActive, isTrue);
      expect(gameState.tiles, isNotEmpty);
      expect(gameState.mainColor, isNotNull);
    });

    test('resetGame resets the game state', () {
      gameState.startGame();
      gameState.resetGame();

      expect(gameState.isGameActive, isFalse);
      expect(gameState.currentRound, 1);
      expect(gameState.roundHistory, isEmpty);
      expect(gameState.totalPoints, 0);
      expect(gameState.tiles, isEmpty);
    });

    test('nextRound increments the round and generates new tiles', () {
      gameState.startGame();
      final initialTiles = gameState.tiles;

      gameState.nextRound();

      expect(gameState.currentRound, 2);
      expect(gameState.tiles, isNotEmpty);
      expect(gameState.tiles, isNot(initialTiles));
    });

    test('onTileTap with correct tile marks it as matched and updates points', () {
      gameState.startGame();
      final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
      final initialPoints = gameState.totalPoints;

      gameState.onTileTap(correctTile.id);

      expect(gameState.tiles.firstWhere((tile) => tile.id == correctTile.id).isMatched, isTrue);
      expect(gameState.totalPoints, greaterThan(initialPoints));
    });

    test('onTileTap with incorrect tile does not mark it as matched and updates points', () {
      gameState.startGame();
      final incorrectTile = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor);
      final initialPoints = gameState.totalPoints;

      gameState.onTileTap(incorrectTile.id);

      expect(gameState.tiles.firstWhere((tile) => tile.id == incorrectTile.id).isMatched, isFalse);
      expect(gameState.totalPoints, lessThanOrEqualTo(initialPoints));
    });

    // Helper function to match N tiles correctly
    void matchCorrectTiles(GameState state, int count) {
      for (int i = 0; i < count; i++) {
        if (state.tiles.every((tile) => tile.isMatched)) {
          state.nextRound();
        }
        final correctTile = state.tiles.firstWhere(
          (tile) => tile.color == state.mainColor && !tile.isMatched
        );
        state.onTileTap(correctTile.id);
      }
    }

    // ARTIFEX UNLOCK LOGIC TESTS
    group('Artifex unlock logic', () {
      test('unlocks at exactly 100 points via correct answer', () {
        // Use alchemist (4 points) to get to 96, then apprentice (2 points) to get to 98, then 100
        gameState.setDifficulty(DifficultyLevel.alchemist);
        gameState.startGame();

        // 24 matches × 4 points = 96 points
        matchCorrectTiles(gameState, 24);
        expect(gameState.totalPoints, 96);

        // Switch to apprentice for fine control
        gameState.setDifficulty(DifficultyLevel.apprentice);
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }

        // One match: 96 + 2 = 98
        matchCorrectTiles(gameState, 1);
        expect(gameState.totalPoints, 98);
        expect(gameState.isArtifexUnlocked, isFalse);

        // One more match: 98 + 2 = 100 (should unlock)
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }
        matchCorrectTiles(gameState, 1);

        expect(gameState.totalPoints, 100);
        expect(gameState.isArtifexUnlocked, isTrue);
      });

      test('unlocks when crossing 100 points threshold', () {
        // Get to 98 points, then add 4 to cross 100
        gameState.setDifficulty(DifficultyLevel.alchemist);
        gameState.startGame();

        // 24 matches × 4 = 96 points
        matchCorrectTiles(gameState, 24);

        // Switch to apprentice for one match: 96 + 2 = 98
        gameState.setDifficulty(DifficultyLevel.apprentice);
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }
        matchCorrectTiles(gameState, 1);
        expect(gameState.totalPoints, 98);
        expect(gameState.isArtifexUnlocked, isFalse);

        // Switch back to alchemist: 98 + 4 = 102 (crosses 100)
        gameState.setDifficulty(DifficultyLevel.alchemist);
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }
        matchCorrectTiles(gameState, 1);

        expect(gameState.totalPoints, 102);
        expect(gameState.isArtifexUnlocked, isTrue);
      });

      test('already unlocked flag persists across rounds', () {
        // Get to 100 points using alchemist + apprentice
        gameState.setDifficulty(DifficultyLevel.alchemist);
        gameState.startGame();

        matchCorrectTiles(gameState, 24); // 96 points

        gameState.setDifficulty(DifficultyLevel.apprentice);
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }
        matchCorrectTiles(gameState, 2); // 96 + 2 + 2 = 100

        expect(gameState.totalPoints, 100);
        expect(gameState.isArtifexUnlocked, isTrue);

        // Play more rounds and verify flag persists
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }
        expect(gameState.isArtifexUnlocked, isTrue);

        gameState.nextRound();
        expect(gameState.isArtifexUnlocked, isTrue);
      });

      test('remains locked below 100 points', () {
        // Get to 98 points and verify it stays locked
        gameState.setDifficulty(DifficultyLevel.alchemist);
        gameState.startGame();

        matchCorrectTiles(gameState, 24); // 96 points

        gameState.setDifficulty(DifficultyLevel.apprentice);
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }
        matchCorrectTiles(gameState, 1); // 96 + 2 = 98

        expect(gameState.totalPoints, 98);
        expect(gameState.isArtifexUnlocked, isFalse);

        // Even after playing more rounds at 98 points
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }
        expect(gameState.isArtifexUnlocked, isFalse);
      });
    });

    // POINTS EDGE CASE TESTS
    group('Points edge cases', () {
      test('points never go below zero', () {
        gameState.setDifficulty(DifficultyLevel.apprentice);
        gameState.startGame();

        // Get 2 points
        final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(correctTile.id);
        expect(gameState.totalPoints, 2);

        // Lose once: 2 - 2 = 0
        final wrongTile1 = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor && !tile.isMatched);
        gameState.onTileTap(wrongTile1.id);
        expect(gameState.totalPoints, 0);

        // Try to go negative
        final wrongTile2 = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor && !tile.isMatched);
        gameState.onTileTap(wrongTile2.id);
        expect(gameState.totalPoints, 0); // Should stay at 0
      });

      test('points at exactly difficulty points value, losing should go to 0', () {
        gameState.setDifficulty(DifficultyLevel.alchemist); // 4 points
        gameState.startGame();

        // Get exactly 4 points
        final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(correctTile.id);
        expect(gameState.totalPoints, 4);

        // Lose once - should go to exactly 0
        final wrongTile = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor && !tile.isMatched);
        gameState.onTileTap(wrongTile.id);
        expect(gameState.totalPoints, 0);
      });

      test('points deduction with insufficient points goes to zero', () {
        // Get 2 points with apprentice
        gameState.setDifficulty(DifficultyLevel.apprentice);
        gameState.startGame();

        final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(correctTile.id);
        expect(gameState.totalPoints, 2);

        // Switch to adept (3 points penalty) and lose
        gameState.setDifficulty(DifficultyLevel.adept);
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }

        final wrongTile = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor && !tile.isMatched);
        gameState.onTileTap(wrongTile.id);

        // Should deduct available 2 points and go to 0 (even though penalty is 3)
        expect(gameState.totalPoints, 0);
      });
    });

    // TAPPING MATCHED TILES TESTS
    group('Tapping matched tiles', () {
      test('tapping already matched tile does nothing', () {
        gameState.startGame();
        final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);

        // Match the tile
        gameState.onTileTap(correctTile.id);
        expect(gameState.tiles.firstWhere((tile) => tile.id == correctTile.id).isMatched, isTrue);

        final matchedCountAfterFirst = gameState.tiles.where((t) => t.isMatched).length;

        // Tap the same tile again
        gameState.onTileTap(correctTile.id);

        // Matched count should not change
        expect(gameState.tiles.where((t) => t.isMatched).length, matchedCountAfterFirst);
      });

      test('points do not change when tapping matched tile', () {
        gameState.startGame();
        final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);

        // Match the tile
        gameState.onTileTap(correctTile.id);
        final pointsAfterMatch = gameState.totalPoints;

        // Tap the matched tile again
        gameState.onTileTap(correctTile.id);

        expect(gameState.totalPoints, pointsAfterMatch);
      });

      test('main color does not update when tapping matched tile', () {
        gameState.startGame();
        final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);

        // Match the tile
        gameState.onTileTap(correctTile.id);
        final mainColorAfterMatch = gameState.mainColor;

        // Tap the matched tile again
        gameState.onTileTap(correctTile.id);

        expect(gameState.mainColor, mainColorAfterMatch);
      });
    });

    // ROUND COMPLETION LOGIC TESTS
    group('Round completion logic', () {
      test('round completes only when all tiles matched', () {
        gameState.startGame();
        final totalTiles = gameState.tiles.length;

        // Match all but one tile
        for (int i = 0; i < totalTiles - 1; i++) {
          final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor && !tile.isMatched);
          gameState.onTileTap(correctTile.id);
        }

        // Round should not be in history yet
        expect(gameState.roundHistory.containsKey(1), isFalse);

        // Match the last tile
        final lastTile = gameState.tiles.firstWhere((tile) => !tile.isMatched);
        gameState.onTileTap(lastTile.id);

        // Now round 1 should be in history
        expect(gameState.roundHistory.containsKey(1), isTrue);
      });

      test('round history saves correctly with proper data', () {
        gameState.setDifficulty(DifficultyLevel.apprentice);
        gameState.startGame();

        // Win one, lose one
        final tile1 = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(tile1.id); // +2

        final wrongTile = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor && !tile.isMatched);
        gameState.onTileTap(wrongTile.id); // -2

        // Complete the round
        while (!gameState.tiles.every((tile) => tile.isMatched)) {
          final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor && !tile.isMatched);
          gameState.onTileTap(correctTile.id);
        }

        final round = gameState.roundHistory[1]!;
        expect(round.roundNumber, 1);
        expect(round.pointsWon, greaterThan(0));
        expect(round.totalPoints, greaterThanOrEqualTo(0));
        expect(round.elapsedTime, isNotNull);
      });

      test('points won and lost per round tracked accurately', () {
        gameState.setDifficulty(DifficultyLevel.adept); // 3 points, 8 tiles
        gameState.startGame();

        // Win one: +3
        final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(correctTile.id);

        // Lose one: -3
        final wrongTile = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor && !tile.isMatched);
        gameState.onTileTap(wrongTile.id);

        // Complete round (will need to match all 8 tiles total)
        while (!gameState.tiles.every((tile) => tile.isMatched)) {
          final tile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor && !tile.isMatched);
          gameState.onTileTap(tile.id);
        }

        final round = gameState.roundHistory[1]!;
        expect(round.pointsWon, 24); // 8 tiles × 3 points - always this for Adept
        expect(round.pointsLost, 3);  // 1 wrong tap × 3 points
        expect(round.totalPoints, 21); // 24 - 3 = 21
      });

      test('elapsed time is calculated and stored', () async {
        gameState.startGame();

        // Wait to ensure time passes
        await Future.delayed(Duration(milliseconds: 100));

        // Complete the round
        while (!gameState.tiles.every((tile) => tile.isMatched)) {
          final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor && !tile.isMatched);
          gameState.onTileTap(correctTile.id);
        }

        final round = gameState.roundHistory[1]!;
        expect(round.elapsedTime.inMilliseconds, greaterThan(0));
      });
    });

    // INVALID/EDGE CASE TESTS
    group('Invalid and edge cases', () {
      test('invalid tile ID tap does nothing', () {
        gameState.startGame();
        final pointsBefore = gameState.totalPoints;
        final tileCountBefore = gameState.tiles.length;

        // Tap with invalid ID
        gameState.onTileTap('invalid-tile-id-12345');

        expect(gameState.totalPoints, pointsBefore);
        expect(gameState.tiles.length, tileCountBefore);
      });

      test('main color only selected from unmatched tiles', () {
        gameState.startGame();

        // Match tiles and verify main color is always from unmatched
        while (gameState.tiles.any((tile) => !tile.isMatched)) {
          final currentMainColor = gameState.mainColor;

          // Main color should match one of the unmatched tiles
          final unmatchedTiles = gameState.tiles.where((tile) => !tile.isMatched);
          final hasMatchingUnmatchedTile = unmatchedTiles.any((tile) =>
            tile.color.r == currentMainColor.r &&
            tile.color.g == currentMainColor.g &&
            tile.color.b == currentMainColor.b
          );

          expect(hasMatchingUnmatchedTile, isTrue);

          // Match the correct tile
          final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor && !tile.isMatched);
          gameState.onTileTap(correctTile.id);
        }
      });

      test('reset game clears all state including Artifex unlock', () {
        // Use alchemist to get to 100 faster
        gameState.setDifficulty(DifficultyLevel.alchemist);
        gameState.startGame();

        matchCorrectTiles(gameState, 24); // 96 points

        gameState.setDifficulty(DifficultyLevel.apprentice);
        if (gameState.tiles.every((tile) => tile.isMatched)) {
          gameState.nextRound();
        }
        matchCorrectTiles(gameState, 2); // 96 + 2 + 2 = 100

        expect(gameState.isArtifexUnlocked, isTrue);
        expect(gameState.totalPoints, 100);

        // Reset the game
        gameState.resetGame();

        expect(gameState.isArtifexUnlocked, isFalse);
        expect(gameState.totalPoints, 0);
        expect(gameState.currentRound, 1);
        expect(gameState.isGameActive, isFalse);
        expect(gameState.tiles, isEmpty);
        expect(gameState.roundHistory, isEmpty);
      });
    });

    // DIFFICULTY-SPECIFIC LOGIC TESTS
    group('Difficulty-specific logic', () {
      test('each difficulty awards correct points', () {
        // Apprentice: 2 points
        gameState.setDifficulty(DifficultyLevel.apprentice);
        gameState.startGame();
        final tile1 = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(tile1.id);
        expect(gameState.totalPoints, 2);
        gameState.resetGame();

        // Adept: 3 points
        gameState.setDifficulty(DifficultyLevel.adept);
        gameState.startGame();
        final tile2 = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(tile2.id);
        expect(gameState.totalPoints, 3);
        gameState.resetGame();

        // Alchemist: 4 points
        gameState.setDifficulty(DifficultyLevel.alchemist);
        gameState.startGame();
        final tile3 = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(tile3.id);
        expect(gameState.totalPoints, 4);
        gameState.resetGame();

        // Artifex: 1 point
        gameState.setDifficulty(DifficultyLevel.artifex);
        gameState.startGame();
        final tile4 = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(tile4.id);
        expect(gameState.totalPoints, 1);
      });

      test('each difficulty deducts correct points on wrong answer', () {
        // Apprentice: -2 points
        gameState.setDifficulty(DifficultyLevel.apprentice);
        gameState.startGame();
        final correct1 = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(correct1.id);
        final wrong1 = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor && !tile.isMatched);
        gameState.onTileTap(wrong1.id);
        expect(gameState.totalPoints, 0); // 2 - 2 = 0
        gameState.resetGame();

        // Adept: -3 points
        gameState.setDifficulty(DifficultyLevel.adept);
        gameState.startGame();
        for (int i = 0; i < 2; i++) {
          final tile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor && !tile.isMatched);
          gameState.onTileTap(tile.id);
        }
        expect(gameState.totalPoints, 6);
        final wrong2 = gameState.tiles.firstWhere((tile) => tile.color != gameState.mainColor && !tile.isMatched);
        gameState.onTileTap(wrong2.id);
        expect(gameState.totalPoints, 3); // 6 - 3 = 3
      });

      test('verify tile counts for all difficulties', () {
        gameState.setDifficulty(DifficultyLevel.apprentice);
        gameState.startGame();
        expect(gameState.tiles.length, 6);
        gameState.resetGame();

        gameState.setDifficulty(DifficultyLevel.adept);
        gameState.startGame();
        expect(gameState.tiles.length, 8);
        gameState.resetGame();

        gameState.setDifficulty(DifficultyLevel.alchemist);
        gameState.startGame();
        expect(gameState.tiles.length, 12);
        gameState.resetGame();

        gameState.setDifficulty(DifficultyLevel.artifex);
        gameState.startGame();
        expect(gameState.tiles.length, 36);
      });
    });

    // STATE TRANSITION TESTS
    group('State transitions', () {
      test('game state transitions correctly: inactive -> active -> reset', () {
        expect(gameState.isGameActive, isFalse);

        gameState.startGame();
        expect(gameState.isGameActive, isTrue);
        expect(gameState.tiles, isNotEmpty);

        gameState.resetGame();
        expect(gameState.isGameActive, isFalse);
        expect(gameState.tiles, isEmpty);
      });

      test('main color, bg color, and ui color update correctly after match', () {
        gameState.startGame();

        // Match a tile
        final correctTile = gameState.tiles.firstWhere((tile) => tile.color == gameState.mainColor);
        gameState.onTileTap(correctTile.id);

        // Colors should be valid (unless all tiles matched)
        if (!gameState.tiles.every((tile) => tile.isMatched)) {
          expect(gameState.mainColor, isNotNull);
          expect(gameState.bgColor, isNotNull);
          expect(gameState.uiColor, isNotNull);

          // Main color should be from remaining unmatched tiles
          final unmatchedTiles = gameState.tiles.where((tile) => !tile.isMatched);
          final hasMatch = unmatchedTiles.any((tile) =>
            tile.color.r == gameState.mainColor.r &&
            tile.color.g == gameState.mainColor.g &&
            tile.color.b == gameState.mainColor.b
          );
          expect(hasMatch, isTrue);
        }
      });
    });
  });
}
