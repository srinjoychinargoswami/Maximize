// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      completed: json['completed'] as bool? ?? false,
      category: json['category'] as String?,
      priority: json['priority'] as String,
      customCategory: json['customCategory'] as String?,
      pageId: json['pageId'] as String?,
      day: json['day'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrenceRule: json['recurrenceRule'] as String?,
      recurrenceInterval: (json['recurrenceInterval'] as num?)?.toInt(),
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      recurrenceEndDate: json['recurrenceEndDate'] == null
          ? null
          : DateTime.parse(json['recurrenceEndDate'] as String),
      parentTaskId: json['parentTaskId'] as String?,
      maxOccurrences: (json['maxOccurrences'] as num?)?.toInt(),
      skipWeekends: json['skipWeekends'] as bool? ?? false,
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      weekOfMonth: (json['weekOfMonth'] as num?)?.toInt(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      subtasks: (json['subtasks'] as List<dynamic>?)
          ?.map((e) => SubtaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      reminderEnabled: json['reminderEnabled'] as bool?,
      reminderTime: json['reminderTime'] == null
          ? null
          : DateTime.parse(json['reminderTime'] as String),
      reminderPreset: json['reminderPreset'] as String?,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate.toIso8601String(),
      'completed': instance.completed,
      'category': instance.category,
      'priority': instance.priority,
      'customCategory': instance.customCategory,
      'pageId': instance.pageId,
      'day': instance.day,
      'isRecurring': instance.isRecurring,
      'recurrenceRule': instance.recurrenceRule,
      'recurrenceInterval': instance.recurrenceInterval,
      'daysOfWeek': instance.daysOfWeek,
      'recurrenceEndDate': instance.recurrenceEndDate?.toIso8601String(),
      'parentTaskId': instance.parentTaskId,
      'maxOccurrences': instance.maxOccurrences,
      'skipWeekends': instance.skipWeekends,
      'dayOfMonth': instance.dayOfMonth,
      'weekOfMonth': instance.weekOfMonth,
      'completedAt': instance.completedAt?.toIso8601String(),
      'subtasks': instance.subtasks,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'reminderEnabled': instance.reminderEnabled,
      'reminderTime': instance.reminderTime?.toIso8601String(),
      'reminderPreset': instance.reminderPreset,
    };
