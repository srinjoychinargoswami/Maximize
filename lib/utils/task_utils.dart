import 'package:maximize/models/database.dart'; // Import your Drift database file
import 'package:maximize/models/task_model.dart';

// Inside task_utils.dart
TaskModel convertTaskDataToModel(TaskData taskData) {
  return TaskModel(
    id: taskData.id,
    title: taskData.title,
    description: taskData.description,
    dueDate: taskData.dueDate,
    completed: taskData.completed,
    completedAt: taskData.completedAt, // ADDED: Completion timestamp
    category: taskData.category,
    priority: taskData.priority,
    customCategory: taskData.customCategory,
    pageId: taskData.pageId,
    day: taskData.day,
    // Recurring task fields
    isRecurring: taskData.isRecurring,
    recurrenceRule: taskData.recurrenceRule,
    recurrenceInterval: taskData.recurrenceInterval,
    daysOfWeek: taskData.daysOfWeek?.split(',').map((e) => int.tryParse(e.trim())).where((e) => e != null).cast<int>().toList(),
    recurrenceEndDate: taskData.recurrenceEndDate,
    parentTaskId: taskData.parentTaskId,
    maxOccurrences: taskData.maxOccurrences,
    skipWeekends: taskData.skipWeekends,
    dayOfMonth: taskData.dayOfMonth,
    weekOfMonth: taskData.weekOfMonth,
    // Reminder fields
    reminderEnabled: taskData.reminderEnabled,
    reminderTime: taskData.reminderTime,
    reminderPreset: taskData.reminderPreset,
  );
}

TaskData convertTaskModelToData(TaskModel taskModel) {
  return TaskData(
    id: taskModel.id,
    title: taskModel.title,
    description: taskModel.description,
    dueDate: taskModel.dueDate,
    completed: taskModel.completed,
    completedAt: taskModel.completedAt, // ADDED: Completion timestamp
    category: taskModel.category,
    priority: taskModel.priority,
    customCategory: taskModel.customCategory,
    pageId: taskModel.pageId,
    day: taskModel.day,
    // Recurring task fields
    isRecurring: taskModel.isRecurring,
    recurrenceRule: taskModel.recurrenceRule,
    recurrenceInterval: taskModel.recurrenceInterval,
    daysOfWeek: taskModel.daysOfWeek?.join(','), // Convert List<int> to comma-separated string
    recurrenceEndDate: taskModel.recurrenceEndDate,
    parentTaskId: taskModel.parentTaskId,
    maxOccurrences: taskModel.maxOccurrences,
    skipWeekends: taskModel.skipWeekends,
    dayOfMonth: taskModel.dayOfMonth,
    weekOfMonth: taskModel.weekOfMonth,
    // NEW: Reminder fields
    reminderEnabled: taskModel.reminderEnabled ?? false,
    reminderTime: taskModel.reminderTime,
    reminderPreset: taskModel.reminderPreset,
  );
}
