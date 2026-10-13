import 'package:flutter_test/flutter_test.dart';
import 'package:futoshiki_adults/features/game/domain/logic/futoshiki_engine.dart';
import 'package:futoshiki_adults/features/game/domain/models/board.dart';

import 'helpers/fixed_board.dart';

FutoshikiBoard _withValue(FutoshikiBoard b, int r, int c, int v) {
  final cells = [
    for (final row in b.cells) [...row],
  ];
  cells[r][c] = cells[r][c].copyWith(value: v);
  return b.copyWith(cells: cells);
}

void main() {
  final engine = FutoshikiEngine();

  test('empty cells produce no errors', () {
    final b = fixedBoard();
    expect(engine.computeRowColErrors(b), isEmpty);
    expect(engine.computeConstraintErrors(b), isEmpty);
    expect(engine.computeWrongMoveErrors(b), isEmpty);
  });

  test('row duplicate flags both cells', () {
    // Row 0 already holds 3 at (0,2).
    final b = _withValue(fixedBoard(), 0, 0, 3);
    expect(engine.computeRowColErrors(b), containsAll(['0,0', '0,2']));
  });

  test('broken inequality flags both cells', () {
    // (0,0) < (0,1): put 5 then 4 → broken.
    var b = _withValue(fixedBoard(), 0, 0, 5);
    b = _withValue(b, 0, 1, 4);
    expect(engine.computeConstraintErrors(b), {'0,0', '0,1'});
  });

  test('wrong move compares against the stored solution', () {
    final b = _withValue(fixedBoard(), 2, 2, 4);
    expect(engine.computeWrongMoveErrors(b), {'2,2'});
    final ok = _withValue(fixedBoard(), 2, 2, 5);
    expect(engine.computeWrongMoveErrors(ok), isEmpty);
  });

  test('constraint lookup by position', () {
    final b = fixedBoard();
    expect(engine.hConstraint(b, 0, 0)?.isLessThan, isTrue);
    expect(engine.vConstraint(b, 0, 1)?.isLessThan, isTrue);
    expect(engine.hConstraint(b, 2, 2)?.isLessThan, isFalse);
    expect(engine.hConstraint(b, 4, 0), isNull);
  });
}
