import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futoshiki_adults/core/platform.dart';
import 'package:futoshiki_adults/features/game/domain/models/game_state.dart';
import 'package:futoshiki_adults/features/game/presentation/providers/game_provider.dart';
import 'package:futoshiki_adults/features/game/presentation/widgets/futoshiki_grid.dart';
import 'package:futoshiki_adults/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fixed_board.dart';

/// Web flow with isWebEmbed forced on: straight into a game, no Home page,
/// and every "play again" path starts a new game instead of popping.
void main() {
  setUp(() {
    isWebEmbed = true;
    SharedPreferences.setMockInitialValues({});
  });
  tearDown(() => isWebEmbed = false);

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(overrides: [
      puzzleRepositoryProvider.overrideWithValue(FixedPuzzleRepository()),
    ]);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const FutoshikiApp(),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    return container;
  }

  Future<void> finish(WidgetTester tester, ProviderContainer c) async {
    await tester.pumpWidget(const SizedBox());
    c.dispose();
  }

  Future<void> startFromDialog(WidgetTester tester) async {
    expect(find.text('Level'), findsOneWidget);
    await tester.tap(find.text('Expert'));
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('opens straight into a game with no app bar', (tester) async {
    final c = await pumpApp(tester);
    expect(find.byType(AppBar), findsNothing);
    expect(find.text('Choose your level:'), findsNothing);
    expect(find.byType(FutoshikiGrid), findsOneWidget);
    expect(c.read(gameNotifierProvider).status, GameStatus.playing);
    expect(c.read(gameNotifierProvider).difficulty, Difficulty.medium);
    await finish(tester, c);
  });

  testWidgets('win → New Game dialog → new game, never a blank screen',
      (tester) async {
    final c = await pumpApp(tester);
    final n = c.read(gameNotifierProvider.notifier);
    for (final (r, col) in kEmpty) {
      n.selectCell(r, col);
      n.inputDigit(kSolution[r][col]);
    }
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('You solved the Futoshiki!'), findsOneWidget);

    await tester.tap(find.text('New Game'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await startFromDialog(tester);

    expect(find.byType(FutoshikiGrid), findsOneWidget);
    expect(c.read(gameNotifierProvider).status, GameStatus.playing);
    expect(c.read(gameNotifierProvider).difficulty, Difficulty.expert);
    await finish(tester, c);
  });

  testWidgets('show solution → New Game starts a new game', (tester) async {
    final c = await pumpApp(tester);
    c.read(gameNotifierProvider.notifier).giveUp();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('New Game'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await startFromDialog(tester);
    expect(find.byType(FutoshikiGrid), findsOneWidget);
    expect(c.read(gameNotifierProvider).status, GameStatus.playing);
    await finish(tester, c);
  });

  testWidgets('keyboard: arrows, digits, numpad, erase; works after a click',
      (tester) async {
    final c = await pumpApp(tester);
    int value(int r, int col) =>
        c.read(gameNotifierProvider).board!.cells[r][col].value;

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(c.read(gameNotifierProvider).selectedRow, 0);
    expect(c.read(gameNotifierProvider).selectedCol, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    expect(value(0, 0), 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    expect(value(0, 0), 0);

    // Click a button, then keys must still reach the game.
    await tester.tap(find.text('Notes'));
    await tester.pump();
    await tester.tap(find.text('Notes'));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.numpad1);
    expect(value(0, 0), 1);

    // Digits above the grid size are ignored.
    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit7);
    expect(value(0, 0), 0);

    // Keys are ignored while a dialog is open.
    await tester.tap(find.text('New'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    expect(value(0, 0), 0);
    await finish(tester, c);
  });

  testWidgets('Notes button toggles pencil-mark mode', (tester) async {
    final c = await pumpApp(tester);
    await tester.tap(find.text('Notes'));
    await tester.pump();
    expect(c.read(gameNotifierProvider).placeMode, PlaceMode.pencilMarks);
    expect(find.text('Notes on'), findsOneWidget);
    await tester.tap(find.text('Notes'));
    await tester.pump();
    expect(c.read(gameNotifierProvider).placeMode, PlaceMode.solution);
    await finish(tester, c);
  });
}
