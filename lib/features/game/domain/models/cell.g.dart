// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FutoshikiCellImpl _$$FutoshikiCellImplFromJson(Map<String, dynamic> json) =>
    _$FutoshikiCellImpl(
      row: (json['row'] as num).toInt(),
      col: (json['col'] as num).toInt(),
      value: (json['value'] as num?)?.toInt() ?? 0,
      isFixed: json['isFixed'] as bool? ?? false,
      isSelected: json['isSelected'] as bool? ?? false,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      isSameDigit: json['isSameDigit'] as bool? ?? false,
      isError: json['isError'] as bool? ?? false,
      pencilMarks: (json['pencilMarks'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      isRevealed: json['isRevealed'] as bool? ?? false,
    );

Map<String, dynamic> _$$FutoshikiCellImplToJson(_$FutoshikiCellImpl instance) =>
    <String, dynamic>{
      'row': instance.row,
      'col': instance.col,
      'value': instance.value,
      'isFixed': instance.isFixed,
      'isSelected': instance.isSelected,
      'isHighlighted': instance.isHighlighted,
      'isSameDigit': instance.isSameDigit,
      'isError': instance.isError,
      'pencilMarks': instance.pencilMarks,
      'isRevealed': instance.isRevealed,
    };
