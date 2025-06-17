import 'package:maximize/models/database.dart'; // Import your Drift database file
import 'package:maximize/models/task_model.dart';

// Inside task_utils.dart
TaskModel convertTaskDataToModel(TaskData taskData) {
  return TaskModel(
    id: taskData.id,
    name: taskData.name,
    title: taskData.title,
    description: taskData.description,
    dueDate: taskData.dueDate,
    completed: taskData.completed,
    category: taskData.category,
    priority: taskData.priority,
    customCategory: taskData.customCategory,
    pageId: taskData.pageId,
    day: taskData.day,
  );
}

TaskData convertTaskModelToData(TaskModel taskModel) {
  return TaskData(
    id: taskModel.id,
    name: taskModel.name,
    title: taskModel.title,
    description: taskModel.description,
    dueDate: taskModel.dueDate,
    completed: taskModel.completed,
    category: taskModel.category,
    priority: taskModel.priority,
    customCategory: taskModel.customCategory,
    pageId: taskModel.pageId,
    day: taskModel.day,
  );
}