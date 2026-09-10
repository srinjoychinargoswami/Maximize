import 'package:maximize/models/subtask_model.dart';
import '../models/isar_models.dart';

class SubtaskConverter {
  static IsarSubtask fromSubtaskModel(SubtaskModel model) {
    return IsarSubtask()
      ..subtaskId = model.subtaskId
      ..taskId = model.taskId
      ..title = model.title
      ..completed = model.completed
      ..completedAt = model.completedAt
      ..createdAt = model.createdAt
      ..updatedAt = model.updatedAt;
  }

  static SubtaskModel toSubtaskModel(IsarSubtask isar) {
    return SubtaskModel(
      id: isar.subtaskId,
      subtaskId: isar.subtaskId,
      taskId: isar.taskId,
      title: isar.title,
      completed: isar.completed,
      completedAt: isar.completedAt,
      createdAt: isar.createdAt,
      updatedAt: isar.updatedAt,
    );
  }

  static IsarSubtask fromJson(Map<String, dynamic> json) {
    return IsarSubtask()
      ..subtaskId = json['id'] ?? ''
      ..taskId = json['taskId'] ?? ''
      ..title = json['title'] ?? ''
      ..completed = json['completed'] ?? false
      ..completedAt = json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null
      ..createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now()
      ..updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now();
  }

  static Map<String, dynamic> toJson(IsarSubtask subtask) {
    return {
      'id': subtask.subtaskId,
      'taskId': subtask.taskId,
      'title': subtask.title,
      'completed': subtask.completed,
      'completedAt': subtask.completedAt?.toIso8601String(),
      'createdAt': subtask.createdAt.toIso8601String(),
      'updatedAt': subtask.updatedAt.toIso8601String(),
    };
  }

  // Standard converter methods (toIsar/fromIsar)
  static IsarSubtask toIsar(SubtaskModel model) => fromSubtaskModel(model);
  static SubtaskModel fromIsar(IsarSubtask isar) => toSubtaskModel(isar);
}
