import 'package:freezed_annotation/freezed_annotation.dart';
import 'board.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

enum GameStatus { initial, loading, playing, won, breakTime, gaveUp }

enum Difficulty { easy, medium }

enum PlaceMode { solution, pencilMarks }

@freezed
class GameState with _$GameState {
  const factory GameState({
    FutoshikiBoard? board,
    @Default(GameStatus.initial) GameStatus status,
    @Default(Difficulty.easy) Difficulty difficulty,
    @Default(5) int gridSize,
    @Default(0) int elapsedSeconds,
    @Default(0) int playSecondsThisSegment,
    @Default(0) int mistakes,
    int? selectedRow,
    int? selectedCol,
    @Default(PlaceMode.solution) PlaceMode placeMode,
    @Default(true) bool showRepeatedDigits,
    @Default(true) bool showBrokenInequalities,
    @Default(false) bool showWrongMoves,
    @Default(true) bool autoRemovePencilMarks,
    FutoshikiBoard? initialBoard,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
