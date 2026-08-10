import 'package:freezed_annotation/freezed_annotation.dart';

part 'constraint.freezed.dart';
part 'constraint.g.dart';

@freezed
class FutoshikiConstraint with _$FutoshikiConstraint {
  const FutoshikiConstraint._();

  const factory FutoshikiConstraint({
    required int row1,
    required int col1,
    required int row2,
    required int col2,
    required bool isLessThan,
  }) = _FutoshikiConstraint;

  factory FutoshikiConstraint.fromJson(Map<String, dynamic> json) =>
      _$FutoshikiConstraintFromJson(json);

  bool get isHorizontal => row1 == row2;
  bool get isVertical => col1 == col2;
}
