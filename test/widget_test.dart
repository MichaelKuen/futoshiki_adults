import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futoshiki_adults/features/game/presentation/providers/game_provider.dart';
import 'package:futoshiki_adults/features/game/presentation/widgets/digit_pad.dart';
import 'package:futoshiki_adults/features/game/presentation/widgets/futoshiki_grid.dart';
import 'package:futoshiki_adults/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fixed_board.dart';

/// Mobile flow (VM tests run with kIsWeb == false).
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(overrides: [
      puzzleRepositoryProvider.overrideWithValue(FixedPuzzleRepository()),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const FutoshikiApp(),
    ));
    await tester.pump(const Duration(seconds: 1));
    return container;
  }

  testWidgets('home shows title and difficulty choices', (tester) async {
    await pumpApp(tester);
    expect(find.text('Futoshiki for Adults'), findsWidgets);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Insane'), findsOneWidget);
  });

  testWidgets('home → game → win → play again returns home', (tester) async {
    final container = await pumpApp(tester);
    await tester.tap(find.text('Easy'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(FutoshikiGrid), findsOneWidget);
    expect(find.byType(DigitPad), findsOneWidget);

    final n = container.read(gameNotifierProvider.notifier);
    for (final (r, c) in kEmpty) {
      n.selectCell(r, c);
      n.inputDigit(kSolution[r][c]);
    }
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('You solved the Futoshiki!'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(FutoshikiGrid), findsNothing);
    expect(find.text('Easy'), findsOneWidget);
  });
}
