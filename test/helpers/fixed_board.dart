import 'package:futoshiki_adults/features/game/domain/models/board.dart';
import 'package:futoshiki_adults/features/game/domain/models/cell.dart';
import 'package:futoshiki_adults/features/game/domain/models/constraint.dart';
import 'package:futoshiki_adults/features/game/domain/models/game_state.dart';
import 'package:futoshiki_adults/features/game/domain/repositories/puzzle_repository.dart';

const List<List<int>> kSolution = [
  [1, 2, 3, 4, 5],
  [2, 3, 4, 5, 1],
  [3, 4, 5, 1, 2],
  [4, 5, 1, 2, 3],
  [5, 1, 2, 3, 4],
];

/// Cells left empty for the player; everything else is a given.
const Set<(int, int)> kEmpty = {(0, 0), (0, 1), (1, 0), (1, 1), (2, 2)};

const List<FutoshikiConstraint> kConstraints = [
  // (0,0)=1 < (0,1)=2
  FutoshikiConstraint(row1: 0, col1: 0, row2: 0, col2: 1, isLessThan: true),
  // (0,1)=2 above (1,1)=3 → top smaller
  FutoshikiConstraint(row1: 0, col1: 1, row2: 1, col2: 1, isLessThan: true),
  // (2,2)=5 > (2,3)=1
  FutoshikiConstraint(row1: 2, col1: 2, row2: 2, col2: 3, isLessThan: false),
];

FutoshikiBoard fixedBoard() => FutoshikiBoard(
      cells: List.generate(
        5,
        (r) => List.generate(5, (c) {
          final empty = kEmpty.contains((r, c));
          return FutoshikiCell(
            row: r,
            col: c,
            value: empty ? 0 : kSolution[r][c],
            isFixed: !empty,
          );
        }),
      ),
      solution: kSolution.map((r) => List<int>.from(r)).toList(),
      constraints: kConstraints,
      size: 5,
    );

class FixedPuzzleRepository implements PuzzleRepository {
  @override
  FutoshikiBoard generatePuzzle(int gridSize, Difficulty difficulty) =>
      fixedBoard();
}
