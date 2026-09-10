import 'package:isar/isar.dart';
import '../isar_database_service.dart';
import '../models/isar_models.dart';

class TaskDAO {
  Future<void> insertTask(IsarTask task) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.tasks.put(task);
    });
  }

  Future<List<IsarTask>> getAllTasks() async {
    return await IsarDatabaseService.tasks.where().findAll();
  }

  Future<IsarTask?> getTaskById(String taskId) async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    try {
      return tasks.firstWhere((task) => task.taskId == taskId);
    } catch (e) {
      return null;
    }
  }

  Future<List<IsarTask>> getUncompletedTasks() async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    return tasks.where((task) => !task.completed).toList();
  }

  Future<List<IsarTask>> getCompletedTasks() async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    return tasks.where((task) => task.completed).toList();
  }

  Future<List<IsarTask>> getRecurringTasks() async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    return tasks.where((task) => task.isRecurring).toList();
  }

  Future<List<IsarTask>> getBaseTasks() async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    return tasks.where((task) => task.parentTaskId == null).toList();
  }

  Future<List<IsarTask>> getTasksInRange(DateTime start, DateTime end) async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    return tasks.where((task) {
      final dueDate = task.dueDate;
      return dueDate != null &&
             dueDate.isAfter(start) &&
             dueDate.isBefore(end);
    }).toList();
  }

  Future<void> updateTask(IsarTask task) async {
    await IsarDatabaseService.db.writeTxn(() async {
      await IsarDatabaseService.tasks.put(task);
    });
  }

  Future<void> deleteTask(String taskId) async {
    final task = await getTaskById(taskId);
    if (task != null) {
      await IsarDatabaseService.db.writeTxn(() async {
        await IsarDatabaseService.tasks.delete(task.id!);
      });
    }
  }

  Future<void> deleteTaskSeries(String parentTaskId) async {
    final parent = await getTaskById(parentTaskId);
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    final children = tasks.where((task) => task.parentTaskId == parentTaskId).toList();

    await IsarDatabaseService.db.writeTxn(() async {
      if (parent != null) {
        await IsarDatabaseService.tasks.delete(parent.id!);
      }
      for (final child in children) {
        await IsarDatabaseService.tasks.delete(child.id!);
      }
    });
  }

  Future<int> countAllTasks() async {
    return await IsarDatabaseService.tasks.count();
  }

  Future<int> countCompletedTasks() async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    return tasks.where((task) => task.completed).length;
  }

  Future<int> countUncompletedTasks() async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    return tasks.where((task) => !task.completed).length;
  }

  Future<void> updateRecurringTaskSeries({
    required String parentTaskId,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? customCategory,
    bool updateFutureOnly = true,
  }) async {
    final tasks = await IsarDatabaseService.tasks.where().findAll();
    final childTasks = tasks.where((task) => task.parentTaskId == parentTaskId).toList();

    await IsarDatabaseService.db.writeTxn(() async {
      for (final task in childTasks) {
        if (updateFutureOnly && task.dueDate != null) {
          if (task.dueDate!.isBefore(DateTime.now())) {
            continue;
          }
        }
        task.title = title ?? task.title;
        task.description = description ?? task.description;
        task.category = category ?? task.category;
        task.priority = priority ?? task.priority;
        task.customCategory = customCategory ?? task.customCategory;
        await IsarDatabaseService.tasks.put(task);
      }
    });
  }
}
