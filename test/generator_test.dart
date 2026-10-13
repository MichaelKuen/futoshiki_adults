import 'package:flutter_test/flutter_test.dart';
import 'package:futoshiki_adults/features/game/domain/logic/futoshiki_generator.dart';
import 'package:futoshiki_adults/features/game/domain/models/board.dart';
import 'package:futoshiki_adults/features/game/domain/models/game_state.dart';

/// Independent brute-force solution counter (stops at [limit]).
int _countSolutions(FutoshikiBoard b, {int limit = 2}) {
  final n = b.size;
  final g = [
    for (final row in b.cells) [for (final c in row) c.value],
  ];
  bool ok(int r, int c, int d) {
    for (int i = 0; i < n; i++) {
      if (i != c && g[r][i] == d) return false;
      if (i != r && g[i][c] == d) return false;
    }
    for (final k in b.constraints) {
      final a = (k.row1 == r && k.col1 == c) ? d : g[k.row1][k.col1];
      final z = (k.row2 == r && k.col2 == c) ? d : g[k.row2][k.col2];
      if (a == 0 || z == 0) continue;
      if (k.isLessThan ? a >= z : a <= z) return false;
    }
    return true;
  }

  int solve(int pos) {
    if (pos == n * n) return 1;
    final r = pos ~/ n, c = pos % n;
    if (g[r][c] != 0) return solve(pos + 1);
    int count = 0;
    for (int d = 1; d <= n && count < limit; d++) {
      if (ok(r, c, d)) {
        g[r][c] = d;
        count += solve(pos + 1);
        g[r][c] = 0;
      }
    }
    return count;
  }

  return solve(0);
}

void main() {
  final gen = FutoshikiGenerator();

  for (final n in [5, 6, 7]) {
    for (final d in Difficulty.values) {
      test('${n}x$n ${d.name}: valid and uniquely solvable', () {
        final b = gen.generate(n, d);
        expect(b.size, n);
        // Solution is a Latin square.
        for (int i = 0; i < n; i++) {
          expect(b.solution[i].toSet().length, n);
          expect({for (int r = 0; r < n; r++) b.solution[r][i]}.length, n);
        }
        // Constraints agree with the solution.
        for (final k in b.constraints) {
          final a = b.solution[k.row1][k.col1];
          final z = b.solution[k.row2][k.col2];
          expect(k.isLessThan, a < z);
        }
        // Givens match the solution; non-givens are empty.
        for (final row in b.cells) {
          for (final c in row) {
            if (c.isFixed) {
              expect(c.value, b.solution[c.row][c.col]);
            } else {
              expect(c.value, 0);
            }
          }
        }
        expect(_countSolutions(b), 1);
      });
    }
  }
}
