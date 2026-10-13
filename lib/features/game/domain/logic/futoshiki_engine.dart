import 'package:collection/collection.dart';
import '../models/board.dart';
import '../models/constraint.dart';

class FutoshikiEngine {
  /// Returns error keys for row and column duplicate violations only.
  Set<String> computeRowColErrors(FutoshikiBoard board) {
    final n = board.size;
    final errors = <String>{};

    for (int r = 0; r < n; r++) {
      final seen = <int, int>{};
      for (int c = 0; c < n; c++) {
        final v = board.cells[r][c].value;
        if (v == 0) continue;
        if (seen.containsKey(v)) {
          errors.add('$r,${seen[v]}');
          errors.add('$r,$c');
        } else {
          seen[v] = c;
        }
      }
    }

    for (int c = 0; c < n; c++) {
      final seen = <int, int>{};
      for (int r = 0; r < n; r++) {
        final v = board.cells[r][c].value;
        if (v == 0) continue;
        if (seen.containsKey(v)) {
          errors.add('${seen[v]},$c');
          errors.add('$r,$c');
        } else {
          seen[v] = r;
        }
      }
    }

    return errors;
  }

  /// Returns error keys for constraint violations only.
  Set<String> computeConstraintErrors(FutoshikiBoard board) {
    final errors = <String>{};

    for (final con in board.constraints) {
      final v1 = board.cells[con.row1][con.col1].value;
      final v2 = board.cells[con.row2][con.col2].value;
      if (v1 == 0 || v2 == 0) continue;
      final violated = con.isLessThan ? v1 >= v2 : v1 <= v2;
      if (violated) {
        errors.add('${con.row1},${con.col1}');
        errors.add('${con.row2},${con.col2}');
      }
    }

    return errors;
  }

  /// Returns error keys for cells whose value doesn't match the stored solution.
  /// Fixed and revealed cells are skipped (they are always correct by construction).
  Set<String> computeWrongMoveErrors(FutoshikiBoard board) {
    final errors = <String>{};
    for (int r = 0; r < board.size; r++) {
      for (int c = 0; c < board.size; c++) {
        final cell = board.cells[r][c];
        if (cell.value == 0 || cell.isFixed || cell.isRevealed) continue;
        if (cell.value != board.solution[r][c]) {
          errors.add('$r,$c');
        }
      }
    }
    return errors;
  }

  /// Find the horizontal constraint between (row, col) and (row, col+1), if any.
  FutoshikiConstraint? hConstraint(FutoshikiBoard board, int row, int col) =>
      board.constraints.firstWhereOrNull(
        (c) =>
            c.row1 == row &&
            c.col1 == col &&
            c.row2 == row &&
            c.col2 == col + 1,
      );

  /// Find the vertical constraint between (row, col) and (row+1, col), if any.
  FutoshikiConstraint? vConstraint(FutoshikiBoard board, int row, int col) =>
      board.constraints.firstWhereOrNull(
        (c) =>
            c.row1 == row &&
            c.col1 == col &&
            c.row2 == row + 1 &&
            c.col2 == col,
      );
}
