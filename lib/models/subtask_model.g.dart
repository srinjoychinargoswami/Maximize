// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubtaskModel _$SubtaskModelFromJson(Map<String, dynamic> json) => SubtaskModel(
      id: json['id'] as String?,
      subtaskId: json['subtaskId'] as String?,
      taskId: json['taskId'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SubtaskModelToJson(SubtaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subtaskId': instance.subtaskId,
      'taskId': instance.taskId,
      'title': instance.title,
      'completed': instance.completed,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
