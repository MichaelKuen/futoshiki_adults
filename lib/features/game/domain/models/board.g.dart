// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FutoshikiBoardImpl _$$FutoshikiBoardImplFromJson(Map<String, dynamic> json) =>
    _$FutoshikiBoardImpl(
      cells: (json['cells'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => FutoshikiCell.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      solution: (json['solution'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      constraints: (json['constraints'] as List<dynamic>)
          .map((e) => FutoshikiConstraint.fromJson(e as Map<String, dynamic>))
          .toList(),
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$$FutoshikiBoardImplToJson(
        _$FutoshikiBoardImpl instance) =>
    <String, dynamic>{
      'cells': instance.cells,
      'solution': instance.solution,
      'constraints': instance.constraints,
      'size': instance.size,
    };
