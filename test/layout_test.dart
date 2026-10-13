import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futoshiki_adults/core/theme/app_theme.dart';
import 'package:futoshiki_adults/features/game/data/repositories/puzzle_repository_impl.dart';
import 'package:futoshiki_adults/features/game/domain/models/game_state.dart';
import 'package:futoshiki_adults/features/game/presentation/pages/game_page.dart';
import 'package:futoshiki_adults/features/game/presentation/providers/game_provider.dart';
import 'package:futoshiki_adults/features/game/presentation/widgets/digit_pad.dart';
import 'package:futoshiki_adults/features/game/presentation/widgets/futoshiki_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fixed_board.dart';

const sizes = <Size>[
  Size(320, 568),
  Size(360, 640),
  Size(390, 844),
  Size(600, 700),
  Size(700, 700),
  Size(768, 700),
  Size(900, 700),
  Size(1024, 700),
  Size(1100, 700),
  Size(1280, 700),
  Size(1024, 500),
  Size(844, 390),
  // Short phone height the game must fit without cutting anything off.
  Size(360, 560),
];

enum Variant { playing5, notes5, gaveUp7 }

Future<ProviderContainer> pumpGame(
    WidgetTester tester, Size size, Variant v) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({});

  final container = ProviderContainer(overrides: [
    if (v != Variant.gaveUp7)
      puzzleRepositoryProvider.overrideWithValue(FixedPuzzleRepository())
    else
      puzzleRepositoryProvider.overrideWithValue(PuzzleRepositoryImpl()),
  ]);
  final n = container.read(gameNotifierProvider.notifier);
  await n.startGame(v == Variant.gaveUp7 ? 7 : 5, Difficulty.easy);
  if (v == Variant.notes5) {
    n.setPlaceMode(PlaceMode.pencilMarks);
    n.selectCell(0, 1);
    n.inputDigit(1);
    n.inputDigit(2);
  }
  if (v == Variant.gaveUp7) n.giveUp();

  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      home: const GamePage(),
    ),
  ));
  await tester.pump(const Duration(milliseconds: 500));
  return container;
}

/// Stops the game clock before the test ends (pending-timer check).
Future<void> disposeGame(WidgetTester tester, ProviderContainer c) async {
  await tester.pumpWidget(const SizedBox());
  c.dispose();
}

void expectFits(WidgetTester tester, Size size, {required double minBoard}) {
  expect(tester.takeException(), isNull);
  expect(find.byType(Scrollable), findsNothing,
      reason: 'nothing may scroll inside the game');

  final screen = Offset.zero & size;
  final board = tester.getRect(find.byType(FutoshikiGrid));
  expect(
      screen.contains(board.topLeft) &&
          screen.contains(board.bottomRight - const Offset(0.01, 0.01)),
      isTrue,
      reason: 'board $board must be inside $screen');
  expect(board.width, greaterThanOrEqualTo(minBoard),
      reason: 'board ${board.width.toStringAsFixed(0)}px at $size');

  for (final f in [find.byType(DigitPad), find.byType(ActionRow)]) {
    for (final e in f.evaluate()) {
      final r = tester.getRect(find.byWidget(e.widget));
      expect(r.bottom, lessThanOrEqualTo(size.height + 0.01),
          reason: '${e.widget.runtimeType} cut off at $size: $r');
      expect(r.right, lessThanOrEqualTo(size.width + 0.01));
    }
  }
}

void main() {
  for (final size in sizes) {
    for (final v in Variant.values) {
      testWidgets(
          'mobile ${size.width.toInt()}x${size.height.toInt()} ${v.name}',
          (tester) async {
        final c = await pumpGame(tester, size, v);
        // Mobile keeps its app bar, so the minimum is relaxed by its height.
        expectFits(tester, size, minBoard: 240);
        await disposeGame(tester, c);
      });
    }
  }
}
