# Futoshiki for Kids — Flutter Build Prompt

> **How to use this file**
> You are in a brand-new Flutter project created via Android Studio.
> Paste each **Phase** into the terminal Claude (claude.ai/code or the IDE assistant)
> one at a time. Wait for Claude to finish and confirm success before pasting the next.
> Do **not** skip phases — each one builds on the last.
> After Claude confirms success for a phase, run the **Git commands** at the bottom of
> that phase before moving to the next one.

---

## What we are building

A **children's Futoshiki app** in Flutter/Dart with these non-negotiable requirements:

- **Variable grid size** — default 5×5 (digits 1–5); a settings page lets the player
  switch to 6×6 (digits 1–6) or 7×7 (digits 1–7). The engine and generator handle all
  three sizes identically.
- **What is Futoshiki?** — A Japanese logic puzzle whose name means "inequality".
  Fill the N×N grid so that every row and every column contains each digit from 1 to N
  exactly once. Between some pairs of adjacent cells, inequality signs (< >) show which
  of the two cells must hold the larger digit.
- **Zero advertisements** — no AdMob, no ad SDK, no revenue packages of any kind.
- **Mandatory screen breaks** — after every 10 minutes of play the game pauses and
  shows a friendly full-screen break reminder that the child must actively dismiss.
- **Child-safe visuals** — bright pastel colours, large tap targets, rounded shapes,
  encouraging language only, no dark themes, no violent or adult imagery.
- **Unlimited hints** — children should never feel stuck.
- **No mistake limit** — wrong answers show gentle feedback but never end the game.
- **No notes/pencil mode** — kept simple for young players.
- **State management:** flutter_riverpod + riverpod_annotation (code generation).
- **Immutable models:** freezed + freezed_annotation.
- **Animations:** flutter_animate for in-game feedback; confetti package for win.
- **Font:** Google Fonts — Nunito (rounded, friendly, highly legible for children).
- **Settings persistence:** shared_preferences (grid size selection survives restarts).

---

## Futoshiki Rules (read carefully — the generator depends on this)

1. The grid is N×N where N is 5, 6, or 7 depending on the player's settings.
2. Every **row** must contain each digit from 1 to N exactly once.
3. Every **column** must contain each digit from 1 to N exactly once.
4. **Inequality constraints** are shown between some pairs of adjacent cells:
   - A horizontal `<` or `>` appears between two cells in the same row.
   - A vertical `∧` or `∨` appears between two cells in the same column
     (open side of the symbol always faces the **larger** digit).
5. All constraints must be satisfied in the completed puzzle.
6. Some cells are **pre-filled** as starting hints (givens, shown in bold).
7. A valid puzzle has **exactly one solution**.

### Symbol convention (teach the child)
- `3 < 5` → the cell with 3 is to the LEFT of `<`; the cell with 5 is to the RIGHT.
- `∨` between two rows means the TOP cell is **smaller** than the BOTTOM cell.
- `∧` between two rows means the TOP cell is **larger** than the BOTTOM cell.
- The open mouth of `<`, `>`, `∧`, `∨` always faces the bigger number.

---

## KNOWN FLUTTER/DART GOTCHAS — apply to every file

1. **Dot-shorthand syntax** — avoid `.center`, `.fromSeed()` etc. Write full class names
   (`MainAxisAlignment.center`, `ColorScheme.fromSeed(...)`). The build_runner analyser
   only understands up to Dart 3.9 and will error on dot-shorthands.
2. **`Ref` import** — import `Ref` from `flutter_riverpod`, NOT from `riverpod_annotation`.
   Add: `import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;`
3. **`withOpacity` deprecated** — use `.withValues(alpha: 0.xx)` (Flutter 3.27+).
4. **`discarded_futures` lint** — wrap unawaited `Future<void>` calls with `unawaited()`
   from `dart:async`, or make the callback async and check `context.mounted`.
5. **`Spacer` in `SingleChildScrollView`** — crashes (unbounded parent). Use `SizedBox(height: N)`.
6. **Disabled ElevatedButton colour** — set `disabledBackgroundColor` in `styleFrom` to keep
   the pastel colour when `onPressed: null`.
7. **build_runner after every freezed/riverpod change** —
   `dart run build_runner build --delete-conflicting-outputs`
8. **`firstWhereOrNull`** — requires `import 'package:collection/collection.dart'`.
   Add `collection: ^1.18.0` to dependencies in pubspec.yaml.

---

## Git Setup — before Phase 1

Run these commands once in the project root after Android Studio creates the project.
Replace `<remote-url>` with your actual GitHub/GitLab/Bitbucket repository URL.

```
git init
git add .
git commit -m "Initial Flutter project scaffold"
git remote add origin <remote-url>
git push -u origin master
git checkout -b phase-01-setup
```

---

## PHASE 1 — Project Setup

**Goal: initialise the Flutter project and install all dependencies.**

```
We are building a children's Futoshiki puzzle app from scratch.
The app name is futoshiki_for_kids.

Step 1: This Flutter project was just created by Android Studio.
Replace the entire contents of pubspec.yaml with the following:

name: futoshiki_for_kids
description: "A fun, child-friendly Futoshiki inequality puzzle game."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.3.5
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.2
  confetti: ^0.7.0
  collection: ^1.18.0
  shared_preferences: ^2.3.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.15
  freezed: ^2.5.7
  json_serializable: ^6.9.0
  riverpod_generator: ^2.6.4

flutter:
  uses-material-design: true

Step 2: Run:  flutter pub get

Step 3: Create this exact folder structure inside lib/ (create empty placeholder
.dart files so the folders exist — we will fill them in later phases):

lib/
  core/
    theme/
      app_theme.dart
  features/
    game/
      data/
        repositories/
          puzzle_repository_impl.dart
      domain/
        logic/
          futoshiki_engine.dart
          futoshiki_generator.dart
        models/
          cell.dart
          constraint.dart
          board.dart
          game_state.dart
        repositories/
          puzzle_repository.dart
      presentation/
        pages/
          break_page.dart
          game_page.dart
        providers/
          game_provider.dart
          settings_provider.dart
        widgets/
          futoshiki_grid.dart
          digit_pad.dart
    home/
      presentation/
        pages/
          home_page.dart
          privacy_policy_page.dart
    settings/
      presentation/
        pages/
          settings_page.dart
  main.dart

Confirm the folder structure exists and that flutter pub get succeeded.
Do not write any real Dart code yet.
```

### Git — End of Phase 1
```
git add .
git commit -m "Phase 1: project setup — pubspec, folder structure"
git push origin phase-01-setup
git checkout master
git pull origin master
git merge phase-01-setup
git push origin master
git checkout -b phase-02-models
```

---

## PHASE 2 — Domain Models

**Goal: create all immutable data models using freezed.**

```
Implement the domain models for Futoshiki for Kids.
Use freezed for immutability. Run build_runner after all files are written.

IMPORTANT GOTCHAS TO APPLY IN EVERY FILE:
- Use .withValues(alpha: x) NOT .withOpacity(x)
- Import Ref from flutter_riverpod, not riverpod_annotation
- Avoid dot-shorthand syntax (write full class names)
- After any freezed/riverpod file, run:
    dart run build_runner build --delete-conflicting-outputs

=== lib/features/game/domain/models/cell.dart ===

Create a @freezed class FutoshikiCell with these fields:
  required int row
  required int col

  --- Player interaction fields ---
  @Default(0) int value           — 0 = empty; 1..N = digit the player entered
  @Default(false) bool isFixed    — true for given starting digits (cannot be erased)
  @Default(false) bool isSelected
  @Default(false) bool isHighlighted  — in the same row or column as the selected cell
  @Default(false) bool isSameDigit    — same non-zero value as the selected cell
  @Default(false) bool isError        — value violates a row/column/constraint rule

Include the freezed part directive and json_serializable fromJson factory.

=== lib/features/game/domain/models/constraint.dart ===

Create a @freezed class FutoshikiConstraint with:
  required int row1        — row of the first cell (always the top or left cell)
  required int col1        — col of the first cell
  required int row2        — row of the second cell (always the bottom or right cell)
  required int col2        — col of the second cell
  required bool isLessThan — true  → cells[row1][col1] < cells[row2][col2]
                             false → cells[row1][col1] > cells[row2][col2]

Add a helper getter:
  bool get isHorizontal => row1 == row2   (horizontal constraint, same row)
  bool get isVertical   => col1 == col2   (vertical constraint, same column)

Include the freezed part directive and json_serializable fromJson factory.

=== lib/features/game/domain/models/board.dart ===

Create a @freezed class FutoshikiBoard with:
  required List<List<FutoshikiCell>> cells   — [row][col], size n×n
  required List<List<int>> solution          — [row][col], digit 1..N; the unique answer
  required List<FutoshikiConstraint> constraints
  required int size                          — N (5, 6, or 7)

Add const FutoshikiBoard._() to allow methods.

Add these methods:
  FutoshikiCell getCell(int row, int col) => cells[row][col];
  int getSolution(int row, int col)       => solution[row][col];

  bool get isComplete:
    Every cell has value != 0 AND no cell has isError == true.

=== lib/features/game/domain/models/game_state.dart ===

Create enums:
  enum GameStatus { initial, loading, playing, won, breakTime }
  enum Difficulty { easy, medium }

Create a @freezed class GameState with:
  FutoshikiBoard? board
  @Default(GameStatus.initial) GameStatus status
  @Default(Difficulty.easy) Difficulty difficulty
  @Default(5) int gridSize               — current puzzle grid size (5, 6, or 7)
  @Default(0) int elapsedSeconds
  @Default(0) int playSecondsThisSegment
  @Default(0) int mistakes
  int? selectedRow
  int? selectedCol

After writing all four files, run:
  dart run build_runner build --delete-conflicting-outputs

Fix any errors before moving on. Confirm build_runner succeeded with no errors.
```

### Git — End of Phase 2
```
git add .
git commit -m "Phase 2: domain models — cell, constraint, board, game_state (freezed)"
git push origin phase-02-models
git checkout master
git pull origin master
git merge phase-02-models
git push origin master
git checkout -b phase-03-engine
```

---

## PHASE 3 — Futoshiki Engine (Rules Validator)

**Goal: implement the rules validation engine (size-agnostic).**

```
Implement the Futoshiki rules engine.
No build_runner needed — no annotations in this file.

IMPORTANT GOTCHAS:
- Avoid dot-shorthand syntax
- Import collection for firstWhereOrNull

=== lib/features/game/domain/logic/futoshiki_engine.dart ===

import 'package:collection/collection.dart';

class FutoshikiEngine {

  /// Returns true if placing [digit] at (row, col) is immediately legal:
  ///   - digit not already present in the same row (among filled cells)
  ///   - digit not already present in the same column (among filled cells)
  ///   - no constraint involving (row, col) is immediately violated
  ///     (a constraint is only checked when BOTH cells in it are filled)
  bool canPlace(FutoshikiBoard board, int row, int col, int digit) {
    final n = board.size;

    // Row check
    for (int c = 0; c < n; c++) {
      if (c == col) continue;
      if (board.cells[row][c].value == digit) return false;
    }

    // Column check
    for (int r = 0; r < n; r++) {
      if (r == row) continue;
      if (board.cells[r][col].value == digit) return false;
    }

    // Constraint check — only when both cells are filled
    for (final con in board.constraints) {
      final involves = (con.row1 == row && con.col1 == col) ||
                       (con.row2 == row && con.col2 == col);
      if (!involves) continue;

      int val1 = (con.row1 == row && con.col1 == col)
          ? digit
          : board.cells[con.row1][con.col1].value;
      int val2 = (con.row2 == row && con.col2 == col)
          ? digit
          : board.cells[con.row2][con.col2].value;

      if (val1 == 0 || val2 == 0) continue; // other cell not yet filled

      if (con.isLessThan && val1 >= val2) return false;
      if (!con.isLessThan && val1 <= val2) return false;
    }

    return true;
  }

  /// Compute which cells currently have errors, returning a Set<String> of
  /// "$row,$col" keys for every cell that violates a rule.
  ///
  /// A cell (r,c) is in error if:
  ///   - Its value appears elsewhere in the same row or column.
  ///   - A constraint involving it is violated (both cells are filled).
  Set<String> computeErrors(FutoshikiBoard board) {
    final n = board.size;
    final errors = <String>{};

    // Row duplicates
    for (int r = 0; r < n; r++) {
      final seen = <int, int>{}; // digit → col
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

    // Column duplicates
    for (int c = 0; c < n; c++) {
      final seen = <int, int>{}; // digit → row
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

    // Constraint violations
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

  /// Find the horizontal constraint between (row, col) and (row, col+1), if any.
  FutoshikiConstraint? hConstraint(FutoshikiBoard board, int row, int col) =>
      board.constraints.firstWhereOrNull(
        (c) => c.row1 == row && c.col1 == col &&
               c.row2 == row && c.col2 == col + 1,
      );

  /// Find the vertical constraint between (row, col) and (row+1, col), if any.
  FutoshikiConstraint? vConstraint(FutoshikiBoard board, int row, int col) =>
      board.constraints.firstWhereOrNull(
        (c) => c.row1 == row && c.col1 == col &&
               c.row2 == row + 1 && c.col2 == col,
      );
}

Run flutter analyze on this file. Fix all issues before continuing.
```

### Git — End of Phase 3
```
git add .
git commit -m "Phase 3: FutoshikiEngine — row/col/constraint validator"
git push origin phase-03-engine
git checkout master
git pull origin master
git merge phase-03-engine
git push origin master
git checkout -b phase-04-generator
```

---

## PHASE 4 — Futoshiki Generator

**Goal: generate valid, uniquely-solvable Futoshiki puzzles for any supported grid size.**

```
Implement the Futoshiki puzzle generator.
No build_runner needed. Import dart:math and dart:collection.
Run flutter analyze after.

IMPORTANT GOTCHAS:
- Avoid dot-shorthand syntax
- Use shuffled lists from Random for variety

=== lib/features/game/domain/logic/futoshiki_generator.dart ===

The generator uses three steps:
  1. Generate a random valid Latin square (backtracking fill).
  2. Select a random subset of adjacent cell pairs as inequality constraints
     (the direction of each constraint is determined by the solution values).
  3. Create the puzzle: remove digits one by one, running a uniqueness check
     after each removal, stopping when target givens count is reached or
     further removal would break uniqueness.

--- STEP 1: Latin square generation ---

_generateLatinSquare(int n, Random rng) → List<List<int>>:
  Allocate an n×n grid of zeros.
  Fill in row-major order using backtracking:
    For each cell (r, c) in row-major order:
      Try digits 1..n in shuffled order (rng.shuffle).
      A digit d is legal at (r,c) if:
        - d does not appear in row r (among already-placed cells).
        - d does not appear in column c (among already-placed cells).
      Place the first legal digit and recurse.
      If no digit works, return false (backtrack).
  Return the filled grid.

--- STEP 2: Constraint selection ---

_generateConstraints(List<List<int>> sol, int n, Random rng)
    → List<FutoshikiConstraint>:
  Build a list of all adjacent cell pairs:
    Horizontal pairs: (r,c)-(r,c+1) for r in 0..n-1, c in 0..n-2
    Vertical pairs:   (r,c)-(r+1,c) for r in 0..n-2, c in 0..n-1
  Shuffle the list.
  Select the first targetCount pairs as constraints, where:
    targetCount = (n == 5) ? 10 : (n == 6) ? 14 : 18
  For each selected pair (r1,c1)-(r2,c2):
    isLessThan = sol[r1][c1] < sol[r2][c2]
    Add FutoshikiConstraint(row1:r1, col1:c1, row2:r2, col2:c2, isLessThan:isLessThan)
  Return the list.

--- STEP 3: Puzzle creation (digit removal) ---

_createPuzzle(
    List<List<int>> sol,
    List<FutoshikiConstraint> constraints,
    int n,
    Difficulty difficulty,
    Random rng) → FutoshikiBoard:

  Target givens:
    easy:   ceil(n * n * 0.55)   // ~55% of cells pre-filled
    medium: ceil(n * n * 0.38)   // ~38% of cells pre-filled

  Start with all cells as givens (a copy of sol).
  Build a shuffled list of all (row, col) pairs.
  Remove digits one by one:
    For each (r,c) in the shuffled list:
      Temporarily set sol[r][c] = 0.
      Count solutions using _countSolutions (see below).
      If solutionCount == 1 AND remaining givens > targetGivens:
        Keep the removal (sol[r][c] stays 0).
      Else:
        Restore sol[r][c] (removal would break uniqueness or we hit the target).
      Stop iterating once remaining givens == targetGivens.

  After removal, build FutoshikiBoard:
    For each cell (r,c):
      If sol[r][c] != 0: FutoshikiCell(row:r, col:c, value:sol[r][c], isFixed:true)
      Else:              FutoshikiCell(row:r, col:c, value:0, isFixed:false)
    solution: original (unmodified) solved grid
    constraints: the constraint list
    size: n

--- UNIQUENESS SOLVER ---

_countSolutions(
    List<List<int>> grid,    // current puzzle state (0=empty, digit=given)
    List<FutoshikiConstraint> constraints,
    int n,
    int maxCount) → int:

  Uses backtracking to count distinct solutions, stopping as soon as maxCount is reached.

  Find the first empty cell (value == 0) in row-major order.
  If none found: return 1 (a complete, valid assignment).

  For each digit d in 1..n:
    If d is legal at (r,c) — no row/col duplicate, no constraint violation:
      Set grid[r][c] = d.
      count += _countSolutions(grid, constraints, n, maxCount - count).
      Restore grid[r][c] = 0.
      If count >= maxCount: return count early.
  Return count.

  Legality check (for the solver — operates on the raw int grid, not FutoshikiBoard):
    - Row: d not in grid[r][0..n-1] (skip col c)
    - Col: d not in grid[0..n-1][c] (skip row r)
    - Constraints: for each constraint involving (r,c), if the other cell is filled,
      check the inequality. If violated, d is illegal.

--- PUBLIC API ---

class FutoshikiGenerator {
  final _rng = Random();

  FutoshikiBoard generate(int gridSize, Difficulty difficulty) {
    assert(gridSize == 5 || gridSize == 6 || gridSize == 7);
    final sol = _generateLatinSquare(gridSize, _rng);
    final constraints = _generateConstraints(sol, gridSize, _rng);
    return _createPuzzle(sol, constraints, gridSize, difficulty, _rng);
  }
}

Run flutter analyze after implementing. Fix all issues.
```

### Git — End of Phase 4
```
git add .
git commit -m "Phase 4: FutoshikiGenerator — Latin square backtracking, constraint selection, uniqueness check"
git push origin phase-04-generator
git checkout master
git pull origin master
git merge phase-04-generator
git push origin master
git checkout -b phase-05-state
```

---

## PHASE 5 — Repository & State Provider

**Goal: repository layer, Riverpod game state, break timer, and settings provider.**

```
Implement the repository and Riverpod state management for Futoshiki for Kids.

IMPORTANT GOTCHAS:
- Import Ref from flutter_riverpod, NOT riverpod_annotation
- Use unawaited() from dart:async for Future<void> calls
- Avoid dot-shorthand syntax

=== lib/features/game/domain/repositories/puzzle_repository.dart ===

abstract interface class PuzzleRepository {
  FutoshikiBoard generatePuzzle(int gridSize, Difficulty difficulty);
}

=== lib/features/game/data/repositories/puzzle_repository_impl.dart ===

class PuzzleRepositoryImpl implements PuzzleRepository {
  final _generator = FutoshikiGenerator();

  @override
  FutoshikiBoard generatePuzzle(int gridSize, Difficulty difficulty) =>
      _generator.generate(gridSize, difficulty);
}

=== lib/features/game/presentation/providers/settings_provider.dart ===

Use riverpod_annotation. Import Ref from flutter_riverpod.
Import shared_preferences.

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  static const _gridSizeKey = 'grid_size';

  @override
  int build() {
    // Load the persisted grid size; default to 5.
    _loadGridSize();
    return 5;
  }

  Future<void> _loadGridSize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_gridSizeKey) ?? 5;
    state = saved;
  }

  Future<void> setGridSize(int size) async {
    assert(size == 5 || size == 6 || size == 7);
    state = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_gridSizeKey, size);
  }
}

=== lib/features/game/presentation/providers/game_provider.dart ===

Use riverpod_annotation. Import Ref from flutter_riverpod. Import dart:async.

@riverpod
PuzzleRepository puzzleRepository(Ref ref) => PuzzleRepositoryImpl();

@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  static const int breakIntervalSeconds = 600;  // 10 minutes

  final _engine = FutoshikiEngine();
  Timer? _timer;

  @override
  GameState build() {
    ref.onDispose(() => _timer?.cancel());
    return const GameState();
  }

  Future<void> startGame(int gridSize, Difficulty difficulty) async {
    state = state.copyWith(status: GameStatus.loading);
    final repo = ref.read(puzzleRepositoryProvider);
    final board = repo.generatePuzzle(gridSize, difficulty);
    state = state.copyWith(
      board: board,
      status: GameStatus.playing,
      difficulty: difficulty,
      gridSize: gridSize,
      elapsedSeconds: 0,
      playSecondsThisSegment: 0,
      mistakes: 0,
      selectedRow: null,
      selectedCol: null,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      if (state.status == GameStatus.playing) {
        final next = state.playSecondsThisSegment + 1;
        if (next >= breakIntervalSeconds) {
          state = state.copyWith(
            playSecondsThisSegment: next,
            status: GameStatus.breakTime,
          );
        } else {
          state = state.copyWith(playSecondsThisSegment: next);
        }
      }
    });
  }

  void acknowledgeBreak() {
    state = state.copyWith(
      playSecondsThisSegment: 0,
      status: GameStatus.playing,
    );
  }

  void selectCell(int row, int col) {
    if (state.status != GameStatus.playing) return;
    final board = state.board;
    if (board == null) return;
    if (board.getCell(row, col).isFixed) return;
    // Allow selecting any non-fixed cell (even filled ones)
    state = state.copyWith(selectedRow: row, selectedCol: col);
    _highlightCells(row, col);
  }

  void _highlightCells(int row, int col) {
    final board = state.board;
    if (board == null) return;
    final n = board.size;
    final selectedValue = board.cells[row][col].value;

    final newCells = List.generate(
      n,
      (r) => List.generate(n, (c) {
        final cell = board.cells[r][c];
        return cell.copyWith(
          isSelected: r == row && c == col,
          isHighlighted: (r == row || c == col) && !(r == row && c == col),
          isSameDigit: selectedValue != 0 && cell.value == selectedValue,
        );
      }),
    );
    state = state.copyWith(
      board: board.copyWith(cells: newCells),
    );
  }

  void inputDigit(int digit) {
    if (state.status != GameStatus.playing) return;
    final board = state.board;
    if (board == null) return;
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null) return;
    final cell = board.getCell(row, col);
    if (cell.isFixed) return;

    final correct = board.getSolution(row, col);
    final isWrong = digit != correct;

    int mistakes = state.mistakes;
    if (isWrong) mistakes++;

    final updatedCell = cell.copyWith(
      value: digit,
      isError: false, // error will be recomputed below
    );
    final newCells = _replaceCell(board.cells, row, col, updatedCell);
    final updatedBoard = board.copyWith(cells: newCells);
    final errors = _engine.computeErrors(updatedBoard);

    final errorCells = List.generate(
      board.size,
      (r) => List.generate(board.size, (c) {
        final current = updatedBoard.cells[r][c];
        return current.copyWith(isError: errors.contains('$r,$c'));
      }),
    );

    final finalBoard = updatedBoard.copyWith(cells: errorCells);
    state = state.copyWith(board: finalBoard, mistakes: mistakes);
    _highlightCells(row, col);

    if (finalBoard.isComplete) {
      _timer?.cancel();
      state = state.copyWith(status: GameStatus.won);
    }
  }

  void eraseCell() {
    if (state.status != GameStatus.playing) return;
    final board = state.board;
    if (board == null) return;
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null) return;
    final cell = board.getCell(row, col);
    if (cell.isFixed) return;

    final updatedCell = cell.copyWith(value: 0, isError: false);
    final newCells = _replaceCell(board.cells, row, col, updatedCell);
    final updatedBoard = board.copyWith(cells: newCells);
    final errors = _engine.computeErrors(updatedBoard);

    final errorCells = List.generate(
      board.size,
      (r) => List.generate(board.size, (c) {
        return updatedBoard.cells[r][c]
            .copyWith(isError: errors.contains('$r,$c'));
      }),
    );

    state = state.copyWith(board: updatedBoard.copyWith(cells: errorCells));
    _highlightCells(row, col);
  }

  void useHint() {
    if (state.status != GameStatus.playing) return;
    final board = state.board;
    if (board == null) return;
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null) return;
    final cell = board.getCell(row, col);
    if (cell.isFixed) return;

    final correct = board.getSolution(row, col);
    final hinted = cell.copyWith(value: correct, isFixed: true, isError: false);
    final newCells = _replaceCell(board.cells, row, col, hinted);
    final updatedBoard = board.copyWith(cells: newCells);
    final errors = _engine.computeErrors(updatedBoard);

    final errorCells = List.generate(
      board.size,
      (r) => List.generate(board.size, (c) {
        return updatedBoard.cells[r][c]
            .copyWith(isError: errors.contains('$r,$c'));
      }),
    );

    final finalBoard = updatedBoard.copyWith(cells: errorCells);
    state = state.copyWith(board: finalBoard);
    _highlightCells(row, col);

    if (finalBoard.isComplete) {
      _timer?.cancel();
      state = state.copyWith(status: GameStatus.won);
    }
  }

  List<List<FutoshikiCell>> _replaceCell(
    List<List<FutoshikiCell>> cells, int row, int col, FutoshikiCell cell,
  ) {
    return List.generate(
      cells.length,
      (r) => r == row
          ? List.generate(cells[r].length,
              (c) => c == col ? cell : cells[r][c])
          : cells[r],
    );
  }
}

Run: dart run build_runner build --delete-conflicting-outputs
Confirm success with no errors.
```

### Git — End of Phase 5
```
git add .
git commit -m "Phase 5: repository, SettingsNotifier (grid size + shared_prefs), GameNotifier (break timer, hints, errors)"
git push origin phase-05-state
git checkout master
git pull origin master
git merge phase-05-state
git push origin master
git checkout -b phase-06-theme
```

---

## PHASE 6 — Theme & Main Entry Point

**Goal: child-friendly theme and app wiring.**

```
Implement the visual theme and main.dart.

=== lib/core/theme/app_theme.dart ===

Import google_fonts and material.

Define these colour constants:
  kPrimary       = Color(0xFFFF6B9D)  // hot pink — playful, energetic
  kSecondary     = Color(0xFF4FC3F7)  // sky blue — cool complement
  kBackground    = Color(0xFFFFF0F8)  // light pink-white — warm and soft
  kSurface       = Color(0xFFFFFFFF)
  kCellFixed     = Color(0xFF2C3E50)  // dark navy for given/fixed digits
  kConstraint    = Color(0xFFFF6B9D)  // same as kPrimary — constraint symbols
  kConstraintErr = Color(0xFFE53935)  // red — violated constraint symbol

/// Pastel pad button colours (one per digit 1–7, to support all grid sizes):
const Map<int, Color> kDigitPadColours = {
  1: Color(0xFFFFB3BA),  // pastel rose
  2: Color(0xFFFFDFBA),  // pastel peach
  3: Color(0xFFFFFFBA),  // pastel yellow
  4: Color(0xFFBAFFC9),  // pastel mint
  5: Color(0xFFBAE1FF),  // pastel sky blue
  6: Color(0xFFE8BAFF),  // pastel lavender  (used for 6×6 and 7×7)
  7: Color(0xFFFFBEF0),  // pastel pink-lilac (used for 7×7 only)
};

Create ThemeData kidsTheme:
  useMaterial3: true
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimary,
    secondary: kSecondary,
    surface: kSurface,
    brightness: Brightness.light,
  ).copyWith(surface: kBackground)
  scaffoldBackgroundColor: kBackground
  textTheme: GoogleFonts.nunitoTextTheme()
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.nunito(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
  )
  elevatedButtonTheme: rounded corners radius 16, padding vertical 14 horizontal 24
  outlinedButtonTheme: rounded corners radius 16

=== lib/main.dart ===

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FutoshikiApp()));
}

class FutoshikiApp extends StatelessWidget:
  MaterialApp(
    title: 'Futoshiki for Kids',
    theme: kidsTheme,
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  )

Run flutter analyze — fix all errors and warnings before continuing.
```

### Git — End of Phase 6
```
git add .
git commit -m "Phase 6: app theme (kPrimary pink, kSecondary sky blue, digit pad palette), main.dart"
git push origin phase-06-theme
git checkout master
git pull origin master
git merge phase-06-theme
git push origin master
git checkout -b phase-07-grid
```

---

## PHASE 7 — Futoshiki Grid Widget

**Goal: the adaptive N×N grid with cell highlighting and constraint symbols.**

```
Implement lib/features/game/presentation/widgets/futoshiki_grid.dart

This widget renders the Futoshiki board. Read carefully — the layout uses alternating
cell rows and constraint rows.

=== Layout concept ===

For an N×N board, render a Column of (2N - 1) rows:
  Even-indexed rows (0, 2, 4, ...): a Row of N cells with (N-1) horizontal
    constraint slots between them.
  Odd-indexed rows (1, 3, 5, ...): a Row of N vertical constraint slots with
    (N-1) spacers between them (matching the horizontal constraint slot widths).

Use LayoutBuilder to compute cell size:
  constraintSlotW = 26.0  // width of horizontal constraint symbol slot
  constraintSlotH = 26.0  // height of vertical constraint symbol row
  totalSlotWidth = (n - 1) * constraintSlotW
  cellSize = (availableWidth - totalSlotWidth) / n

=== FutoshikiGrid (ConsumerWidget) ===

Reads: gameNotifierProvider (for board and selectedRow/Col).
If board is null, returns SizedBox.shrink().

Renders:
  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: kPrimary.withValues(alpha:0.12), blurRadius:12, offset:Offset(0,4))],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(builder: (context, constraints) {
        // compute cellSize as above
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int r = 0; r < n; r++) ...[
              // Cell row
              Row(children: [
                for (int c = 0; c < n; c++) ...[
                  _CellWidget(
                    cell: board.cells[r][c],
                    size: cellSize,
                    // pass the board for error-state lookup
                  ),
                  if (c < n - 1) _HConstraintWidget(
                    width: constraintSlotW,
                    height: cellSize,
                    constraint: engine.hConstraint(board, r, c),
                    leftValue: board.cells[r][c].value,
                    rightValue: board.cells[r][c + 1].value,
                  ),
                ],
              ]),
              // Vertical constraint row (between game rows)
              if (r < n - 1)
                Row(children: [
                  for (int c = 0; c < n; c++) ...[
                    _VConstraintWidget(
                      width: cellSize,
                      height: constraintSlotH,
                      constraint: engine.vConstraint(board, r, c),
                      topValue: board.cells[r][c].value,
                      bottomValue: board.cells[r + 1][c].value,
                    ),
                    if (c < n - 1) SizedBox(width: constraintSlotW),
                  ],
                ]),
            ],
          ],
        );
      }),
    ),
  )

Instantiate FutoshikiEngine once as a field: final _engine = FutoshikiEngine();

=== _CellWidget (StatelessWidget) ===

Fields: FutoshikiCell cell, double size.

Background colour (priority order):
  1. cell.isSelected   → kPrimary.withValues(alpha: 0.40)
  2. cell.isSameDigit  → kSecondary.withValues(alpha: 0.35)
  3. cell.isHighlighted → kPrimary.withValues(alpha: 0.12)
  4. Default: Colors.white

Border: all sides BorderSide(color: Colors.grey.shade300, width: 0.8).

Content:
  If cell.value != 0:
    Text('${cell.value}')
      fontSize: cellSize * 0.44  (scales with cell size)
      fontWeight: FontWeight.bold
      color:
        cell.isError  → Colors.red.shade600
        cell.isFixed  → kCellFixed  (dark navy, for given digits)
        else          → kPrimary   (coral/pink, for player-entered digits)
  If cell.value == 0: empty.

Animations (flutter_animate):
  cell.isSelected → .animate(onPlay:(c)=>c.repeat(reverse:true))
                      .scale(begin:Offset(1,1), end:Offset(1.05,1.05),
                             duration:700.ms, curve:Curves.easeInOut)
  cell.isError    → .animate(key: ValueKey('err_${cell.row}_${cell.col}_${cell.value}'))
                      .shake(hz:5, duration:300.ms)

On tap:
  HapticFeedback.lightImpact()
  If !cell.isFixed:
    ref.read(gameNotifierProvider.notifier).selectCell(cell.row, cell.col)

=== _HConstraintWidget (StatelessWidget) ===

Fields: double width, double height, FutoshikiConstraint? constraint,
        int leftValue, int rightValue.

If constraint == null: SizedBox(width: width, height: height) — empty.

Symbol to display:
  constraint.isLessThan → '<' (left cell < right cell, open mouth faces right/larger)
  else                  → '>' (left cell > right cell, open mouth faces left/larger)

Is violated: leftValue != 0 && rightValue != 0 &&
             ((constraint.isLessThan && leftValue >= rightValue) ||
              (!constraint.isLessThan && leftValue <= rightValue))

Render:
  SizedBox(width: width, height: height) with Center child:
    Text(symbol,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isViolated ? kConstraintErr : kConstraint,
      ))

=== _VConstraintWidget (StatelessWidget) ===

Fields: double width, double height, FutoshikiConstraint? constraint,
        int topValue, int bottomValue.

If constraint == null: SizedBox(width: width, height: height) — empty.

Symbol:
  constraint.isLessThan → '∨'  (top < bottom, open mouth faces down toward larger)
  else                  → '∧'  (top > bottom, open mouth faces up toward larger)

Is violated: topValue != 0 && bottomValue != 0 &&
             ((constraint.isLessThan && topValue >= bottomValue) ||
              (!constraint.isLessThan && topValue <= bottomValue))

Render:
  SizedBox(width: width, height: height) with Center child:
    Text(symbol,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isViolated ? kConstraintErr : kConstraint,
      ))

Run flutter analyze. Fix all issues.
```

### Git — End of Phase 7
```
git add .
git commit -m "Phase 7: FutoshikiGrid widget — adaptive N×N layout, constraint symbols, cell highlighting"
git push origin phase-07-grid
git checkout master
git pull origin master
git merge phase-07-grid
git push origin master
git checkout -b phase-08-pad
```

---

## PHASE 8 — Digit Pad & Action Buttons

**Goal: large child-friendly digit pad (1–N) and action buttons (hint, erase).**

```
Implement lib/features/game/presentation/widgets/digit_pad.dart

=== DigitPad (ConsumerWidget) ===

Reads board from gameNotifierProvider. If board is null, returns SizedBox.shrink().

Displays digits 1 through board.size (N).

Layout: Wrap the buttons in a Row for N ≤ 6; for N == 7, use two rows (4 + 3).
  Actually, use a single Row with Flexible children for all sizes — the buttons
  will shrink gracefully. Leave a gap of 4px between buttons.

Each digit button:
  height: 60
  shape: RoundedRectangleBorder(radius: 13)
  backgroundColor: kDigitPadColours[digit]!
  child: Text('$digit', fontSize: 26, fontWeight: bold, color: Colors.black87)

  "Complete" check: all cells whose solution value == digit are correctly filled
    (cell.value == digit && !cell.isError && cell.value == board.getSolution(r,c)).
    Count total cells with solution==digit. Count cells correctly filled with digit.
    If equal → digit is complete.
  If complete: wrap button in Opacity(opacity:0.35) and disable it. Overlay a small
    check mark icon (Icons.check, size:12, color:Colors.black54) in top-right corner
    using a Stack.

  On tap: ref.read(gameNotifierProvider.notifier).inputDigit(digit)

=== ActionRow (ConsumerWidget) ===

A Row containing two Expanded buttons:

"💡 Hint" — ElevatedButton:
  backgroundColor: Color(0xFFFFD700)  — gold
  foregroundColor: Colors.black87
  fontSize: 18, height: 54, rounded 14
  Always enabled.
  On tap: ref.read(gameNotifierProvider.notifier).useHint()

"🧹 Erase" — OutlinedButton:
  side: BorderSide(color: Colors.grey.shade400)
  fontSize: 18, height: 54, rounded 14
  On tap: ref.read(gameNotifierProvider.notifier).eraseCell()

SizedBox(width: 14) between them.

Run flutter analyze. Fix all issues.
```

### Git — End of Phase 8
```
git add .
git commit -m "Phase 8: DigitPad (1..N, complete check) and ActionRow (hint, erase)"
git push origin phase-08-pad
git checkout master
git pull origin master
git merge phase-08-pad
git push origin master
git checkout -b phase-09-home
```

---

## PHASE 9 — Home Page & Privacy Policy

**Goal: welcoming home screen explaining Futoshiki and offering difficulty selection.**

```
Implement lib/features/home/presentation/pages/home_page.dart
and lib/features/home/presentation/pages/privacy_policy_page.dart

IMPORTANT GOTCHAS:
- Use SizedBox(height:N) instead of Spacer() inside SingleChildScrollView
- Use unawaited() from dart:async for startGame calls

=== HomePage (ConsumerStatefulWidget) ===

Scaffold:
  appBar: AppBar(
    title: Text('Futoshiki for Kids'),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(Icons.settings_outlined),
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SettingsPage())),
      ),
    ],
  )
  body: SafeArea → SingleChildScrollView → Padding(horizontal: 28) → Column:

    SizedBox(height: 24)

    Center → Text('⚖️', style: TextStyle(fontSize: 80))
      .animate().scale(duration:600.ms, curve:Curves.elasticOut)

    SizedBox(height: 12)

    Center → Text('Futoshiki for Kids',
      style: TextStyle(fontSize: 32, fontWeight: bold, color: kPrimary))

    SizedBox(height: 6)

    // Show current grid size from settings
    Consumer → Text('Grid: ${gridSize}×${gridSize}',
      style: TextStyle(fontSize: 15, color: Colors.grey.shade600))
      centered

    SizedBox(height: 18)

    --- How to play mini-tutorial ---
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSecondary.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment:start):
        Text('How to play:', style:TextStyle(fontSize:16, fontWeight:bold))
        SizedBox(height:8)
        _RuleLine('Fill every box with a number from 1 to $gridSize')
        _RuleLine('Each row uses every number exactly once')
        _RuleLine('Each column uses every number exactly once')
        _RuleLine('< means the LEFT box has a SMALLER number')
        _RuleLine('∨ means the TOP box has a SMALLER number')
    )

    _RuleLine is a Row: [Icon(Icons.circle, size:8, color:kPrimary), SizedBox(8), Flexible→Text(rule)]

    SizedBox(height: 28)

    Center → Text('Choose your level:',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))

    SizedBox(height: 16)

    _DifficultyButton(
      emoji: '⭐',
      label: 'Easy',
      subtitle: 'More numbers given — perfect for beginners!',
      colour: Color(0xFFB5EAD7),
      onTap: () {
        final size = ref.read(settingsNotifierProvider);
        unawaited(ref.read(gameNotifierProvider.notifier)
            .startGame(size, Difficulty.easy));
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const GamePage()));
      },
    )

    SizedBox(height: 14)

    _DifficultyButton(
      emoji: '⭐⭐',
      label: 'Medium',
      subtitle: 'Fewer numbers given — a tougher challenge!',
      colour: Color(0xFFFFDAC1),
      onTap: () {
        final size = ref.read(settingsNotifierProvider);
        unawaited(ref.read(gameNotifierProvider.notifier)
            .startGame(size, Difficulty.medium));
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const GamePage()));
      },
    )

    SizedBox(height: 40)

    Center → TextButton(
      onPressed: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => const PrivacyPolicyPage())),
      child: Text('Privacy Policy', style:TextStyle(color:Colors.grey)),
    )

    SizedBox(height: 16)

_DifficultyButton: GestureDetector wrapping a Container.
  width: double.infinity, height: 80.
  colour fill, radius 20, subtle boxShadow(blurRadius:6, offset:Offset(0,3), color:grey.shade300).
  Row inside: Text(emoji, fontSize:28), SizedBox(16), Column(label bold + subtitle small), Spacer,
              Icon(Icons.arrow_forward_ios, size:18, color:Colors.grey.shade500).

=== PrivacyPolicyPage (StatelessWidget) ===

Scaffold:
  AppBar(title: Text('Privacy Policy'))
  Body: SingleChildScrollView → Padding(32) → Column:
    Text('Privacy Policy', fontSize:24, bold)
    SizedBox(height:16)
    Text(
      'Futoshiki for Kids does not collect, store, or share any personal data.\n\n'
      'This app works entirely offline. No internet connection is required to play.\n\n'
      'This app contains no advertisements of any kind.\n\n'
      'No in-app purchases are available.\n\n'
      'If you have any questions, please contact the developer.',
      fontSize:16, height:1.7
    )
```

### Git — End of Phase 9
```
git add .
git commit -m "Phase 9: HomePage (how-to-play, difficulty buttons, settings shortcut), PrivacyPolicyPage"
git push origin phase-09-home
git checkout master
git pull origin master
git merge phase-09-home
git push origin master
git checkout -b phase-10-gamepage
```

---

## PHASE 10 — Game Page

**Goal: the main gameplay screen — stats bar, grid, digit pad, win dialog.**

```
Implement lib/features/game/presentation/pages/game_page.dart

=== GamePage (ConsumerStatefulWidget) ===

initState: _confettiController = ConfettiController(duration: Duration(seconds:3))
dispose: _confettiController.dispose()

ref.listen on gameNotifierProvider → previous status vs next status:
  If next == GameStatus.won:
    _confettiController.play()
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWinDialog())
  If next == GameStatus.breakTime:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(context, MaterialPageRoute(builder:(_) => const BreakPage()))
    })

=== Scaffold ===

AppBar:
  title: Text('Futoshiki for Kids ⚖️')
  centerTitle: true
  leading: IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.pop(context))

Body: Stack [

  Layer 1 — game content:
    SafeArea → Column:
      _StatsBar(state: gameState)
      Expanded → Center → Padding(all:12):
        ConstrainedBox(maxWidth:380, maxHeight:380) → FutoshikiGrid()
      SizedBox(height: 8)
      Padding(horizontal:16) → DigitPad()
      SizedBox(height: 8)
      Padding(horizontal:16) → ActionRow()
      SizedBox(height: 20)

  Layer 2 — confetti:
    Align(alignment: Alignment.topCenter) → ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      maxBlastForce: 28,
      minBlastForce: 10,
      emissionFrequency: 0.05,
      numberOfParticles: 45,
      gravity: 0.12,
      colors: [
        Colors.pink, Colors.blue, Colors.green, Colors.yellow,
        Colors.purple, Colors.orange, Colors.teal, Colors.red,
      ],
    )
]

=== _StatsBar (StatelessWidget) ===

Receives GameState state.

Container:
  color: kPrimary.withValues(alpha:0.08)
  padding: EdgeInsets.symmetric(vertical:10, horizontal:20)
  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween):
    Row: [Icon(Icons.timer_outlined, size:20, color:kPrimary),
          SizedBox(width:6),
          Text(formattedTime, fontSize:18, fontWeight:bold)]
    Row: [Text('Oops: ', fontSize:16),
          Text('${state.mistakes}', fontSize:18, fontWeight:bold, color:kPrimary)]

formattedTime: '${(s~/60).toString().padLeft(2,'0')}:${(s%60).toString().padLeft(2,'0')}'
where s = state.elapsedSeconds.

=== _showWinDialog ===

showDialog(barrierDismissible: false, ...).
AlertDialog:
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
  content: Column(mainAxisSize: MainAxisSize.min):
    Text('🏆', style: TextStyle(fontSize:80))
      .animate().scale(duration:700.ms, curve:Curves.elasticOut)
    SizedBox(height:16)
    Text('Brilliant Work! 🎉',
      style:TextStyle(fontSize:26, fontWeight:bold, color:Colors.green.shade700))
      .animate().fadeIn(delay:300.ms)
    SizedBox(height:8)
    Text('You solved the Futoshiki!',
      style:TextStyle(fontSize:16, color:Colors.grey.shade600))
      .animate().fadeIn(delay:500.ms)
    SizedBox(height:6)
    Text('Time: $formattedTime', style:TextStyle(fontSize:15))
      .animate().fadeIn(delay:600.ms)
  actions: [
    Center → ElevatedButton(
      onPressed: () { Navigator.pop(context); Navigator.pop(context); },
      child: Text('Play Again! ▶', fontSize:18),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(200, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ).animate().fadeIn(delay:800.ms)
  ]
```

### Git — End of Phase 10
```
git add .
git commit -m "Phase 10: GamePage — stats bar, grid, digit pad, confetti win dialog"
git push origin phase-10-gamepage
git checkout master
git pull origin master
git merge phase-10-gamepage
git push origin master
git checkout -b phase-11-break
```

---

## PHASE 11 — Break Page

**Goal: mandatory full-screen break that cannot be skipped.**

```
Implement lib/features/game/presentation/pages/break_page.dart

=== BreakPage (ConsumerWidget) ===

Use PopScope(canPop: false) to block the hardware back button.
No AppBar.

Scaffold:
  backgroundColor: Color(0xFFFFF3CD)  — warm yellow-cream
  body: SafeArea → Center → Padding(horizontal:32) → Column(mainAxisAlignment:center):

    Text('😊', style:TextStyle(fontSize:100))
      .animate(onPlay:(c)=>c.repeat(reverse:true))
      .scale(begin:Offset(1,1), end:Offset(1.08,1.08),
             duration:1200.ms, curve:Curves.easeInOut)

    SizedBox(height: 32)

    Text('Break Time!',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize:42, fontWeight:bold, color:Color(0xFFE67E22)))
      .animate().fadeIn(duration:400.ms)

    SizedBox(height: 20)

    Text(
      "You've been playing for 10 minutes.\n\n"
      "Time to rest your eyes! 👀\n\n"
      "Stretch, drink some water,\nand come back when you're ready! 😄",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize:18, color:Color(0xFF555555), height:1.7),
    ).animate().fadeIn(delay:200.ms)

    SizedBox(height: 56)

    ElevatedButton(
      onPressed: () {
        ref.read(gameNotifierProvider.notifier).acknowledgeBreak();
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        minimumSize: Size(240, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: TextStyle(fontSize:22, fontWeight:FontWeight.bold),
      ),
      child: Text("I'm Ready! ▶"),
    ).animate().fadeIn(delay:600.ms).moveY(begin:20, end:0, duration:400.ms)
```

### Git — End of Phase 11
```
git add .
git commit -m "Phase 11: BreakPage — mandatory full-screen rest, back-button blocked"
git push origin phase-11-break
git checkout master
git pull origin master
git merge phase-11-break
git push origin master
git checkout -b phase-12-checks
```

---

## PHASE 12 — Final Checks & Smoke Test

**Goal: confirm everything compiles, analyzes cleanly, and works end to end.**

```
Perform the following final checks and fix any issues found.

1. Run: dart run build_runner build --delete-conflicting-outputs
   Confirm: exits with no errors.

2. Run: flutter analyze
   Confirm: zero errors, zero warnings.
   Common issues to fix:
     - withOpacity → .withValues(alpha:x)
     - Ref imported from wrong package → flutter_riverpod
     - discarded_futures → unawaited()
     - Spacer in scroll → SizedBox(height:N)
     - dot-shorthand → write full class names
     - firstWhereOrNull without collection import → add import

3. Security check:
   Run: grep -ri "admob\|google_mobile_ads\|ad_sdk\|advert" pubspec.lock
   Must return nothing.

4. Generator self-check (add temporary debug, run once, then remove):
   Generate 10 puzzles for each grid size (5, 6, 7) × each difficulty (easy, medium)
   = 60 total. For each generated board, print:
     - gridSize, difficulty, whiteCount (cells with value==0), givenCount (isFixed)
     - That all values in the solution grid are valid (1..N, no row/col duplicates)
   Confirm no assertion failures or exceptions.

5. Run: flutter run (on a connected Android device or emulator)
   Perform this manual smoke test:

   a. App launches → Home Page shows '⚖️', title 'Futoshiki for Kids',
      how-to-play section with inequality explanation, two difficulty buttons,
      grid size indicator ('Grid: 5×5'), settings icon in app bar.

   b. Tap 'Easy' → navigates to Game Page.
      A 5×5 grid appears with:
        - White cells (most with given digits, some empty)
        - Pink constraint symbols (< > ∧ ∨) between some adjacent cell pairs
        - Stats bar showing 00:00 timer and 'Oops: 0'

   c. Tap an empty cell → it highlights in pink. Cells in the same row and
      column highlight in light pink.

   d. Tap a digit on the pad → if correct, digit shows in pink. If wrong:
      cell shakes, digit turns red, Oops counter increments.

   e. If a constraint is violated (e.g. 5 < 3), the constraint symbol turns red.

   f. Tap '💡 Hint' → correct digit fills in, locked as a given.
      Tap '🧹 Erase' → clears a non-fixed cell.

   g. Complete all cells correctly → confetti, win dialog 'Brilliant Work! 🎉'.
      Tap 'Play Again!' → returns to Home Page.

   h. Break timer test: temporarily set breakIntervalSeconds = 10,
      start a game, wait → BreakPage appears full screen.
      Back button is blocked.
      Tap 'I'm Ready! ▶' → game resumes.
      Restore breakIntervalSeconds = 600 after testing.

   i. Test Medium difficulty → fewer given digits than Easy.

6. Report the result of each step a–i. Fix any failures before reporting complete.
```

### Git — End of Phase 12
```
git add .
git commit -m "Phase 12: final checks — analyzer clean, generator test, no-ad verification"
git push origin phase-12-checks
git checkout master
git pull origin master
git merge phase-12-checks
git push origin master
git checkout -b phase-13-settings
```

---

## PHASE 13 — Settings Page (Grid Size Selector)

**Goal: a settings screen where the player can change the grid size.**

```
Implement lib/features/settings/presentation/pages/settings_page.dart

The Settings page is already reachable from the HomePage app bar (settings icon
added in Phase 9). Implement the page content here.

=== SettingsPage (ConsumerWidget) ===

Scaffold:
  AppBar(title: Text('Settings'), centerTitle: true)
  body: SafeArea → SingleChildScrollView → Padding(horizontal:28, vertical:24) → Column:

    Text('Grid Size',
      style: TextStyle(fontSize:22, fontWeight:bold, color:kPrimary))

    SizedBox(height:8)

    Text(
      'A larger grid means more numbers and more challenge. '
      'Start with 5×5 if you are new to Futoshiki!',
      style: TextStyle(fontSize:15, color:Colors.grey.shade600, height:1.5),
    )

    SizedBox(height:24)

    --- Three grid size option cards ---
    _GridSizeCard(
      size: 5,
      label: '5 × 5',
      subtitle: 'Numbers 1 – 5 · Best for beginners',
      emoji: '⭐',
      colour: Color(0xFFBAFFC9),  // pastel mint
    )
    SizedBox(height:14)
    _GridSizeCard(
      size: 6,
      label: '6 × 6',
      subtitle: 'Numbers 1 – 6 · A bigger challenge',
      emoji: '⭐⭐',
      colour: Color(0xFFFFDAC1),  // pastel peach
    )
    SizedBox(height:14)
    _GridSizeCard(
      size: 7,
      label: '7 × 7',
      subtitle: 'Numbers 1 – 7 · For puzzle experts!',
      emoji: '⭐⭐⭐',
      colour: Color(0xFFE8BAFF),  // pastel lavender
    )

    SizedBox(height:40)

    Text('About',
      style: TextStyle(fontSize:22, fontWeight:bold, color:kPrimary))

    SizedBox(height:12)

    Text(
      'Futoshiki for Kids\nVersion 1.0.0\n\n'
      'A child-friendly inequality puzzle — no ads, no data collected, '
      'just fun and learning!',
      style: TextStyle(fontSize:15, color:Colors.grey.shade700, height:1.6),
    )

    SizedBox(height:16)

=== _GridSizeCard (ConsumerWidget) ===

Fields: int size, String label, String subtitle, String emoji, Color colour.

Reads: settingsNotifierProvider (to know currently selected size).

bool isSelected = ref.watch(settingsNotifierProvider) == size

Render:
  GestureDetector(onTap: () {
    ref.read(settingsNotifierProvider.notifier).setGridSize(size)
    // Show a brief snackbar: 'Grid size set to $size×$size — starts from next game'
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Grid size set to $size×$size! Starts from your next game.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }) →
  AnimatedContainer(
    duration: 200.ms,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isSelected ? colour : colour.withValues(alpha:0.45),
      borderRadius: BorderRadius.circular(18),
      border: isSelected
        ? Border.all(color: kPrimary, width: 2.5)
        : Border.all(color: Colors.transparent, width: 2.5),
      boxShadow: isSelected
        ? [BoxShadow(color: kPrimary.withValues(alpha:0.25),
                     blurRadius:8, offset:Offset(0,3))]
        : [],
    ),
    child: Row(children: [
      Text(emoji, style:TextStyle(fontSize:28)),
      SizedBox(width:16),
      Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
        Text(label, style:TextStyle(fontSize:18, fontWeight:bold)),
        SizedBox(height:3),
        Text(subtitle, style:TextStyle(fontSize:13, color:Colors.grey.shade700)),
      ])),
      if (isSelected) Icon(Icons.check_circle, color:kPrimary, size:28),
    ]),
  )

=== Update HomePage to show current grid size reactively ===

In HomePage, read settingsNotifierProvider and display the current size:
  Consumer(builder: (context, ref, _) {
    final size = ref.watch(settingsNotifierProvider);
    return Text('Grid: $size×$size  •  Tap ⚙ to change',
      style: TextStyle(fontSize:14, color:Colors.grey.shade500));
  })

Run: dart run build_runner build --delete-conflicting-outputs
Run: flutter analyze — confirm zero issues.
Run: flutter run — verify the settings page is accessible, grid size selection
     persists after app restart, and starting a new game uses the selected size.
```

### Git — End of Phase 13
```
git add .
git commit -m "Phase 13: settings page — grid size selector (5×5 / 6×6 / 7×7) with shared_prefs persistence"
git push origin phase-13-settings
git checkout master
git pull origin master
git merge phase-13-settings
git push origin master
git checkout -b phase-14-panel
```

---

## PHASE 14 — Game Panel (Pencil Marks, Solving Aids, Save / Reset)

**Goal: add a right-side panel on wide screens (drawer on mobile) containing input-mode
selection, solving aids toggles, game action buttons, and a help section.
Also adds pencil mark support to cells and save/load/reset to the game state.**

---

### 14-A — Update Domain Models

```
Update the two domain model files. Run build_runner after both are changed.

=== lib/features/game/domain/models/cell.dart — ADD two fields ===

Inside the FutoshikiCell @freezed class, add after the existing fields:

  @Default(<int>[]) List<int> pencilMarks
      // Candidate digits the player has marked in pencil-mark mode.
      // Empty when not used. Max N entries (1..board.size).

  @Default(false) bool isRevealed
      // Set to true by "Give Up & Show Solution". Styled differently from isFixed.

Re-run build_runner after saving.

=== lib/features/game/domain/models/game_state.dart — ADD enum + fields ===

Add this enum at the top of the file (alongside GameStatus and Difficulty):

  enum PlaceMode { solution, pencilMarks }

Inside the GameState @freezed class, add after the existing fields:

  @Default(PlaceMode.solution) PlaceMode placeMode
      // Controls whether digit-pad taps place solution digits or toggle pencil marks.

  @Default(true) bool showRepeatedDigits
      // When true, cells with duplicate values in their row/col are highlighted as errors.

  @Default(true) bool showBrokenInequalities
      // When true, constraint symbols are coloured red when violated.

  @Default(false) bool showWrongMoves
      // Master toggle. When false, no real-time error highlighting is shown.
      // Errors only appear after the player taps "Check Solution".

  @Default(true) bool autoRemovePencilMarks
      // When true, placing a solution digit removes that digit from pencil marks
      // of all other cells in the same row and column.

  FutoshikiBoard? initialBoard
      // Snapshot of the board at puzzle start (all non-fixed cells empty).
      // Used by "Reset Puzzle" to restore the original state.

Run: dart run build_runner build --delete-conflicting-outputs
Confirm: no errors.
```

---

### 14-B — Update GameNotifier

```
Extend lib/features/game/presentation/providers/game_provider.dart with the
new methods below. Also update startGame and inputDigit.

IMPORTANT GOTCHAS:
- Import dart:convert (for jsonEncode / jsonDecode)
- Import shared_preferences
- Avoid dot-shorthand syntax
- Use unawaited() from dart:async where needed

=== Update startGame ===

After creating the board, also store it as initialBoard:
  final initial = board; // the freshly generated board (no player entries)
  state = state.copyWith(
    board: board,
    initialBoard: initial,
    placeMode: PlaceMode.solution,
    showRepeatedDigits: true,
    showBrokenInequalities: true,
    showWrongMoves: false,
    autoRemovePencilMarks: true,
    // ... rest of existing fields
  );

=== Update inputDigit ===

At the top of the method, check placeMode:
  if (state.placeMode == PlaceMode.pencilMarks) {
    _togglePencilMark(digit);
    return;
  }
  // ... existing solution-placement logic below ...

After placing a correct digit (when placeMode == solution and autoRemovePencilMarks):
  // Remove placed digit from pencil marks in same row and column
  if (state.autoRemovePencilMarks) {
    newCells = _clearPencilMarkInRowCol(newCells, row, col, digit, board.size);
  }

Add private helper:
  List<List<FutoshikiCell>> _clearPencilMarkInRowCol(
      List<List<FutoshikiCell>> cells, int row, int col, int digit, int n) {
    return List.generate(n, (r) => List.generate(n, (c) {
      if (r == row && c == col) return cells[r][c]; // skip placed cell
      if (r != row && c != col) return cells[r][c]; // not in same row or col
      final cell = cells[r][c];
      if (!cell.pencilMarks.contains(digit)) return cell;
      return cell.copyWith(
        pencilMarks: cell.pencilMarks.where((d) => d != digit).toList(),
      );
    }));
  }

=== Update _applyErrors (refactor of the inline error logic) ===

Extract the error-application logic into a private method so it can be
controlled by the showWrongMoves / showRepeatedDigits / showBrokenInequalities flags.

  List<List<FutoshikiCell>> _applyErrors(
      FutoshikiBoard board, {bool force = false}) {
    // force = true when called from checkSolution (ignores showWrongMoves toggle).
    if (!force && !state.showWrongMoves) {
      // Clear all errors — do not show real-time feedback.
      return List.generate(board.size, (r) =>
          List.generate(board.size, (c) =>
              board.cells[r][c].copyWith(isError: false)));
    }

    final allErrors = _engine.computeErrors(board);
    // Optionally filter by which aids are enabled.
    // computeErrors returns a flat Set<String> of "r,c" keys for ALL error types.
    // To separate row/col errors from constraint errors, re-run partial checks:
    final rowColErrors = state.showRepeatedDigits
        ? _engine.computeRowColErrors(board)   // only row/col duplicates
        : <String>{};
    final constraintErrors = state.showBrokenInequalities
        ? _engine.computeConstraintErrors(board) // only constraint violations
        : <String>{};
    final visibleErrors = {...rowColErrors, ...constraintErrors};

    return List.generate(board.size, (r) =>
        List.generate(board.size, (c) =>
            board.cells[r][c].copyWith(isError: visibleErrors.contains('$r,$c'))));
  }

NOTE: This requires splitting computeErrors in FutoshikiEngine into two separate
methods — computeRowColErrors and computeConstraintErrors. Update the engine:

In futoshiki_engine.dart, add:
  Set<String> computeRowColErrors(FutoshikiBoard board) — same logic as
    the row/col duplicate detection section of computeErrors.

  Set<String> computeConstraintErrors(FutoshikiBoard board) — same logic as
    the constraint violation section of computeErrors.

  Keep computeErrors as the union: {…computeRowColErrors(b), …computeConstraintErrors(b)}.

Update all existing calls to the old inline error logic in GameNotifier to use _applyErrors.

=== New method: _togglePencilMark ===

  void _togglePencilMark(int digit) {
    if (state.status != GameStatus.playing) return;
    final board = state.board;
    if (board == null) return;
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null) return;
    final cell = board.getCell(row, col);
    if (cell.isFixed || cell.isRevealed) return;
    if (cell.value != 0) return; // pencil marks only on empty cells

    final marks = List<int>.from(cell.pencilMarks);
    if (marks.contains(digit)) {
      marks.remove(digit);
    } else {
      marks.add(digit);
      marks.sort();
    }

    final updated = cell.copyWith(pencilMarks: marks);
    final newCells = _replaceCell(board.cells, row, col, updated);
    state = state.copyWith(board: board.copyWith(cells: newCells));
  }

=== New method: setPlaceMode ===
  void setPlaceMode(PlaceMode mode) =>
      state = state.copyWith(placeMode: mode);

=== New methods: toggle panel settings ===
  void toggleShowRepeatedDigits() =>
      state = state.copyWith(showRepeatedDigits: !state.showRepeatedDigits);

  void toggleShowBrokenInequalities() =>
      state = state.copyWith(showBrokenInequalities: !state.showBrokenInequalities);

  void toggleShowWrongMoves() =>
      state = state.copyWith(showWrongMoves: !state.showWrongMoves);

  void toggleAutoRemovePencilMarks() =>
      state = state.copyWith(autoRemovePencilMarks: !state.autoRemovePencilMarks);

=== New method: checkSolution ===

  void checkSolution() {
    final board = state.board;
    if (board == null) return;
    // Force-apply all errors regardless of showWrongMoves toggle.
    final errorCells = _applyErrors(board, force: true);
    state = state.copyWith(board: board.copyWith(cells: errorCells));
  }
  // Caller (the button in the panel) shows a dialog summarising the result:
  //   Count cells where isError == true.
  //   0 errors + isComplete → show "All correct! Well done!" dialog.
  //   0 errors + not complete → show "No mistakes so far — keep going!" dialog.
  //   N errors → show "X cells need fixing." dialog.

=== New method: resetPuzzle ===

  void resetPuzzle() {
    final initial = state.initialBoard;
    if (initial == null) return;
    state = state.copyWith(
      board: initial,
      selectedRow: null,
      selectedCol: null,
      mistakes: 0,
      placeMode: PlaceMode.solution,
    );
  }

=== New method: giveUp ===

  void giveUp() {
    final board = state.board;
    if (board == null) return;
    _timer?.cancel();

    final revealedCells = List.generate(board.size, (r) =>
        List.generate(board.size, (c) {
          final cell = board.cells[r][c];
          if (cell.isFixed || cell.isRevealed) return cell;
          // Only reveal cells the player hasn't already solved correctly.
          final correct = board.getSolution(r, c);
          if (cell.value == correct && !cell.isError) return cell;
          return cell.copyWith(
            value: correct,
            isRevealed: true,
            isError: false,
            pencilMarks: const <int>[],
          );
        }));

    state = state.copyWith(
      board: board.copyWith(cells: revealedCells),
      status: GameStatus.won,
      selectedRow: null,
      selectedCol: null,
    );
  }

=== New method: saveGame ===

  Future<void> saveGame() async {
    final board = state.board;
    if (board == null) return;
    final prefs = await SharedPreferences.getInstance();

    // Build a JSON-serialisable map of the current game.
    final Map<String, dynamic> save = {
      'gridSize': board.size,
      'difficulty': state.difficulty.name,
      'elapsedSeconds': state.elapsedSeconds,
      'mistakes': state.mistakes,
      'solution': board.solution,
      'constraints': board.constraints
          .map((c) => {
                'r1': c.row1, 'c1': c.col1,
                'r2': c.row2, 'c2': c.col2,
                'lt': c.isLessThan,
              })
          .toList(),
      'cells': List.generate(board.size, (r) =>
          List.generate(board.size, (c) {
            final cell = board.cells[r][c];
            return {
              'v': cell.value,
              'f': cell.isFixed,
              'r': cell.isRevealed,
              'pm': cell.pencilMarks,
            };
          })),
      'initialCells': List.generate(board.size, (r) =>
          List.generate(board.size, (c) {
            final cell = state.initialBoard!.cells[r][c];
            return {'v': cell.value, 'f': cell.isFixed};
          })),
      'settings': {
        'showRepeatedDigits': state.showRepeatedDigits,
        'showBrokenInequalities': state.showBrokenInequalities,
        'showWrongMoves': state.showWrongMoves,
        'autoRemovePencilMarks': state.autoRemovePencilMarks,
      },
    };

    await prefs.setString('saved_game', jsonEncode(save));
  }

=== New method: loadSavedGame ===

  Future<bool> loadSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('saved_game');
    if (raw == null) return false;

    try {
      final Map<String, dynamic> save = jsonDecode(raw) as Map<String, dynamic>;
      final n = save['gridSize'] as int;
      final difficulty = Difficulty.values.byName(save['difficulty'] as String);
      final solution = (save['solution'] as List)
          .map((row) => (row as List).map((v) => v as int).toList())
          .toList();
      final constraints = (save['constraints'] as List)
          .map((c) => FutoshikiConstraint(
                row1: c['r1'] as int, col1: c['c1'] as int,
                row2: c['r2'] as int, col2: c['c2'] as int,
                isLessThan: c['lt'] as bool,
              ))
          .toList();

      List<List<FutoshikiCell>> buildCells(List raw) => List.generate(n, (r) =>
          List.generate(n, (c) {
            final d = raw[r][c] as Map<String, dynamic>;
            return FutoshikiCell(
              row: r, col: c,
              value: d['v'] as int,
              isFixed: d['f'] as bool,
              isRevealed: (d['r'] as bool?) ?? false,
              pencilMarks: ((d['pm'] as List?)?.map((e) => e as int).toList()) ?? [],
            );
          }));

      final cells = buildCells(save['cells'] as List);
      final initCells = buildCells(save['initialCells'] as List);

      final board = FutoshikiBoard(
          cells: cells, solution: solution,
          constraints: constraints, size: n);
      final initial = FutoshikiBoard(
          cells: initCells, solution: solution,
          constraints: constraints, size: n);

      final settings = save['settings'] as Map<String, dynamic>;
      state = state.copyWith(
        board: board,
        initialBoard: initial,
        status: GameStatus.playing,
        difficulty: difficulty,
        gridSize: n,
        elapsedSeconds: save['elapsedSeconds'] as int,
        mistakes: save['mistakes'] as int,
        selectedRow: null, selectedCol: null,
        showRepeatedDigits: settings['showRepeatedDigits'] as bool,
        showBrokenInequalities: settings['showBrokenInequalities'] as bool,
        showWrongMoves: settings['showWrongMoves'] as bool,
        autoRemovePencilMarks: settings['autoRemovePencilMarks'] as bool,
        placeMode: PlaceMode.solution,
      );
      _startTimer();
      return true;
    } catch (_) {
      return false; // corrupt save — silently ignore
    }
  }

=== New provider: hasSavedGame ===

Add outside the GameNotifier class:

  @riverpod
  Future<bool> hasSavedGame(Ref ref) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('saved_game');
  }

Run: dart run build_runner build --delete-conflicting-outputs
Confirm: no errors.
```

---

### 14-C — Update FutoshikiGrid (pencil marks + toggleable errors)

```
Update lib/features/game/presentation/widgets/futoshiki_grid.dart

=== _CellWidget — pencil mark display ===

When cell.value == 0 AND cell.pencilMarks is non-empty, display pencil marks
instead of the empty cell. Show all digit positions 1..N arranged in a 3-column
grid (crossAxisCount: 3). Each slot shows the digit if it is in pencilMarks,
or empty text if not.

  // Inside _CellWidget build, replace the empty-cell branch:
  if (cell.value == 0) {
    child = cell.pencilMarks.isEmpty
        ? const SizedBox.shrink()
        : _PencilMarkGrid(marks: cell.pencilMarks, n: boardSize, cellSize: size);
  }

=== _PencilMarkGrid (StatelessWidget) ===

Fields: List<int> marks, int n, double size.

  GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    itemCount: n,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (_, i) {
      final d = i + 1;
      return Center(
        child: Text(
          marks.contains(d) ? '$d' : '',
          style: TextStyle(
            fontSize: size * 0.17,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade500,
          ),
        ),
      );
    },
  )

=== _HConstraintWidget — honour showBrokenInequalities ===

Pass the game state's showBrokenInequalities flag down to the constraint widgets.
If showBrokenInequalities is false, always use kConstraint colour (never red).

Add a bool showErrors field to both _HConstraintWidget and _VConstraintWidget.
Default to true. When false: color is always kConstraint regardless of violation.

In FutoshikiGrid, read the setting:
  final showConstraintErrors = ref.watch(
    gameNotifierProvider.select((s) => s.showBrokenInequalities && s.showWrongMoves));

Pass showConstraintErrors to every _HConstraintWidget and _VConstraintWidget.

=== _CellWidget — honour showRepeatedDigits ===

The cell's isError flag is now set by the GameNotifier based on the panel settings
(via _applyErrors). The grid widget does NOT need to re-implement this logic —
it just reads cell.isError as before. No grid-widget change needed here beyond
ensuring it uses cell.isError for colouring (already done in Phase 7).

Run flutter analyze. Fix all issues.
```

---

### 14-D — Build the Game Panel Widget

```
Create lib/features/game/presentation/widgets/game_panel.dart

This widget is shared between the wide-screen sidebar and the mobile drawer.
It is a scrollable column with five sections.

=== GamePanel (ConsumerWidget) ===

Container(
  color: Colors.white,
  child: SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Place Numbers ─────────────────────────────────
        _SectionHeader('Place Numbers'),
        SizedBox(height: 8),
        _ModeRadio(
          label: 'Solution',
          value: PlaceMode.solution,
        ),
        _ModeRadio(
          label: 'Pencil Marks',
          value: PlaceMode.pencilMarks,
        ),

        _Divider(),

        // ── Solving Aids ──────────────────────────────────
        _SectionHeader('Solving Aids'),
        SizedBox(height: 8),
        _PanelCheckbox(
          label: 'Show Repeated Digits',
          getter: (s) => s.showRepeatedDigits,
          onToggle: (ref) => ref.read(gameNotifierProvider.notifier)
              .toggleShowRepeatedDigits(),
        ),
        _PanelCheckbox(
          label: 'Show Broken Inequalities',
          getter: (s) => s.showBrokenInequalities,
          onToggle: (ref) => ref.read(gameNotifierProvider.notifier)
              .toggleShowBrokenInequalities(),
        ),
        SizedBox(height: 10),
        Text('Pencil Mark Tools:',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                           color: Colors.grey.shade700)),
        SizedBox(height: 4),
        _PanelCheckbox(
          label: 'Auto Remove',
          getter: (s) => s.autoRemovePencilMarks,
          onToggle: (ref) => ref.read(gameNotifierProvider.notifier)
              .toggleAutoRemovePencilMarks(),
        ),

        _Divider(),

        // ── Solution Assistants ───────────────────────────
        _SectionHeader('Solution Assistants'),
        SizedBox(height: 8),
        _PanelCheckbox(
          label: 'Show Wrong Moves',
          getter: (s) => s.showWrongMoves,
          onToggle: (ref) => ref.read(gameNotifierProvider.notifier)
              .toggleShowWrongMoves(),
        ),

        SizedBox(height: 14),

        // ── Action Buttons ────────────────────────────────
        _PanelButton(
          label: 'Check Solution',
          icon: Icons.check_circle_outline,
          colour: Color(0xFF4CAF50),
          onPressed: (context, ref) {
            ref.read(gameNotifierProvider.notifier).checkSolution();
            final board = ref.read(gameNotifierProvider).board;
            if (board == null) return;
            final errorCount = board.cells.expand((r) => r)
                .where((c) => c.isError).length;
            final isComplete = board.isComplete;
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                content: Text(
                  isComplete
                    ? '🎉 All correct — puzzle complete!'
                    : errorCount == 0
                      ? '✅ No mistakes so far — keep going!'
                      : '❌ $errorCount cell${errorCount == 1 ? '' : 's'} need fixing.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 8),
        _PanelButton(
          label: 'Save Game',
          icon: Icons.save_outlined,
          colour: Color(0xFF1976D2),
          onPressed: (context, ref) async {
            await ref.read(gameNotifierProvider.notifier).saveGame();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Game saved!'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
        ),
        SizedBox(height: 8),
        _PanelButton(
          label: 'Reset Puzzle',
          icon: Icons.refresh,
          colour: Color(0xFFF57C00),
          onPressed: (context, ref) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text('Reset Puzzle?'),
                content: Text(
                  'This will clear all your progress and return to '
                  'the original puzzle. Are you sure?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF57C00),
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(gameNotifierProvider.notifier).resetPuzzle();
                    },
                    child: Text('Reset'),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 8),
        _PanelButton(
          label: 'Give Up & Show Solution',
          icon: Icons.lightbulb_outline,
          colour: Color(0xFF9C27B0),
          onPressed: (context, ref) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text('Show the Solution?'),
                content: Text(
                  'The complete solution will be filled in. '
                  'You won\'t be able to undo this.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9C27B0),
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(gameNotifierProvider.notifier).giveUp();
                    },
                    child: Text('Show It'),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 8),
        _PanelButton(
          label: 'Hint',
          icon: Icons.tips_and_updates_outlined,
          colour: Color(0xFFFFD700),
          foreground: Colors.black87,
          onPressed: (context, ref) =>
              ref.read(gameNotifierProvider.notifier).useHint(),
        ),

        _Divider(),

        // ── Help ──────────────────────────────────────────
        _SectionHeader('Help'),
        SizedBox(height: 8),
        Text(
          'Instructions will go here.',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600,
                           fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 20),
      ],
    ),
  ),
)

=== Internal helper widgets ===

_SectionHeader — Text with kPrimary colour, fontSize 15, FontWeight.bold.

_Divider — Padding(vertical:12) → Divider(color: Colors.grey.shade200).

_ModeRadio (ConsumerWidget):
  Fields: String label, PlaceMode value.
  Reads groupValue from state.placeMode.
  RadioListTile<PlaceMode>(
    dense: true,
    contentPadding: EdgeInsets.zero,
    title: Text(label, style: TextStyle(fontSize: 14)),
    value: value,
    groupValue: ref.watch(gameNotifierProvider.select((s) => s.placeMode)),
    onChanged: (v) {
      if (v != null)
        ref.read(gameNotifierProvider.notifier).setPlaceMode(v);
    },
  )

_PanelCheckbox (ConsumerWidget):
  Fields: String label,
          bool Function(GameState) getter,
          void Function(WidgetRef) onToggle.
  CheckboxListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    title: Text(label, style: TextStyle(fontSize: 14)),
    value: ref.watch(gameNotifierProvider.select(getter)),
    onChanged: (_) => onToggle(ref),
    activeColor: kPrimary,
    checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4)),
  )

_PanelButton (StatelessWidget):
  Fields: String label, IconData icon, Color colour,
          Color foreground (default Colors.white),
          void Function(BuildContext, WidgetRef) onPressed.
  Render as a Consumer widget wrapping an ElevatedButton:
    width: double.infinity, height: 44
    backgroundColor: colour, foregroundColor: foreground
    borderRadius: 10
    Row child: Icon(icon, size:18), SizedBox(8), Text(label, fontSize:14)

Run flutter analyze. Fix all issues.
```

---

### 14-E — Update GamePage (responsive layout)

```
Update lib/features/game/presentation/pages/game_page.dart

Replace the existing build method body with a responsive layout:

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider);
    final isWideScreen = MediaQuery.of(context).size.width >= 700;

    // ref.listen (confetti + break) stays unchanged from Phase 10.

    final gameContent = SafeArea(
      child: Column(
        children: [
          _StatsBar(state: gameState),
          // Mode indicator bar — shown only in pencil-marks mode
          if (gameState.placeMode == PlaceMode.pencilMarks)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6),
              color: kPrimary.withValues(alpha: 0.15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, size: 16, color: kPrimary),
                  SizedBox(width: 6),
                  Text('Pencil Mark Mode',
                      style: TextStyle(fontSize: 13, color: kPrimary,
                                       fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 380, maxHeight: 380),
                  child: FutoshikiGrid(),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DigitPad()),
          SizedBox(height: 8),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ActionRow()),
          SizedBox(height: 16),
        ],
      ),
    );

    final scaffold = isWideScreen
        // ── Wide screen: panel fixed on the right ─────────
        ? Scaffold(
            appBar: AppBar(
              title: Text('Futoshiki for Kids ⚖️'),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () => Navigator.pop(context)),
            ),
            body: Stack(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: gameContent),
                  Container(
                    width: 270,
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Colors.grey.shade200, width: 1)),
                    ),
                    child: const GamePanel(),
                  ),
                ],
              ),
              // Confetti layer
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(/* same params as Phase 10 */),
              ),
            ]),
          )
        // ── Mobile: panel in end drawer (placement TBD) ───
        // TODO: decide mobile panel placement (bottom sheet, drawer, etc.)
        : Scaffold(
            appBar: AppBar(
              title: Text('Futoshiki for Kids ⚖️'),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () => Navigator.pop(context)),
              actions: [
                Builder(
                  builder: (ctx) => IconButton(
                    icon: Icon(Icons.menu),
                    tooltip: 'Game menu',
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  ),
                ),
              ],
            ),
            endDrawer: Drawer(
              width: 280,
              child: SafeArea(child: const GamePanel()),
            ),
            body: Stack(children: [
              gameContent,
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(/* same params as Phase 10 */),
              ),
            ]),
          );

    return scaffold;
  }

Note: move the ConfettiController and ref.listen setup into initState / didChangeDependencies
as before — the listener does not change.

Run flutter analyze. Fix all issues.
```

---

### 14-F — Update HomePage (Continue Game button)

```
Update lib/features/home/presentation/pages/home_page.dart

Add a "Continue Game" card that appears when a saved game is detected.

Inside the HomePage build, add a Consumer above the difficulty buttons:

  ref.watch(hasSavedGameProvider).when(
    data: (exists) {
      if (!exists) return SizedBox.shrink();
      return Column(
        children: [
          GestureDetector(
            onTap: () async {
              final loaded = await ref.read(gameNotifierProvider.notifier)
                  .loadSavedGame();
              if (loaded && context.mounted) {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GamePage()));
              }
            },
            child: Container(
              width: double.infinity,
              height: 72,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFDCF5FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kSecondary, width: 1.5),
                boxShadow: [BoxShadow(
                    color: Colors.grey.shade200, blurRadius: 4,
                    offset: Offset(0, 2))],
              ),
              child: Row(children: [
                Text('▶️', style: TextStyle(fontSize: 28)),
                SizedBox(width: 16),
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Continue Game',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Resume where you left off',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ],
                )),
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade400),
              ]),
            ),
          ),
          SizedBox(height: 14),
        ],
      );
    },
    loading: () => SizedBox.shrink(),
    error: (_, __) => SizedBox.shrink(),
  )

Place this block between the how-to-play tutorial box and the "Choose your level:" text.

Run: dart run build_runner build --delete-conflicting-outputs
Run: flutter analyze — confirm zero issues.
Run: flutter run — verify:
  a. Wide screen (Chrome or tablet): Game Panel appears as a sidebar on the right.
  b. Mobile: a ☰ menu icon in the AppBar opens the panel as an end drawer.
  c. "Place Numbers" radio switches between solution and pencil-mark entry.
     In pencil-mark mode a pink indicator bar appears below the stats bar.
  d. Tapping digits in pencil-mark mode adds/removes small numbers inside empty cells.
  e. "Auto Remove" clears a digit from pencil marks in the same row/col
     when a solution digit is placed.
  f. "Show Wrong Moves" off → no real-time error colours.
     "Check Solution" → dialog shows error count.
  g. "Save Game" → SnackBar confirms. Kill app, reopen → "Continue Game" appears.
  h. "Reset Puzzle" confirmation dialog → clears all player entries.
  i. "Give Up & Show Solution" → fills in remaining cells (styled differently
     from givens — use a purple/lilac tint to distinguish revealed cells).
  j. Revealed cells (isRevealed): render their digit in Color(0xFF7B1FA2) (deep purple)
     instead of kPrimary, so the child can see which cells they didn't solve.

Update _CellWidget to add the isRevealed colour case:
  cell.isRevealed → Color(0xFF7B1FA2)  // deep purple — "shown to you" colour
  (Priority: after isFixed/kCellFixed check, before the player-entered kPrimary case)
```

### Git — End of Phase 14
```
git add .
git commit -m "Phase 14: game panel — pencil marks, solving aids toggles, check/save/reset/give-up, responsive sidebar"
git push origin phase-14-panel
git checkout master
git pull origin master
git merge phase-14-panel
git push origin master
```

---

## Quick Reference — Key Design Decisions

| Decision | Reason |
|---|---|
| 5×5 default, 6×6 / 7×7 optional | Age-appropriate entry point; older kids can grow into larger grids |
| Inequality symbols `<` `>` `∧` `∨` | Standard Futoshiki notation; open mouth always faces the larger number |
| Full backtracking generator | Works for all three grid sizes; uniqueness guaranteed by solver |
| Uniqueness check on every removal | Ensures the puzzle has exactly one correct answer |
| Zero ads | Child safety; COPPA/GDPR-K compliance |
| Unlimited hints | Children learn by seeing answers; no frustration spiral |
| No mistake limit | Encourages experimentation; gentle red feedback only |
| Mandatory 10-min breaks | Screen-time hygiene; back-button blocked so it cannot be skipped |
| Riverpod (keepAlive) for game state | Survives navigation without resetting the timer or board |
| shared_preferences for grid size | User preference survives app restarts without a backend |
| constraint symbols turn red on violation | Immediate, non-punishing visual feedback for constraint errors |
| `collection` package for `firstWhereOrNull` | Null-safe way to find constraints — avoids manual for-loops |
| Game panel: sidebar on wide, drawer on mobile | Right-side panel for PC/Chrome; mobile placement left as TBD via endDrawer |
| PlaceMode enum (solution / pencilMarks) | Separates digit entry from candidate marking; toggled in the panel |
| pencilMarks as `List<int>` in cell | JSON-serialisable; treated as a sorted set; stored per-cell |
| autoRemovePencilMarks | Convenience for experienced players; removes obvious candidates automatically |
| showWrongMoves as master toggle | Lets the player choose whether to see errors in real-time or only on demand |
| computeRowColErrors + computeConstraintErrors | Split engine methods so aids can be toggled independently |
| initialBoard in GameState | Snapshot at puzzle start; enables one-tap Reset without regenerating |
| isRevealed styled in deep purple | Visually distinguishes "given up" cells from original givens and player entries |
| Save/load via shared_preferences JSON | Simple persistence with no backend; survives app restarts |
| hasSavedGameProvider (FutureProvider) | Reactive check on home page; shows Continue button only when needed |

---

## Colour Palette

| Constant | Hex | Use |
|---|---|---|
| kPrimary | #FF6B9D | AppBar, selected cell, player digits, constraint symbols |
| kSecondary | #4FC3F7 | Same-digit highlight, tutorial box |
| kBackground | #FFF0F8 | Scaffold background |
| kSurface | #FFFFFF | Cell backgrounds |
| kCellFixed | #2C3E50 | Given/fixed digit text (dark navy) |
| kConstraint | #FF6B9D | Constraint symbol (normal) |
| kConstraintErr | #E53935 | Constraint symbol (violated) |

## Digit Pad Colours (kDigitPadColours)

| Digit | Hex | Name |
|---|---|---|
| 1 | #FFB3BA | Pastel rose |
| 2 | #FFDFBA | Pastel peach |
| 3 | #FFFFBA | Pastel yellow |
| 4 | #BAFFC9 | Pastel mint |
| 5 | #BAE1FF | Pastel sky blue |
| 6 | #E8BAFF | Pastel lavender |
| 7 | #FFBEF0 | Pastel pink-lilac |

## Grid Size Selector Colours

| Size | Hex | Name |
|---|---|---|
| 5×5 | #BAFFC9 | Pastel mint |
| 6×6 | #FFDAC1 | Pastel peach |
| 7×7 | #E8BAFF | Pastel lavender |
