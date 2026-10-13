import 'dart:math';
import '../models/board.dart';
import '../models/cell.dart';
import '../models/constraint.dart';
import '../models/game_state.dart';

class FutoshikiGenerator {
  final _rng = Random();

  /// Generation runs on the UI thread (web has no isolates), so clue removal
  /// is time-boxed. When the budget runs out the remaining clues stay; the
  /// puzzle is still guaranteed to have exactly one solution.
  static const Duration removalBudget = Duration(milliseconds: 300);

  /// Search-node cap for a single uniqueness check. Hitting it counts as
  /// "not proven unique", so the clue is kept.
  static const int _maxNodesPerCheck = 200000;
  int _nodes = 0;

  FutoshikiBoard generate(int gridSize, Difficulty difficulty) {
    assert(gridSize == 5 || gridSize == 6 || gridSize == 7);
    final sol = _generateLatinSquare(gridSize, _rng);
    final constraints = _generateConstraints(sol, gridSize, difficulty, _rng);
    return _createPuzzle(sol, constraints, gridSize, difficulty, _rng);
  }

  // ── Step 1: Latin square ──────────────────────────────────────────────────

  List<List<int>> _generateLatinSquare(int n, Random rng) {
    final grid = List.generate(n, (_) => List.filled(n, 0));
    _fillLatinSquare(grid, n, rng);
    return grid;
  }

  bool _fillLatinSquare(List<List<int>> grid, int n, Random rng) {
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if (grid[r][c] != 0) continue;
        final digits = List.generate(n, (i) => i + 1)..shuffle(rng);
        for (final d in digits) {
          if (_isLegalLatinPlace(grid, n, r, c, d)) {
            grid[r][c] = d;
            if (_fillLatinSquare(grid, n, rng)) return true;
            grid[r][c] = 0;
          }
        }
        return false;
      }
    }
    return true;
  }

  bool _isLegalLatinPlace(List<List<int>> grid, int n, int row, int col, int d) {
    for (int c = 0; c < n; c++) {
      if (c != col && grid[row][c] == d) return false;
    }
    for (int r = 0; r < n; r++) {
      if (r != row && grid[r][col] == d) return false;
    }
    return true;
  }

  // ── Step 2: Constraint selection ─────────────────────────────────────────

  int _targetConstraintCount(int n, Difficulty difficulty) {
    final base = n == 5 ? 10 : (n == 6 ? 14 : 18);
    return switch (difficulty) {
      Difficulty.easy || Difficulty.medium => base,
      Difficulty.advanced => base + 4,
      Difficulty.expert => base + 7,
      Difficulty.insane => base + 11,
    };
  }

  List<FutoshikiConstraint> _generateConstraints(
      List<List<int>> sol, int n, Difficulty difficulty, Random rng) {
    final pairs = <List<int>>[];

    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n - 1; c++) {
        pairs.add([r, c, r, c + 1]);
      }
    }
    for (int r = 0; r < n - 1; r++) {
      for (int c = 0; c < n; c++) {
        pairs.add([r, c, r + 1, c]);
      }
    }

    pairs.shuffle(rng);

    final targetCount = _targetConstraintCount(n, difficulty);
    final selected = pairs.take(targetCount);

    return selected.map((p) {
      final r1 = p[0], c1 = p[1], r2 = p[2], c2 = p[3];
      return FutoshikiConstraint(
        row1: r1,
        col1: c1,
        row2: r2,
        col2: c2,
        isLessThan: sol[r1][c1] < sol[r2][c2],
      );
    }).toList();
  }

  // ── Step 3: Puzzle creation (digit removal) ───────────────────────────────

  FutoshikiBoard _createPuzzle(
    List<List<int>> sol,
    List<FutoshikiConstraint> constraints,
    int n,
    Difficulty difficulty,
    Random rng,
  ) {
    final targetGivens = switch (difficulty) {
      Difficulty.easy     => (n * n * 0.55).ceil(),
      Difficulty.medium   => (n * n * 0.38).ceil(),
      Difficulty.advanced => (n * n * 0.28).ceil(),
      Difficulty.expert   => (n * n * 0.20).ceil(),
      Difficulty.insane   => (n * n * 0.12).ceil(),
    };

    // Working copy of solution; 0 = removed
    final grid = List.generate(n, (r) => List<int>.from(sol[r]));

    final positions = List.generate(n * n, (i) => i)..shuffle(rng);
    int givens = n * n;
    final clock = Stopwatch()..start();

    for (final pos in positions) {
      if (givens <= targetGivens) break;
      if (clock.elapsed > removalBudget) break;
      final r = pos ~/ n;
      final c = pos % n;
      final saved = grid[r][c];
      grid[r][c] = 0;

      _nodes = 0;
      final count = _countSolutions(grid, constraints, n, 2);
      if (count == 1) {
        givens--;
      } else {
        grid[r][c] = saved;
      }
    }

    final cells = List.generate(
      n,
      (r) => List.generate(n, (c) {
        return FutoshikiCell(
          row: r,
          col: c,
          value: grid[r][c],
          isFixed: grid[r][c] != 0,
        );
      }),
    );

    return FutoshikiBoard(
      cells: cells,
      solution: sol,
      constraints: constraints,
      size: n,
    );
  }

  // ── Uniqueness solver ─────────────────────────────────────────────────────

  int _countSolutions(
    List<List<int>> grid,
    List<FutoshikiConstraint> constraints,
    int n,
    int maxCount,
  ) {
    // Find first empty cell in row-major order
    int emptyRow = -1, emptyCol = -1;
    outer:
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if (grid[r][c] == 0) {
          emptyRow = r;
          emptyCol = c;
          break outer;
        }
      }
    }

    if (emptyRow == -1) return 1; // complete assignment
    if (++_nodes > _maxNodesPerCheck) return maxCount; // give up: keep clue

    int count = 0;
    for (int d = 1; d <= n; d++) {
      if (_isLegalSolverPlace(grid, constraints, n, emptyRow, emptyCol, d)) {
        grid[emptyRow][emptyCol] = d;
        count += _countSolutions(grid, constraints, n, maxCount - count);
        grid[emptyRow][emptyCol] = 0;
        if (count >= maxCount) return count;
      }
    }
    return count;
  }

  bool _isLegalSolverPlace(
    List<List<int>> grid,
    List<FutoshikiConstraint> constraints,
    int n,
    int row,
    int col,
    int d,
  ) {
    for (int c = 0; c < n; c++) {
      if (c != col && grid[row][c] == d) return false;
    }
    for (int r = 0; r < n; r++) {
      if (r != row && grid[r][col] == d) return false;
    }
    for (final con in constraints) {
      final involves = (con.row1 == row && con.col1 == col) ||
          (con.row2 == row && con.col2 == col);
      if (!involves) continue;

      final val1 = (con.row1 == row && con.col1 == col)
          ? d
          : grid[con.row1][con.col1];
      final val2 = (con.row2 == row && con.col2 == col)
          ? d
          : grid[con.row2][con.col2];

      if (val1 == 0 || val2 == 0) continue;

      if (con.isLessThan && val1 >= val2) return false;
      if (!con.isLessThan && val1 <= val2) return false;
    }
    return true;
  }
}
