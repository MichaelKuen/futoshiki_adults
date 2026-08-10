import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell.freezed.dart';
part 'cell.g.dart';

@freezed
class FutoshikiCell with _$FutoshikiCell {
  const factory FutoshikiCell({
    required int row,
    required int col,
    @Default(0) int value,
    @Default(false) bool isFixed,
    @Default(false) bool isSelected,
    @Default(false) bool isHighlighted,
    @Default(false) bool isSameDigit,
    @Default(false) bool isError,
    @Default(<int>[]) List<int> pencilMarks,
    @Default(false) bool isRevealed,
  }) = _FutoshikiCell;

  factory FutoshikiCell.fromJson(Map<String, dynamic> json) =>
      _$FutoshikiCellFromJson(json);
}
