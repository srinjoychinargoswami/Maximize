// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      completed: json['completed'] as bool? ?? false,
      category: json['category'] as String?,
      priority: json['priority'] as String,
      customCategory: json['customCategory'] as String?,
      pageId: json['pageId'] as String?,
      day: json['day'] as String?,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate.toIso8601String(),
      'completed': instance.completed,
      'category': instance.category,
      'priority': instance.priority,
      'customCategory': instance.customCategory,
      'pageId': instance.pageId,
      'day': instance.day,
    };

SubtaskModel _$SubtaskModelFromJson(Map<String, dynamic> json) => SubtaskModel(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$SubtaskModelToJson(SubtaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'title': instance.title,
      'completed': instance.completed,
    };
