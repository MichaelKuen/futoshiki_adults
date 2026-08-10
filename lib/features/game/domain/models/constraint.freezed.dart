// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'constraint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FutoshikiConstraint _$FutoshikiConstraintFromJson(Map<String, dynamic> json) {
  return _FutoshikiConstraint.fromJson(json);
}

/// @nodoc
mixin _$FutoshikiConstraint {
  int get row1 => throw _privateConstructorUsedError;
  int get col1 => throw _privateConstructorUsedError;
  int get row2 => throw _privateConstructorUsedError;
  int get col2 => throw _privateConstructorUsedError;
  bool get isLessThan => throw _privateConstructorUsedError;

  /// Serializes this FutoshikiConstraint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FutoshikiConstraint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FutoshikiConstraintCopyWith<FutoshikiConstraint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FutoshikiConstraintCopyWith<$Res> {
  factory $FutoshikiConstraintCopyWith(
          FutoshikiConstraint value, $Res Function(FutoshikiConstraint) then) =
      _$FutoshikiConstraintCopyWithImpl<$Res, FutoshikiConstraint>;
  @useResult
  $Res call({int row1, int col1, int row2, int col2, bool isLessThan});
}

/// @nodoc
class _$FutoshikiConstraintCopyWithImpl<$Res, $Val extends FutoshikiConstraint>
    implements $FutoshikiConstraintCopyWith<$Res> {
  _$FutoshikiConstraintCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FutoshikiConstraint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? row1 = null,
    Object? col1 = null,
    Object? row2 = null,
    Object? col2 = null,
    Object? isLessThan = null,
  }) {
    return _then(_value.copyWith(
      row1: null == row1
          ? _value.row1
          : row1 // ignore: cast_nullable_to_non_nullable
              as int,
      col1: null == col1
          ? _value.col1
          : col1 // ignore: cast_nullable_to_non_nullable
              as int,
      row2: null == row2
          ? _value.row2
          : row2 // ignore: cast_nullable_to_non_nullable
              as int,
      col2: null == col2
          ? _value.col2
          : col2 // ignore: cast_nullable_to_non_nullable
              as int,
      isLessThan: null == isLessThan
          ? _value.isLessThan
          : isLessThan // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FutoshikiConstraintImplCopyWith<$Res>
    implements $FutoshikiConstraintCopyWith<$Res> {
  factory _$$FutoshikiConstraintImplCopyWith(_$FutoshikiConstraintImpl value,
          $Res Function(_$FutoshikiConstraintImpl) then) =
      __$$FutoshikiConstraintImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int row1, int col1, int row2, int col2, bool isLessThan});
}

/// @nodoc
class __$$FutoshikiConstraintImplCopyWithImpl<$Res>
    extends _$FutoshikiConstraintCopyWithImpl<$Res, _$FutoshikiConstraintImpl>
    implements _$$FutoshikiConstraintImplCopyWith<$Res> {
  __$$FutoshikiConstraintImplCopyWithImpl(_$FutoshikiConstraintImpl _value,
      $Res Function(_$FutoshikiConstraintImpl) _then)
      : super(_value, _then);

  /// Create a copy of FutoshikiConstraint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? row1 = null,
    Object? col1 = null,
    Object? row2 = null,
    Object? col2 = null,
    Object? isLessThan = null,
  }) {
    return _then(_$FutoshikiConstraintImpl(
      row1: null == row1
          ? _value.row1
          : row1 // ignore: cast_nullable_to_non_nullable
              as int,
      col1: null == col1
          ? _value.col1
          : col1 // ignore: cast_nullable_to_non_nullable
              as int,
      row2: null == row2
          ? _value.row2
          : row2 // ignore: cast_nullable_to_non_nullable
              as int,
      col2: null == col2
          ? _value.col2
          : col2 // ignore: cast_nullable_to_non_nullable
              as int,
      isLessThan: null == isLessThan
          ? _value.isLessThan
          : isLessThan // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FutoshikiConstraintImpl extends _FutoshikiConstraint {
  const _$FutoshikiConstraintImpl(
      {required this.row1,
      required this.col1,
      required this.row2,
      required this.col2,
      required this.isLessThan})
      : super._();

  factory _$FutoshikiConstraintImpl.fromJson(Map<String, dynamic> json) =>
      _$$FutoshikiConstraintImplFromJson(json);

  @override
  final int row1;
  @override
  final int col1;
  @override
  final int row2;
  @override
  final int col2;
  @override
  final bool isLessThan;

  @override
  String toString() {
    return 'FutoshikiConstraint(row1: $row1, col1: $col1, row2: $row2, col2: $col2, isLessThan: $isLessThan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FutoshikiConstraintImpl &&
            (identical(other.row1, row1) || other.row1 == row1) &&
            (identical(other.col1, col1) || other.col1 == col1) &&
            (identical(other.row2, row2) || other.row2 == row2) &&
            (identical(other.col2, col2) || other.col2 == col2) &&
            (identical(other.isLessThan, isLessThan) ||
                other.isLessThan == isLessThan));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, row1, col1, row2, col2, isLessThan);

  /// Create a copy of FutoshikiConstraint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FutoshikiConstraintImplCopyWith<_$FutoshikiConstraintImpl> get copyWith =>
      __$$FutoshikiConstraintImplCopyWithImpl<_$FutoshikiConstraintImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FutoshikiConstraintImplToJson(
      this,
    );
  }
}

abstract class _FutoshikiConstraint extends FutoshikiConstraint {
  const factory _FutoshikiConstraint(
      {required final int row1,
      required final int col1,
      required final int row2,
      required final int col2,
      required final bool isLessThan}) = _$FutoshikiConstraintImpl;
  const _FutoshikiConstraint._() : super._();

  factory _FutoshikiConstraint.fromJson(Map<String, dynamic> json) =
      _$FutoshikiConstraintImpl.fromJson;

  @override
  int get row1;
  @override
  int get col1;
  @override
  int get row2;
  @override
  int get col2;
  @override
  bool get isLessThan;

  /// Create a copy of FutoshikiConstraint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FutoshikiConstraintImplCopyWith<_$FutoshikiConstraintImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
