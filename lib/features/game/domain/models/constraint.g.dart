// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constraint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FutoshikiConstraintImpl _$$FutoshikiConstraintImplFromJson(
        Map<String, dynamic> json) =>
    _$FutoshikiConstraintImpl(
      row1: (json['row1'] as num).toInt(),
      col1: (json['col1'] as num).toInt(),
      row2: (json['row2'] as num).toInt(),
      col2: (json['col2'] as num).toInt(),
      isLessThan: json['isLessThan'] as bool,
    );

Map<String, dynamic> _$$FutoshikiConstraintImplToJson(
        _$FutoshikiConstraintImpl instance) =>
    <String, dynamic>{
      'row1': instance.row1,
      'col1': instance.col1,
      'row2': instance.row2,
      'col2': instance.col2,
      'isLessThan': instance.isLessThan,
    };
