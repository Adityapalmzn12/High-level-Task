// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      durationInMinutes: (json['durationInMinutes'] as num).toInt(),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      elapsedTime: (json['elapsedTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'durationInMinutes': instance.durationInMinutes,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'elapsedTime': instance.elapsedTime,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.running: 'running',
  TaskStatus.paused: 'paused',
  TaskStatus.completed: 'completed',
};
