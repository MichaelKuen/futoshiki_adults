// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FutoshikiBoard _$FutoshikiBoardFromJson(Map<String, dynamic> json) {
  return _FutoshikiBoard.fromJson(json);
}

/// @nodoc
mixin _$FutoshikiBoard {
  List<List<FutoshikiCell>> get cells => throw _privateConstructorUsedError;
  List<List<int>> get solution => throw _privateConstructorUsedError;
  List<FutoshikiConstraint> get constraints =>
      throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;

  /// Serializes this FutoshikiBoard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FutoshikiBoard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FutoshikiBoardCopyWith<FutoshikiBoard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FutoshikiBoardCopyWith<$Res> {
  factory $FutoshikiBoardCopyWith(
          FutoshikiBoard value, $Res Function(FutoshikiBoard) then) =
      _$FutoshikiBoardCopyWithImpl<$Res, FutoshikiBoard>;
  @useResult
  $Res call(
      {List<List<FutoshikiCell>> cells,
      List<List<int>> solution,
      List<FutoshikiConstraint> constraints,
      int size});
}

/// @nodoc
class _$FutoshikiBoardCopyWithImpl<$Res, $Val extends FutoshikiBoard>
    implements $FutoshikiBoardCopyWith<$Res> {
  _$FutoshikiBoardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FutoshikiBoard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cells = null,
    Object? solution = null,
    Object? constraints = null,
    Object? size = null,
  }) {
    return _then(_value.copyWith(
      cells: null == cells
          ? _value.cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<List<FutoshikiCell>>,
      solution: null == solution
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      constraints: null == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as List<FutoshikiConstraint>,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FutoshikiBoardImplCopyWith<$Res>
    implements $FutoshikiBoardCopyWith<$Res> {
  factory _$$FutoshikiBoardImplCopyWith(_$FutoshikiBoardImpl value,
          $Res Function(_$FutoshikiBoardImpl) then) =
      __$$FutoshikiBoardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<List<FutoshikiCell>> cells,
      List<List<int>> solution,
      List<FutoshikiConstraint> constraints,
      int size});
}

/// @nodoc
class __$$FutoshikiBoardImplCopyWithImpl<$Res>
    extends _$FutoshikiBoardCopyWithImpl<$Res, _$FutoshikiBoardImpl>
    implements _$$FutoshikiBoardImplCopyWith<$Res> {
  __$$FutoshikiBoardImplCopyWithImpl(
      _$FutoshikiBoardImpl _value, $Res Function(_$FutoshikiBoardImpl) _then)
      : super(_value, _then);

  /// Create a copy of FutoshikiBoard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cells = null,
    Object? solution = null,
    Object? constraints = null,
    Object? size = null,
  }) {
    return _then(_$FutoshikiBoardImpl(
      cells: null == cells
          ? _value._cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<List<FutoshikiCell>>,
      solution: null == solution
          ? _value._solution
          : solution // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      constraints: null == constraints
          ? _value._constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as List<FutoshikiConstraint>,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FutoshikiBoardImpl extends _FutoshikiBoard {
  const _$FutoshikiBoardImpl(
      {required final List<List<FutoshikiCell>> cells,
      required final List<List<int>> solution,
      required final List<FutoshikiConstraint> constraints,
      required this.size})
      : _cells = cells,
        _solution = solution,
        _constraints = constraints,
        super._();

  factory _$FutoshikiBoardImpl.fromJson(Map<String, dynamic> json) =>
      _$$FutoshikiBoardImplFromJson(json);

  final List<List<FutoshikiCell>> _cells;
  @override
  List<List<FutoshikiCell>> get cells {
    if (_cells is EqualUnmodifiableListView) return _cells;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cells);
  }

  final List<List<int>> _solution;
  @override
  List<List<int>> get solution {
    if (_solution is EqualUnmodifiableListView) return _solution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_solution);
  }

  final List<FutoshikiConstraint> _constraints;
  @override
  List<FutoshikiConstraint> get constraints {
    if (_constraints is EqualUnmodifiableListView) return _constraints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_constraints);
  }

  @override
  final int size;

  @override
  String toString() {
    return 'FutoshikiBoard(cells: $cells, solution: $solution, constraints: $constraints, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FutoshikiBoardImpl &&
            const DeepCollectionEquality().equals(other._cells, _cells) &&
            const DeepCollectionEquality().equals(other._solution, _solution) &&
            const DeepCollectionEquality()
                .equals(other._constraints, _constraints) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_cells),
      const DeepCollectionEquality().hash(_solution),
      const DeepCollectionEquality().hash(_constraints),
      size);

  /// Create a copy of FutoshikiBoard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FutoshikiBoardImplCopyWith<_$FutoshikiBoardImpl> get copyWith =>
      __$$FutoshikiBoardImplCopyWithImpl<_$FutoshikiBoardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FutoshikiBoardImplToJson(
      this,
    );
  }
}

abstract class _FutoshikiBoard extends FutoshikiBoard {
  const factory _FutoshikiBoard(
      {required final List<List<FutoshikiCell>> cells,
      required final List<List<int>> solution,
      required final List<FutoshikiConstraint> constraints,
      required final int size}) = _$FutoshikiBoardImpl;
  const _FutoshikiBoard._() : super._();

  factory _FutoshikiBoard.fromJson(Map<String, dynamic> json) =
      _$FutoshikiBoardImpl.fromJson;

  @override
  List<List<FutoshikiCell>> get cells;
  @override
  List<List<int>> get solution;
  @override
  List<FutoshikiConstraint> get constraints;
  @override
  int get size;

  /// Create a copy of FutoshikiBoard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FutoshikiBoardImplCopyWith<_$FutoshikiBoardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
