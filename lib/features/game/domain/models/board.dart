import 'package:freezed_annotation/freezed_annotation.dart';
import 'cell.dart';
import 'constraint.dart';

part 'board.freezed.dart';
part 'board.g.dart';

@freezed
class FutoshikiBoard with _$FutoshikiBoard {
  const FutoshikiBoard._();

  const factory FutoshikiBoard({
    required List<List<FutoshikiCell>> cells,
    required List<List<int>> solution,
    required List<FutoshikiConstraint> constraints,
    required int size,
  }) = _FutoshikiBoard;

  factory FutoshikiBoard.fromJson(Map<String, dynamic> json) =>
      _$FutoshikiBoardFromJson(json);

  FutoshikiCell getCell(int row, int col) => cells[row][col];
  int getSolution(int row, int col) => solution[row][col];

  bool get isComplete {
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (cells[r][c].value != solution[r][c]) return false;
      }
    }
    return true;
  }
}
