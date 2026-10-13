import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futoshiki_adults/features/game/domain/models/game_state.dart';
import 'package:futoshiki_adults/features/game/presentation/providers/game_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fixed_board.dart';

void main() {
  late ProviderContainer container;
  GameNotifier notifier() => container.read(gameNotifierProvider.notifier);
  GameState state() => container.read(gameNotifierProvider);
  int value(int r, int c) => state().board!.cells[r][c].value;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(overrides: [
      puzzleRepositoryProvider.overrideWithValue(FixedPuzzleRepository()),
    ]);
    await notifier().startGame(5, Difficulty.easy);
  });

  tearDown(() => container.dispose());

  test('starts playing with a fresh state', () {
    expect(state().status, GameStatus.playing);
    expect(state().mistakes, 0);
    expect(state().elapsedSeconds, 0);
    expect(state().placeMode, PlaceMode.solution);
  });

  test('givens cannot be selected', () {
    notifier().selectCell(4, 4);
    expect(state().selectedRow, isNull);
  });

  test('correct digit is placed without a mistake', () {
    notifier().selectCell(0, 0);
    notifier().inputDigit(1);
    expect(value(0, 0), 1);
    expect(state().mistakes, 0);
  });

  test('digit that breaks a rule counts a mistake', () {
    // Row 0 already holds 3 at (0,2) → repeated digit.
    notifier().selectCell(0, 0);
    notifier().inputDigit(3);
    expect(value(0, 0), 3);
    expect(state().mistakes, 1);
  });

  test('wrong but rule-consistent digit does not reveal itself', () {
    // 2 at (0,0) repeats nothing (column 0 has (1,0) empty) and the
    // (0,0) < (0,1) inequality is open, but the answer is 1.
    notifier().selectCell(0, 0);
    notifier().inputDigit(2);
    expect(value(0, 0), 2);
    expect(state().mistakes, 0);
  });

  test('erase clears a player cell', () {
    notifier().selectCell(0, 0);
    notifier().inputDigit(1);
    notifier().eraseCell();
    expect(value(0, 0), 0);
  });

  test('pencil marks toggle and are auto-removed by a placed digit', () {
    notifier().setPlaceMode(PlaceMode.pencilMarks);
    notifier().selectCell(0, 1);
    notifier().inputDigit(2);
    notifier().inputDigit(4);
    notifier().inputDigit(4);
    expect(state().board!.cells[0][1].pencilMarks, [2]);
    notifier().setPlaceMode(PlaceMode.solution);
    notifier().selectCell(0, 0);
    notifier().inputDigit(2); // same row → removes the 2 mark at (0,1)
    expect(state().board!.cells[0][1].pencilMarks, isEmpty);
  });

  test('hint fills the selected cell with the solution', () {
    notifier().selectCell(1, 1);
    notifier().useHint();
    expect(value(1, 1), 3);
    expect(state().board!.cells[1][1].isFixed, isTrue);
    expect(state().mistakes, 0);
  });

  test('filling every cell correctly wins', () {
    for (final (r, c) in kEmpty) {
      notifier().selectCell(r, c);
      notifier().inputDigit(kSolution[r][c]);
    }
    expect(state().status, GameStatus.won);
  });

  test('give up reveals the solution', () {
    notifier().giveUp();
    expect(state().status, GameStatus.gaveUp);
    for (final (r, c) in kEmpty) {
      expect(value(r, c), kSolution[r][c]);
    }
  });

  test('reset restores the starting board and clears mistakes', () {
    notifier().selectCell(0, 0);
    notifier().inputDigit(3);
    notifier().resetPuzzle();
    expect(value(0, 0), 0);
    expect(state().mistakes, 0);
    expect(state().status, GameStatus.playing);
  });

  test('save then load restores the board', () async {
    notifier().selectCell(0, 0);
    notifier().inputDigit(1);
    await notifier().saveGame();
    await notifier().startGame(5, Difficulty.easy);
    expect(value(0, 0), 0);
    expect(await notifier().loadSavedGame(), isTrue);
    expect(value(0, 0), 1);
  });
}
