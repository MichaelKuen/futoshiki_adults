import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/puzzle_repository_impl.dart';
import '../../domain/logic/futoshiki_engine.dart';
import '../../domain/models/board.dart';
import '../../domain/models/cell.dart';
import '../../domain/models/constraint.dart';
import '../../domain/models/game_state.dart';
import '../../domain/repositories/puzzle_repository.dart';

part 'game_provider.g.dart';

@riverpod
PuzzleRepository puzzleRepository(Ref ref) => PuzzleRepositoryImpl();

@riverpod
Future<bool> hasSavedGame(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('saved_game');
}

@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  static const int breakIntervalSeconds = 600;

  final _engine = FutoshikiEngine();
  Timer? _timer;

  @override
  GameState build() {
    ref.onDispose(() => _timer?.cancel());
    return const GameState();
  }

  // ── Game lifecycle ────────────────────────────────────────────────────────

  Future<void> startGame(int gridSize, Difficulty difficulty) async {
    state = state.copyWith(status: GameStatus.loading);
    final repo = ref.read(puzzleRepositoryProvider);
    final board = repo.generatePuzzle(gridSize, difficulty);
    state = state.copyWith(
      board: board,
      initialBoard: board,
      status: GameStatus.playing,
      difficulty: difficulty,
      gridSize: gridSize,
      elapsedSeconds: 0,
      playSecondsThisSegment: 0,
      mistakes: 0,
      selectedRow: null,
      selectedCol: null,
      placeMode: PlaceMode.solution,
      showRepeatedDigits: true,
      showBrokenInequalities: true,
      showWrongMoves: false,
      autoRemovePencilMarks: true,
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

  // ── Cell selection ────────────────────────────────────────────────────────

  void selectCell(int row, int col) {
    if (state.status != GameStatus.playing) return;
    final board = state.board;
    if (board == null) return;
    if (board.getCell(row, col).isFixed) return;
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
    state = state.copyWith(board: board.copyWith(cells: newCells));
  }

  // ── Digit input ───────────────────────────────────────────────────────────

  void inputDigit(int digit) {
    if (state.status != GameStatus.playing) return;
    if (state.placeMode == PlaceMode.pencilMarks) {
      _togglePencilMark(digit);
      return;
    }

    final board = state.board;
    if (board == null) return;
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null) return;
    final cell = board.getCell(row, col);
    if (cell.isFixed || cell.isRevealed) return;

    final correct = board.getSolution(row, col);
    final isWrong = digit != correct;
    int mistakes = state.mistakes;
    if (isWrong) mistakes++;

    final updatedCell = cell.copyWith(
      value: digit,
      isError: false,
      pencilMarks: const <int>[],
    );
    var newCells = _replaceCell(board.cells, row, col, updatedCell);

    if (state.autoRemovePencilMarks) {
      newCells = _clearPencilMarkInRowCol(newCells, row, col, digit, board.size);
    }

    final updatedBoard = board.copyWith(cells: newCells);
    final errorCells = _applyErrors(updatedBoard);
    final finalBoard = updatedBoard.copyWith(cells: errorCells);
    state = state.copyWith(board: finalBoard, mistakes: mistakes);
    _highlightCells(row, col);

    if (finalBoard.isComplete) {
      _timer?.cancel();
      state = state.copyWith(status: GameStatus.won);
    }
  }

  void _togglePencilMark(int digit) {
    if (state.status != GameStatus.playing) return;
    final board = state.board;
    if (board == null) return;
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null) return;
    final cell = board.getCell(row, col);
    if (cell.isFixed || cell.isRevealed) return;
    if (cell.value != 0) return;

    final marks = List<int>.from(cell.pencilMarks);
    if (marks.contains(digit)) {
      marks.remove(digit);
    } else {
      marks
        ..add(digit)
        ..sort();
    }

    final updated = cell.copyWith(pencilMarks: marks);
    final newCells = _replaceCell(board.cells, row, col, updated);
    state = state.copyWith(board: board.copyWith(cells: newCells));
  }

  List<List<FutoshikiCell>> _clearPencilMarkInRowCol(
    List<List<FutoshikiCell>> cells,
    int row,
    int col,
    int digit,
    int n,
  ) {
    return List.generate(n, (r) => List.generate(n, (c) {
      if (r == row && c == col) return cells[r][c];
      if (r != row && c != col) return cells[r][c];
      final cell = cells[r][c];
      if (!cell.pencilMarks.contains(digit)) return cell;
      return cell.copyWith(
        pencilMarks: cell.pencilMarks.where((d) => d != digit).toList(),
      );
    }));
  }

  // ── Error application ─────────────────────────────────────────────────────

  List<List<FutoshikiCell>> _applyErrors(
    FutoshikiBoard board, {
    bool force = false,
  }) {
    // Structural checks are gated by their own toggles, independently.
    final rowColErrors = state.showRepeatedDigits
        ? _engine.computeRowColErrors(board)
        : <String>{};
    final constraintErrors = state.showBrokenInequalities
        ? _engine.computeConstraintErrors(board)
        : <String>{};
    // Solution-comparison check: shown when the user turns on showWrongMoves,
    // or when force=true (e.g. checkSolution button).
    final wrongMoveErrors = (force || state.showWrongMoves)
        ? _engine.computeWrongMoveErrors(board)
        : <String>{};

    final visibleErrors = {
      ...rowColErrors,
      ...constraintErrors,
      ...wrongMoveErrors,
    };

    return List.generate(
      board.size,
      (r) => List.generate(
        board.size,
        (c) => board.cells[r][c].copyWith(
          isError: visibleErrors.contains('$r,$c'),
        ),
      ),
    );
  }

  // ── Erase & hint ─────────────────────────────────────────────────────────

  void eraseCell() {
    if (state.status != GameStatus.playing) return;
    final board = state.board;
    if (board == null) return;
    final row = state.selectedRow;
    final col = state.selectedCol;
    if (row == null || col == null) return;
    final cell = board.getCell(row, col);
    if (cell.isFixed || cell.isRevealed) return;

    final updatedCell =
        cell.copyWith(value: 0, isError: false, pencilMarks: const <int>[]);
    final newCells = _replaceCell(board.cells, row, col, updatedCell);
    final updatedBoard = board.copyWith(cells: newCells);
    final errorCells = _applyErrors(updatedBoard);
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
    if (cell.isFixed || cell.isRevealed) return;

    final correct = board.getSolution(row, col);
    final hinted = cell.copyWith(
      value: correct,
      isFixed: true,
      isError: false,
      pencilMarks: const <int>[],
    );
    var newCells = _replaceCell(board.cells, row, col, hinted);
    if (state.autoRemovePencilMarks) {
      newCells =
          _clearPencilMarkInRowCol(newCells, row, col, correct, board.size);
    }
    final updatedBoard = board.copyWith(cells: newCells);
    final errorCells = _applyErrors(updatedBoard);
    final finalBoard = updatedBoard.copyWith(cells: errorCells);
    state = state.copyWith(board: finalBoard);
    _highlightCells(row, col);

    if (finalBoard.isComplete) {
      _timer?.cancel();
      state = state.copyWith(status: GameStatus.won);
    }
  }

  // ── Panel settings toggles ────────────────────────────────────────────────

  void setPlaceMode(PlaceMode mode) =>
      state = state.copyWith(placeMode: mode);

  void toggleShowRepeatedDigits() =>
      state = state.copyWith(showRepeatedDigits: !state.showRepeatedDigits);

  void toggleShowBrokenInequalities() => state =
      state.copyWith(showBrokenInequalities: !state.showBrokenInequalities);

  void toggleShowWrongMoves() =>
      state = state.copyWith(showWrongMoves: !state.showWrongMoves);

  void toggleAutoRemovePencilMarks() => state =
      state.copyWith(autoRemovePencilMarks: !state.autoRemovePencilMarks);

  // ── Check / reset / give-up ──────────────────────────────────────────────

  void checkSolution() {
    final board = state.board;
    if (board == null) return;
    final errorCells = _applyErrors(board, force: true);
    state = state.copyWith(board: board.copyWith(cells: errorCells));
  }

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

  void giveUp() {
    final board = state.board;
    if (board == null) return;
    _timer?.cancel();

    final revealedCells = List.generate(board.size, (r) => List.generate(
      board.size,
      (c) {
        final cell = board.cells[r][c];
        if (cell.isFixed || cell.isRevealed) return cell;
        final correct = board.getSolution(r, c);
        if (cell.value == correct && !cell.isError) return cell;
        return cell.copyWith(
          value: correct,
          isRevealed: true,
          isError: false,
          pencilMarks: const <int>[],
        );
      },
    ));

    state = state.copyWith(
      board: board.copyWith(cells: revealedCells),
      status: GameStatus.gaveUp,
      selectedRow: null,
      selectedCol: null,
    );
  }

  // ── Save / load ───────────────────────────────────────────────────────────

  Future<void> saveGame() async {
    final board = state.board;
    if (board == null) return;
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> save = {
      'gridSize': board.size,
      'difficulty': state.difficulty.name,
      'elapsedSeconds': state.elapsedSeconds,
      'mistakes': state.mistakes,
      'solution': board.solution,
      'constraints': board.constraints
          .map((c) => {
                'r1': c.row1,
                'c1': c.col1,
                'r2': c.row2,
                'c2': c.col2,
                'lt': c.isLessThan,
              })
          .toList(),
      'cells': List.generate(
        board.size,
        (r) => List.generate(board.size, (c) {
          final cell = board.cells[r][c];
          return {
            'v': cell.value,
            'f': cell.isFixed,
            'r': cell.isRevealed,
            'pm': cell.pencilMarks,
          };
        }),
      ),
      'initialCells': List.generate(
        board.size,
        (r) => List.generate(board.size, (c) {
          final cell = state.initialBoard!.cells[r][c];
          return {'v': cell.value, 'f': cell.isFixed};
        }),
      ),
      'settings': {
        'showRepeatedDigits': state.showRepeatedDigits,
        'showBrokenInequalities': state.showBrokenInequalities,
        'showWrongMoves': state.showWrongMoves,
        'autoRemovePencilMarks': state.autoRemovePencilMarks,
      },
    };

    await prefs.setString('saved_game', jsonEncode(save));
  }

  Future<bool> loadSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('saved_game');
    if (raw == null) return false;

    try {
      final Map<String, dynamic> save =
          jsonDecode(raw) as Map<String, dynamic>;
      final n = save['gridSize'] as int;
      final difficulty =
          Difficulty.values.byName(save['difficulty'] as String);

      final solution = (save['solution'] as List)
          .map((row) => (row as List).map((v) => v as int).toList())
          .toList();

      final constraints = (save['constraints'] as List)
          .map((c) => FutoshikiConstraint(
                row1: c['r1'] as int,
                col1: c['c1'] as int,
                row2: c['r2'] as int,
                col2: c['c2'] as int,
                isLessThan: c['lt'] as bool,
              ))
          .toList();

      List<List<FutoshikiCell>> buildCells(List<dynamic> raw) =>
          List.generate(n, (r) => List.generate(n, (c) {
            final d = raw[r][c] as Map<String, dynamic>;
            return FutoshikiCell(
              row: r,
              col: c,
              value: d['v'] as int,
              isFixed: d['f'] as bool,
              isRevealed: (d['r'] as bool?) ?? false,
              pencilMarks:
                  ((d['pm'] as List?)?.map((e) => e as int).toList()) ?? [],
            );
          }));

      final cells = buildCells(save['cells'] as List<dynamic>);
      final initCells = buildCells(save['initialCells'] as List<dynamic>);

      final board = FutoshikiBoard(
        cells: cells,
        solution: solution,
        constraints: constraints,
        size: n,
      );
      final initial = FutoshikiBoard(
        cells: initCells,
        solution: solution,
        constraints: constraints,
        size: n,
      );

      final settings = save['settings'] as Map<String, dynamic>;
      state = state.copyWith(
        board: board,
        initialBoard: initial,
        status: GameStatus.playing,
        difficulty: difficulty,
        gridSize: n,
        elapsedSeconds: save['elapsedSeconds'] as int,
        mistakes: save['mistakes'] as int,
        selectedRow: null,
        selectedCol: null,
        showRepeatedDigits: settings['showRepeatedDigits'] as bool,
        showBrokenInequalities: settings['showBrokenInequalities'] as bool,
        showWrongMoves: settings['showWrongMoves'] as bool,
        autoRemovePencilMarks: settings['autoRemovePencilMarks'] as bool,
        placeMode: PlaceMode.solution,
      );
      _startTimer();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  List<List<FutoshikiCell>> _replaceCell(
    List<List<FutoshikiCell>> cells,
    int row,
    int col,
    FutoshikiCell cell,
  ) {
    return List.generate(
      cells.length,
      (r) => r == row
          ? List.generate(
              cells[r].length, (c) => c == col ? cell : cells[r][c])
          : cells[r],
    );
  }
}
