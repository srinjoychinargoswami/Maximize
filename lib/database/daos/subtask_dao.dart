import 'package:isar/isar.dart';
import '../isar_database_service.dart';
import '../models/isar_models.dart';

class SubtaskDAO {
  Future<void> insertSubtask(IsarSubtask subtask) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.subtasks.put(subtask);
    });
  }

  Future<List<IsarSubtask>> getAllSubtasks(String taskId) async {
    final subtasks = await IsarDatabaseService.subtasks.where().findAll();
    return subtasks.where((subtask) => subtask.taskId == taskId).toList();
  }

  Future<IsarSubtask?> getSubtaskById(String subtaskId) async {
    final subtasks = await IsarDatabaseService.subtasks.where().findAll();
    try {
      return subtasks.firstWhere((subtask) => subtask.subtaskId == subtaskId);
    } catch (e) {
      return null;
    }
  }

  Future<List<IsarSubtask>> getCompletedSubtasks(String taskId) async {
    final subtasks = await IsarDatabaseService.subtasks.where().findAll();
    return subtasks.where((subtask) =>
      subtask.taskId == taskId && subtask.completed
    ).toList();
  }

  Future<List<IsarSubtask>> getUncompletedSubtasks(String taskId) async {
    final subtasks = await IsarDatabaseService.subtasks.where().findAll();
    return subtasks.where((subtask) =>
      subtask.taskId == taskId && !subtask.completed
    ).toList();
  }

  Future<void> updateSubtask(IsarSubtask subtask) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.subtasks.put(subtask);
    });
  }

  Future<void> deleteSubtask(String subtaskId) async {
    final subtask = await getSubtaskById(subtaskId);
    if (subtask != null) {
      await IsarDatabaseService.db.writeTxn(() async {
        await IsarDatabaseService.subtasks.delete(subtask.id!);
      });
    }
  }

  Future<void> deleteSubtasksByTaskId(String taskId) async {
    final subtasks = await getAllSubtasks(taskId);
    await IsarDatabaseService.db.writeTxn(() async {
      for (final subtask in subtasks) {
        await IsarDatabaseService.subtasks.delete(subtask.id!);
      }
    });
  }

  Future<int> countSubtasks(String taskId) async {
    final subtasks = await IsarDatabaseService.subtasks.where().findAll();
    return subtasks.where((subtask) => subtask.taskId == taskId).length;
  }

  Future<int> countCompletedSubtasks(String taskId) async {
    final subtasks = await IsarDatabaseService.subtasks.where().findAll();
    return subtasks.where((subtask) =>
      subtask.taskId == taskId && subtask.completed
    ).length;
  }

  // Alias for consistency
  Future<List<IsarSubtask>> getSubtasksByTaskId(String taskId) =>
      getAllSubtasks(taskId);
}
