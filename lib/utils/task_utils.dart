import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/database.dart';

// Conversion utilities for TaskModel

TaskData convertTaskModelToData(TaskModel taskModel) {
  return TaskData(
    id: taskModel.id,
    title: taskModel.title,
    description: taskModel.description,
    dueDate: taskModel.dueDate,
    completed: taskModel.completed,
    category: taskModel.category,
    priority: taskModel.priority,
    customCategory: taskModel.customCategory,
    pageId: taskModel.pageId,
    day: taskModel.day,
    isRecurring: taskModel.isRecurring,
    recurrenceRule: taskModel.recurrenceRule,
    recurrenceInterval: taskModel.recurrenceInterval,
    daysOfWeek: taskModel.daysOfWeek != null ? taskModel.daysOfWeek!.map((d) => d.toString()).join(',') : null,
    recurrenceEndDate: taskModel.recurrenceEndDate,
    parentTaskId: taskModel.parentTaskId,
    maxOccurrences: taskModel.maxOccurrences,
    skipWeekends: taskModel.skipWeekends,
    dayOfMonth: taskModel.dayOfMonth,
    weekOfMonth: taskModel.weekOfMonth,
    completedAt: taskModel.completedAt,
    reminderEnabled: taskModel.reminderEnabled,
    reminderTime: taskModel.reminderTime,
    reminderPreset: taskModel.reminderPreset,
  );
}

TaskModel convertDataToTaskModel(TaskData data) {
  return TaskModel.fromData(data);
}
