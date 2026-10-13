// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      board: json['board'] == null
          ? null
          : FutoshikiBoard.fromJson(json['board'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
          GameStatus.initial,
      difficulty:
          $enumDecodeNullable(_$DifficultyEnumMap, json['difficulty']) ??
              Difficulty.easy,
      gridSize: (json['gridSize'] as num?)?.toInt() ?? 5,
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
      playSecondsThisSegment:
          (json['playSecondsThisSegment'] as num?)?.toInt() ?? 0,
      mistakes: (json['mistakes'] as num?)?.toInt() ?? 0,
      selectedRow: (json['selectedRow'] as num?)?.toInt(),
      selectedCol: (json['selectedCol'] as num?)?.toInt(),
      placeMode: $enumDecodeNullable(_$PlaceModeEnumMap, json['placeMode']) ??
          PlaceMode.solution,
      showRepeatedDigits: json['showRepeatedDigits'] as bool? ?? true,
      showBrokenInequalities: json['showBrokenInequalities'] as bool? ?? true,
      showWrongMoves: json['showWrongMoves'] as bool? ?? false,
      autoRemovePencilMarks: json['autoRemovePencilMarks'] as bool? ?? true,
      initialBoard: json['initialBoard'] == null
          ? null
          : FutoshikiBoard.fromJson(
              json['initialBoard'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'board': instance.board,
      'status': _$GameStatusEnumMap[instance.status]!,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'gridSize': instance.gridSize,
      'elapsedSeconds': instance.elapsedSeconds,
      'playSecondsThisSegment': instance.playSecondsThisSegment,
      'mistakes': instance.mistakes,
      'selectedRow': instance.selectedRow,
      'selectedCol': instance.selectedCol,
      'placeMode': _$PlaceModeEnumMap[instance.placeMode]!,
      'showRepeatedDigits': instance.showRepeatedDigits,
      'showBrokenInequalities': instance.showBrokenInequalities,
      'showWrongMoves': instance.showWrongMoves,
      'autoRemovePencilMarks': instance.autoRemovePencilMarks,
      'initialBoard': instance.initialBoard,
    };

const _$GameStatusEnumMap = {
  GameStatus.initial: 'initial',
  GameStatus.loading: 'loading',
  GameStatus.playing: 'playing',
  GameStatus.won: 'won',
  GameStatus.gaveUp: 'gaveUp',
};

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.medium: 'medium',
  Difficulty.advanced: 'advanced',
  Difficulty.expert: 'expert',
  Difficulty.insane: 'insane',
};

const _$PlaceModeEnumMap = {
  PlaceMode.solution: 'solution',
  PlaceMode.pencilMarks: 'pencilMarks',
};
