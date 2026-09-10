import 'package:maximize/models/task_model.dart';
import '../models/isar_models.dart';

class TaskConverter {
  static IsarTask fromTaskModel(TaskModel model) {
    return IsarTask()
      ..taskId = model.id
      ..title = model.title
      ..description = model.description
      ..dueDate = model.dueDate
      ..completed = model.completed
      ..completedAt = model.completedAt
      ..category = model.category
      ..priority = model.priority
      ..customCategory = model.customCategory
      ..pageId = model.pageId
      ..day = model.day
      ..isRecurring = model.isRecurring
      ..recurrenceRule = model.recurrenceRule
      ..recurrenceInterval = model.recurrenceInterval
      ..daysOfWeek = model.daysOfWeek != null ? model.daysOfWeek!.map((d) => d.toString()).join(',') : null
      ..recurrenceEndDate = model.recurrenceEndDate
      ..parentTaskId = model.parentTaskId
      ..maxOccurrences = model.maxOccurrences
      ..skipWeekends = model.skipWeekends
      ..dayOfMonth = model.dayOfMonth
      ..weekOfMonth = model.weekOfMonth
      ..reminderEnabled = model.reminderEnabled ?? false
      ..reminderTime = model.reminderTime
      ..reminderPreset = model.reminderPreset
      ..createdAt = model.createdAt
      ..updatedAt = model.updatedAt;
  }

  static TaskModel toTaskModel(IsarTask isar) {
    return TaskModel(
      id: isar.taskId,
      title: isar.title,
      description: isar.description,
      dueDate: isar.dueDate ?? DateTime.now(),
      completed: isar.completed,
      completedAt: isar.completedAt,
      category: isar.category,
      priority: isar.priority,
      customCategory: isar.customCategory,
      pageId: isar.pageId,
      day: isar.day,
      isRecurring: isar.isRecurring,
      recurrenceRule: isar.recurrenceRule,
      recurrenceInterval: isar.recurrenceInterval,
      daysOfWeek: isar.daysOfWeek?.split(',')
          .where((d) => d.isNotEmpty)
          .map((d) => int.parse(d))
          .toList(),
      recurrenceEndDate: isar.recurrenceEndDate,
      parentTaskId: isar.parentTaskId,
      maxOccurrences: isar.maxOccurrences,
      skipWeekends: isar.skipWeekends,
      dayOfMonth: isar.dayOfMonth,
      weekOfMonth: isar.weekOfMonth,
      reminderEnabled: isar.reminderEnabled,
      reminderTime: isar.reminderTime,
      reminderPreset: isar.reminderPreset,
      createdAt: isar.createdAt,
      updatedAt: isar.updatedAt,
    );
  }

  static IsarTask fromJson(Map<String, dynamic> json) {
    return IsarTask()
      ..taskId = json['id'] ?? ''
      ..title = json['title'] ?? ''
      ..description = json['description']
      ..dueDate = json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null
      ..completed = json['completed'] ?? false
      ..completedAt = json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null
      ..category = json['category']
      ..priority = json['priority'] ?? 'Low'
      ..customCategory = json['customCategory']
      ..pageId = json['pageId']
      ..day = json['day']
      ..isRecurring = json['isRecurring'] ?? false
      ..recurrenceRule = json['recurrenceRule']
      ..recurrenceInterval = json['recurrenceInterval']
      ..daysOfWeek = json['daysOfWeek']
      ..recurrenceEndDate = json['recurrenceEndDate'] != null ? DateTime.parse(json['recurrenceEndDate']) : null
      ..parentTaskId = json['parentTaskId']
      ..maxOccurrences = json['maxOccurrences']
      ..skipWeekends = json['skipWeekends'] ?? false
      ..dayOfMonth = json['dayOfMonth']
      ..weekOfMonth = json['weekOfMonth']
      ..reminderEnabled = json['reminderEnabled'] ?? false
      ..reminderTime = json['reminderTime'] != null ? DateTime.parse(json['reminderTime']) : null
      ..reminderPreset = json['reminderPreset']
      ..createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now()
      ..updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now();
  }

  static Map<String, dynamic> toJson(IsarTask task) {
    return {
      'id': task.taskId,
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate?.toIso8601String(),
      'completed': task.completed,
      'completedAt': task.completedAt?.toIso8601String(),
      'category': task.category,
      'priority': task.priority,
      'customCategory': task.customCategory,
      'pageId': task.pageId,
      'day': task.day,
      'isRecurring': task.isRecurring,
      'recurrenceRule': task.recurrenceRule,
      'recurrenceInterval': task.recurrenceInterval,
      'daysOfWeek': task.daysOfWeek,
      'recurrenceEndDate': task.recurrenceEndDate?.toIso8601String(),
      'parentTaskId': task.parentTaskId,
      'maxOccurrences': task.maxOccurrences,
      'skipWeekends': task.skipWeekends,
      'dayOfMonth': task.dayOfMonth,
      'weekOfMonth': task.weekOfMonth,
      'reminderEnabled': task.reminderEnabled,
      'reminderTime': task.reminderTime?.toIso8601String(),
      'reminderPreset': task.reminderPreset,
      'createdAt': task.createdAt.toIso8601String(),
      'updatedAt': task.updatedAt.toIso8601String(),
    };
  }

  // Standard converter methods (toIsar/fromIsar)
  static IsarTask toIsar(TaskModel model) => fromTaskModel(model);
  static TaskModel fromIsar(IsarTask isar) => toTaskModel(isar);
}
