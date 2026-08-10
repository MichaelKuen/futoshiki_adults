// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return _GameState.fromJson(json);
}

/// @nodoc
mixin _$GameState {
  FutoshikiBoard? get board => throw _privateConstructorUsedError;
  GameStatus get status => throw _privateConstructorUsedError;
  Difficulty get difficulty => throw _privateConstructorUsedError;
  int get gridSize => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  int get playSecondsThisSegment => throw _privateConstructorUsedError;
  int get mistakes => throw _privateConstructorUsedError;
  int? get selectedRow => throw _privateConstructorUsedError;
  int? get selectedCol => throw _privateConstructorUsedError;
  PlaceMode get placeMode => throw _privateConstructorUsedError;
  bool get showRepeatedDigits => throw _privateConstructorUsedError;
  bool get showBrokenInequalities => throw _privateConstructorUsedError;
  bool get showWrongMoves => throw _privateConstructorUsedError;
  bool get autoRemovePencilMarks => throw _privateConstructorUsedError;
  FutoshikiBoard? get initialBoard => throw _privateConstructorUsedError;

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call(
      {FutoshikiBoard? board,
      GameStatus status,
      Difficulty difficulty,
      int gridSize,
      int elapsedSeconds,
      int playSecondsThisSegment,
      int mistakes,
      int? selectedRow,
      int? selectedCol,
      PlaceMode placeMode,
      bool showRepeatedDigits,
      bool showBrokenInequalities,
      bool showWrongMoves,
      bool autoRemovePencilMarks,
      FutoshikiBoard? initialBoard});

  $FutoshikiBoardCopyWith<$Res>? get board;
  $FutoshikiBoardCopyWith<$Res>? get initialBoard;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = freezed,
    Object? status = null,
    Object? difficulty = null,
    Object? gridSize = null,
    Object? elapsedSeconds = null,
    Object? playSecondsThisSegment = null,
    Object? mistakes = null,
    Object? selectedRow = freezed,
    Object? selectedCol = freezed,
    Object? placeMode = null,
    Object? showRepeatedDigits = null,
    Object? showBrokenInequalities = null,
    Object? showWrongMoves = null,
    Object? autoRemovePencilMarks = null,
    Object? initialBoard = freezed,
  }) {
    return _then(_value.copyWith(
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as FutoshikiBoard?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as Difficulty,
      gridSize: null == gridSize
          ? _value.gridSize
          : gridSize // ignore: cast_nullable_to_non_nullable
              as int,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      playSecondsThisSegment: null == playSecondsThisSegment
          ? _value.playSecondsThisSegment
          : playSecondsThisSegment // ignore: cast_nullable_to_non_nullable
              as int,
      mistakes: null == mistakes
          ? _value.mistakes
          : mistakes // ignore: cast_nullable_to_non_nullable
              as int,
      selectedRow: freezed == selectedRow
          ? _value.selectedRow
          : selectedRow // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCol: freezed == selectedCol
          ? _value.selectedCol
          : selectedCol // ignore: cast_nullable_to_non_nullable
              as int?,
      placeMode: null == placeMode
          ? _value.placeMode
          : placeMode // ignore: cast_nullable_to_non_nullable
              as PlaceMode,
      showRepeatedDigits: null == showRepeatedDigits
          ? _value.showRepeatedDigits
          : showRepeatedDigits // ignore: cast_nullable_to_non_nullable
              as bool,
      showBrokenInequalities: null == showBrokenInequalities
          ? _value.showBrokenInequalities
          : showBrokenInequalities // ignore: cast_nullable_to_non_nullable
              as bool,
      showWrongMoves: null == showWrongMoves
          ? _value.showWrongMoves
          : showWrongMoves // ignore: cast_nullable_to_non_nullable
              as bool,
      autoRemovePencilMarks: null == autoRemovePencilMarks
          ? _value.autoRemovePencilMarks
          : autoRemovePencilMarks // ignore: cast_nullable_to_non_nullable
              as bool,
      initialBoard: freezed == initialBoard
          ? _value.initialBoard
          : initialBoard // ignore: cast_nullable_to_non_nullable
              as FutoshikiBoard?,
    ) as $Val);
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FutoshikiBoardCopyWith<$Res>? get board {
    if (_value.board == null) {
      return null;
    }

    return $FutoshikiBoardCopyWith<$Res>(_value.board!, (value) {
      return _then(_value.copyWith(board: value) as $Val);
    });
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FutoshikiBoardCopyWith<$Res>? get initialBoard {
    if (_value.initialBoard == null) {
      return null;
    }

    return $FutoshikiBoardCopyWith<$Res>(_value.initialBoard!, (value) {
      return _then(_value.copyWith(initialBoard: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FutoshikiBoard? board,
      GameStatus status,
      Difficulty difficulty,
      int gridSize,
      int elapsedSeconds,
      int playSecondsThisSegment,
      int mistakes,
      int? selectedRow,
      int? selectedCol,
      PlaceMode placeMode,
      bool showRepeatedDigits,
      bool showBrokenInequalities,
      bool showWrongMoves,
      bool autoRemovePencilMarks,
      FutoshikiBoard? initialBoard});

  @override
  $FutoshikiBoardCopyWith<$Res>? get board;
  @override
  $FutoshikiBoardCopyWith<$Res>? get initialBoard;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = freezed,
    Object? status = null,
    Object? difficulty = null,
    Object? gridSize = null,
    Object? elapsedSeconds = null,
    Object? playSecondsThisSegment = null,
    Object? mistakes = null,
    Object? selectedRow = freezed,
    Object? selectedCol = freezed,
    Object? placeMode = null,
    Object? showRepeatedDigits = null,
    Object? showBrokenInequalities = null,
    Object? showWrongMoves = null,
    Object? autoRemovePencilMarks = null,
    Object? initialBoard = freezed,
  }) {
    return _then(_$GameStateImpl(
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as FutoshikiBoard?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as Difficulty,
      gridSize: null == gridSize
          ? _value.gridSize
          : gridSize // ignore: cast_nullable_to_non_nullable
              as int,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      playSecondsThisSegment: null == playSecondsThisSegment
          ? _value.playSecondsThisSegment
          : playSecondsThisSegment // ignore: cast_nullable_to_non_nullable
              as int,
      mistakes: null == mistakes
          ? _value.mistakes
          : mistakes // ignore: cast_nullable_to_non_nullable
              as int,
      selectedRow: freezed == selectedRow
          ? _value.selectedRow
          : selectedRow // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCol: freezed == selectedCol
          ? _value.selectedCol
          : selectedCol // ignore: cast_nullable_to_non_nullable
              as int?,
      placeMode: null == placeMode
          ? _value.placeMode
          : placeMode // ignore: cast_nullable_to_non_nullable
              as PlaceMode,
      showRepeatedDigits: null == showRepeatedDigits
          ? _value.showRepeatedDigits
          : showRepeatedDigits // ignore: cast_nullable_to_non_nullable
              as bool,
      showBrokenInequalities: null == showBrokenInequalities
          ? _value.showBrokenInequalities
          : showBrokenInequalities // ignore: cast_nullable_to_non_nullable
              as bool,
      showWrongMoves: null == showWrongMoves
          ? _value.showWrongMoves
          : showWrongMoves // ignore: cast_nullable_to_non_nullable
              as bool,
      autoRemovePencilMarks: null == autoRemovePencilMarks
          ? _value.autoRemovePencilMarks
          : autoRemovePencilMarks // ignore: cast_nullable_to_non_nullable
              as bool,
      initialBoard: freezed == initialBoard
          ? _value.initialBoard
          : initialBoard // ignore: cast_nullable_to_non_nullable
              as FutoshikiBoard?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateImpl implements _GameState {
  const _$GameStateImpl(
      {this.board,
      this.status = GameStatus.initial,
      this.difficulty = Difficulty.easy,
      this.gridSize = 5,
      this.elapsedSeconds = 0,
      this.playSecondsThisSegment = 0,
      this.mistakes = 0,
      this.selectedRow,
      this.selectedCol,
      this.placeMode = PlaceMode.solution,
      this.showRepeatedDigits = true,
      this.showBrokenInequalities = true,
      this.showWrongMoves = false,
      this.autoRemovePencilMarks = true,
      this.initialBoard});

  factory _$GameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateImplFromJson(json);

  @override
  final FutoshikiBoard? board;
  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final Difficulty difficulty;
  @override
  @JsonKey()
  final int gridSize;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final int playSecondsThisSegment;
  @override
  @JsonKey()
  final int mistakes;
  @override
  final int? selectedRow;
  @override
  final int? selectedCol;
  @override
  @JsonKey()
  final PlaceMode placeMode;
  @override
  @JsonKey()
  final bool showRepeatedDigits;
  @override
  @JsonKey()
  final bool showBrokenInequalities;
  @override
  @JsonKey()
  final bool showWrongMoves;
  @override
  @JsonKey()
  final bool autoRemovePencilMarks;
  @override
  final FutoshikiBoard? initialBoard;

  @override
  String toString() {
    return 'GameState(board: $board, status: $status, difficulty: $difficulty, gridSize: $gridSize, elapsedSeconds: $elapsedSeconds, playSecondsThisSegment: $playSecondsThisSegment, mistakes: $mistakes, selectedRow: $selectedRow, selectedCol: $selectedCol, placeMode: $placeMode, showRepeatedDigits: $showRepeatedDigits, showBrokenInequalities: $showBrokenInequalities, showWrongMoves: $showWrongMoves, autoRemovePencilMarks: $autoRemovePencilMarks, initialBoard: $initialBoard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.gridSize, gridSize) ||
                other.gridSize == gridSize) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.playSecondsThisSegment, playSecondsThisSegment) ||
                other.playSecondsThisSegment == playSecondsThisSegment) &&
            (identical(other.mistakes, mistakes) ||
                other.mistakes == mistakes) &&
            (identical(other.selectedRow, selectedRow) ||
                other.selectedRow == selectedRow) &&
            (identical(other.selectedCol, selectedCol) ||
                other.selectedCol == selectedCol) &&
            (identical(other.placeMode, placeMode) ||
                other.placeMode == placeMode) &&
            (identical(other.showRepeatedDigits, showRepeatedDigits) ||
                other.showRepeatedDigits == showRepeatedDigits) &&
            (identical(other.showBrokenInequalities, showBrokenInequalities) ||
                other.showBrokenInequalities == showBrokenInequalities) &&
            (identical(other.showWrongMoves, showWrongMoves) ||
                other.showWrongMoves == showWrongMoves) &&
            (identical(other.autoRemovePencilMarks, autoRemovePencilMarks) ||
                other.autoRemovePencilMarks == autoRemovePencilMarks) &&
            (identical(other.initialBoard, initialBoard) ||
                other.initialBoard == initialBoard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      board,
      status,
      difficulty,
      gridSize,
      elapsedSeconds,
      playSecondsThisSegment,
      mistakes,
      selectedRow,
      selectedCol,
      placeMode,
      showRepeatedDigits,
      showBrokenInequalities,
      showWrongMoves,
      autoRemovePencilMarks,
      initialBoard);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateImplToJson(
      this,
    );
  }
}

abstract class _GameState implements GameState {
  const factory _GameState(
      {final FutoshikiBoard? board,
      final GameStatus status,
      final Difficulty difficulty,
      final int gridSize,
      final int elapsedSeconds,
      final int playSecondsThisSegment,
      final int mistakes,
      final int? selectedRow,
      final int? selectedCol,
      final PlaceMode placeMode,
      final bool showRepeatedDigits,
      final bool showBrokenInequalities,
      final bool showWrongMoves,
      final bool autoRemovePencilMarks,
      final FutoshikiBoard? initialBoard}) = _$GameStateImpl;

  factory _GameState.fromJson(Map<String, dynamic> json) =
      _$GameStateImpl.fromJson;

  @override
  FutoshikiBoard? get board;
  @override
  GameStatus get status;
  @override
  Difficulty get difficulty;
  @override
  int get gridSize;
  @override
  int get elapsedSeconds;
  @override
  int get playSecondsThisSegment;
  @override
  int get mistakes;
  @override
  int? get selectedRow;
  @override
  int? get selectedCol;
  @override
  PlaceMode get placeMode;
  @override
  bool get showRepeatedDigits;
  @override
  bool get showBrokenInequalities;
  @override
  bool get showWrongMoves;
  @override
  bool get autoRemovePencilMarks;
  @override
  FutoshikiBoard? get initialBoard;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
