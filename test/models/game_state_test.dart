import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  });
}
