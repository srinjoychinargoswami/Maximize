import 'package:kinetic/database/app_database.dart';
import 'package:kinetic/models/task_model.dart';
import 'package:kinetic/models/subtask_model.dart';
import 'package:kinetic/models/reminder_model.dart';
import 'package:kinetic/services/completion_log_service.dart';
import 'package:kinetic/services/energy_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

class TaskService {
  final AppDatabase _database;

  TaskService(this._database);

  Future<List<TaskModel>> getTasks() async {
    try {
      final rows = await _database.select(_database.tasks).get();
      return rows.map(_rowToModel).toList();
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
      return [];
    }
  }

  Future<List<TaskModel>> getTasksFiltered({
    bool? completed,
    String? category,
    String? priority,
    DateTime? dueDate,
  }) async {
    try {
      final allTasks = await getTasks();
      return allTasks.where((task) {
        if (completed != null && task.completed != completed) return false;
        if (category != null && task.category != category) return false;
        if (priority != null && task.priority != priority) return false;
        if (dueDate != null && !_isSameDay(task.dueDate, dueDate)) return false;
        return true;
      }).toList();
    } catch (e) {
      debugPrint('Error fetching filtered tasks: $e');
      return [];
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Future<int?> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required bool completed,
    required String category,
    required String priority,
    int? pageId,
    DateTime? completedAt,
    List<SubtaskModel>? subtasks,
    bool isRecurring = false,
    String? recurrenceRule,
    int? recurrenceInterval,
    List<int>? daysOfWeek,
    DateTime? recurrenceEndDate,
    String? parentTaskId,
    int? maxOccurrences,
    bool skipWeekends = false,
    int? dayOfMonth,
    int? weekOfMonth,
    bool reminderEnabled = false,
    DateTime? reminderTime,
    String? reminderPreset,
  }) async {
    final taskId = const Uuid().v1();
    final now = DateTime.now();

    final task = TaskModel(
      id: taskId,
      title: title,
      description: description,
      dueDate: dueDate,
      completed: completed,
      category: category,
      priority: priority,
      pageId: pageId?.toString(),
      completedAt: completedAt,
      subtasks: subtasks,
      isRecurring: isRecurring,
      recurrenceRule: recurrenceRule,
      recurrenceInterval: recurrenceInterval,
      daysOfWeek: daysOfWeek,
      recurrenceEndDate: recurrenceEndDate,
      parentTaskId: parentTaskId,
      maxOccurrences: maxOccurrences,
      skipWeekends: skipWeekends,
      dayOfMonth: dayOfMonth,
      weekOfMonth: weekOfMonth,
      reminderEnabled: reminderEnabled,
      reminderTime: reminderTime,
      reminderPreset: reminderPreset,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _database.into(_database.tasks).insert(
        _modelToCompanion(task),
      );
      await _scheduleTaskNotification(task);
      return 1;
    } catch (e) {
      debugPrint('Error adding task: $e');
      return null;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    if (task.id.isEmpty) {
      debugPrint('Error: Task ID cannot be empty for update.');
      return;
    }

    try {
      await _cancelTaskNotification(task.id);
      task.updatedAt = DateTime.now();
      await (_database.update(_database.tasks)
            ..where((t) => t.taskId.equals(task.id)))
          .write(_modelToCompanion(task, skipPrimaryKey: true));
      await _scheduleTaskNotification(task);
    } catch (e) {
      debugPrint('Error updating task: $e');
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task != null) {
        final updatedTask = task.toggleCompletion();
        await updateTask(updatedTask);

        if (updatedTask.completed) {
          try {
            int? energyLevel;
            String? moodTags;
            String? privacyContext;
            String? location;

            final todayEntry = await _database.select(_database.energyEntries)
                .get()
                .then((entries) {
              final now = DateTime.now();
              try {
                return entries.firstWhere((e) =>
                  e.timestamp.year == now.year &&
                  e.timestamp.month == now.month &&
                  e.timestamp.day == now.day
                );
              } catch (e) {
                return null;
              }
            });

            if (todayEntry != null) {
              energyLevel = todayEntry.energyLevel;
              moodTags = todayEntry.moodTags;
              privacyContext = todayEntry.privacyContext;
              location = todayEntry.location;
            }

            await CompletionLogService(_database).logCompletion(
              taskId: taskId,
              taskTitle: task.title,
              description: task.description,
              category: task.category,
              priority: task.priority,
              energyLevel: energyLevel,
              moodTags: moodTags,
              privacyContext: privacyContext,
              location: location,
            );
          } catch (e) {
            debugPrint('Error logging completion: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
    }
  }

  Future<void> markTaskCompleted(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task != null && !task.completed) {
        final updatedTask = task.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        await updateTask(updatedTask);

        try {
          int? energyLevel;
          String? moodTags;
          String? privacyContext;
          String? location;

          final todayEntry = await _database.select(_database.energyEntries)
              .get()
              .then((entries) {
            final now = DateTime.now();
            try {
              return entries.firstWhere((e) =>
                e.timestamp.year == now.year &&
                e.timestamp.month == now.month &&
                e.timestamp.day == now.day
              );
            } catch (e) {
              return null;
            }
          });

          if (todayEntry != null) {
            energyLevel = todayEntry.energyLevel;
            moodTags = todayEntry.moodTags;
            privacyContext = todayEntry.privacyContext;
            location = todayEntry.location;
          }

          await CompletionLogService(_database).logCompletion(
            taskId: taskId,
            taskTitle: task.title,
            description: task.description,
            category: task.category,
            priority: task.priority,
            energyLevel: energyLevel,
            moodTags: moodTags,
            privacyContext: privacyContext,
            location: location,
          );
        } catch (e) {
          debugPrint('Error logging completion: $e');
        }

        await _cancelTaskNotification(taskId);
      }
    } catch (e) {
      debugPrint('Error marking task as completed: $e');
    }
  }

  Future<void> markTaskIncomplete(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task != null && task.completed) {
        final updatedTask = task.copyWith(
          completed: false,
          completedAt: null,
        );
        await updateTask(updatedTask);
      }
    } catch (e) {
      debugPrint('Error marking task as incomplete: $e');
    }
  }

  Future<List<TaskModel>> getCompletedTasks({DateTime? date}) async {
    try {
      final tasks = await getTasks();
      return tasks.where((task) {
        if (!task.completed) return false;
        if (date != null && task.completedAt != null) {
          return _isSameDay(task.completedAt!, date);
        }
        return task.completed;
      }).toList();
    } catch (e) {
      debugPrint('Error fetching completed tasks: $e');
      return [];
    }
  }

  Future<List<TaskModel>> getTodaysTasks() async {
    try {
      final today = DateTime.now();
      return await getTasksFiltered(dueDate: today, completed: false);
    } catch (e) {
      debugPrint('Error fetching today\'s tasks: $e');
      return [];
    }
  }

  Future<List<TaskModel>> getOverdueTasks() async {
    try {
      final tasks = await getTasks();
      final now = DateTime.now();
      return tasks.where((task) {
        return !task.completed && task.dueDate.isBefore(now);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching overdue tasks: $e');
      return [];
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _cancelTaskNotification(taskId);
      final subtasks = await getSubtasks(taskId);
      for (final subtask in subtasks) {
        await deleteSubtask(subtask.id);
      }
      await (_database.delete(_database.tasks)
            ..where((t) => t.taskId.equals(taskId)))
          .go();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  Future<void> insertSubtask(SubtaskModel subtask) async {
    try {
      await _database.into(_database.subtasks).insert(
        SubtasksCompanion(
          id: Value(subtask.id),
          subtaskId: Value(subtask.id),
          taskId: Value(subtask.taskId),
          title: Value(subtask.title),
          completed: Value(subtask.completed),
          completedAt: Value(subtask.completedAt),
          createdAt: Value(subtask.createdAt),
          updatedAt: Value(subtask.updatedAt),
        ),
      );
      debugPrint('[TaskService] Subtask restored: ${subtask.title}');
    } catch (e) {
      debugPrint('Error inserting subtask: $e');
      rethrow;
    }
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      await _cancelTaskNotification(task.id);
      await _database.into(_database.tasks).insert(
        _modelToCompanion(task),
      );
      await _scheduleTaskNotification(task);
      debugPrint('[TaskService] Task restored: ${task.title}');
    } catch (e) {
      debugPrint('Error inserting task: $e');
      rethrow;
    }
  }

  Future<TaskModel?> getTaskById(String id) async {
    try {
      final row = await (_database.select(_database.tasks)
            ..where((t) => t.taskId.equals(id)))
          .getSingleOrNull();
      if (row == null) return null;

      final taskModel = _rowToModel(row);
      final subtasks = await getSubtasks(id);
      return taskModel.copyWith(subtasks: subtasks);
    } catch (e) {
      debugPrint('Error fetching task by ID: $e');
      return null;
    }
  }

  Future<TaskModel?> getTaskWithSubtasks(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) return null;

      final subtasks = await getSubtasks(taskId);
      return task.copyWith(subtasks: subtasks);
    } catch (e) {
      debugPrint('Error fetching task with subtasks: $e');
      return null;
    }
  }

  Future<SubtaskModel?> getSubtaskById(String subtaskId) async {
    try {
      final row = await (_database.select(_database.subtasks)
            ..where((s) => s.subtaskId.equals(subtaskId)))
          .getSingleOrNull();
      if (row == null) return null;

      return SubtaskModel(
        id: row.id,
        taskId: row.taskId,
        title: row.title,
        completed: row.completed,
        completedAt: row.completedAt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    } catch (e) {
      debugPrint('Error fetching subtask by ID: $e');
      return null;
    }
  }

  Future<void> _scheduleTaskNotification(TaskModel task) async {
    try {
      if (task.reminderEnabled == true &&
          task.reminderTime != null &&
          !task.completed &&
          task.reminderTime!.isAfter(DateTime.now())) {

        final reminder = ReminderModel(
          id: 'task_${task.id}',
          title: task.title,
          body: task.description ?? 'Task reminder',
          scheduledTime: task.reminderTime!,
          notificationId: task.id.hashCode.toString(),
          completed: false,
        );

        // await NotificationService.instance.scheduleNotification(reminder);
        debugPrint('[TaskService] Scheduled notification for task: ${task.title} at ${task.reminderTime}');
      }
    } catch (e) {
      debugPrint('[TaskService] Error scheduling task notification: $e');
    }
  }

  Future<void> _cancelTaskNotification(String taskId) async {
    try {
      // await NotificationService.instance.cancelNotification('task_$taskId');
      debugPrint('[TaskService] Cancelled notification for task: $taskId');
    } catch (e) {
      debugPrint('[TaskService] Error cancelling task notification: $e');
    }
  }

  Future<List<SubtaskModel>> getSubtasks(String taskId) async {
    try {
      final rows = await (_database.select(_database.subtasks)
            ..where((s) => s.taskId.equals(taskId)))
          .get();
      return rows.map((row) => SubtaskModel(
        id: row.id,
        taskId: row.taskId,
        title: row.title,
        completed: row.completed,
        completedAt: row.completedAt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      )).toList();
    } catch (e) {
      debugPrint('Error fetching subtasks: $e');
      return [];
    }
  }

  Future<int?> addSubtask(String taskId, {
    required String title,
    bool completed = false,
    DateTime? completedAt,
  }) async {
    final subtask = SubtaskModel(
      id: const Uuid().v1(),
      taskId: taskId,
      title: title,
      completed: completed,
      completedAt: completedAt,
    );

    try {
      await insertSubtask(subtask);
      return 1;
    } catch (e) {
      debugPrint('Error adding subtask: $e');
      return null;
    }
  }

  Future<void> updateSubtask(SubtaskModel subtask) async {
    if (subtask.id.isEmpty) {
      debugPrint('Error: Subtask ID cannot be empty for update.');
      return;
    }

    try {
      await (_database.update(_database.subtasks)
            ..where((s) => s.subtaskId.equals(subtask.id)))
          .write(SubtasksCompanion(
            id: Value(subtask.id),
            subtaskId: Value(subtask.id),
            taskId: Value(subtask.taskId),
            title: Value(subtask.title),
            completed: Value(subtask.completed),
            completedAt: Value(subtask.completedAt),
            createdAt: Value(subtask.createdAt),
            updatedAt: Value(DateTime.now()),
          ));
    } catch (e) {
      debugPrint('Error updating subtask: $e');
    }
  }

  Future<void> toggleSubtaskCompletion(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId);

      if (subtask == null) {
        debugPrint('Subtask with ID $subtaskId not found');
        return;
      }

      final updatedSubtask = subtask.toggleCompletion();
      await updateSubtask(updatedSubtask);
    } catch (e) {
      debugPrint('Error toggling subtask completion: $e');
    }
  }

  Future<void> markSubtaskCompleted(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId);

      if (subtask == null) {
        debugPrint('Subtask with ID $subtaskId not found');
        return;
      }

      if (!subtask.completed) {
        final updatedSubtask = subtask.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        await updateSubtask(updatedSubtask);

        try {
          final parentTask = await getTaskById(subtask.taskId);
          int? energyLevel;
          String? moodTags;
          String? privacyContext;
          String? location;

          final todayEntry = await _database.select(_database.energyEntries)
              .get()
              .then((entries) {
            final now = DateTime.now();
            try {
              return entries.firstWhere((e) =>
                e.timestamp.year == now.year &&
                e.timestamp.month == now.month &&
                e.timestamp.day == now.day
              );
            } catch (e) {
              return null;
            }
          });

          if (todayEntry != null) {
            energyLevel = todayEntry.energyLevel;
            moodTags = todayEntry.moodTags;
            privacyContext = todayEntry.privacyContext;
            location = todayEntry.location;
          }

          await CompletionLogService(_database).logCompletion(
            taskId: subtaskId,
            taskTitle: subtask.title,
            isSubtask: true,
            parentTaskTitle: parentTask?.title,
            energyLevel: energyLevel,
            moodTags: moodTags,
            privacyContext: privacyContext,
            location: location,
          );
        } catch (e) {
          debugPrint('Error logging subtask completion: $e');
        }
      }
    } catch (e) {
      debugPrint('Error marking subtask as completed: $e');
    }
  }

  Future<void> markSubtaskIncomplete(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId);

      if (subtask == null) {
        debugPrint('Subtask with ID $subtaskId not found');
        return;
      }

      if (subtask.completed) {
        final updatedSubtask = subtask.copyWith(
          completed: false,
          completedAt: null,
        );
        await updateSubtask(updatedSubtask);
      }
    } catch (e) {
      debugPrint('Error marking subtask as incomplete: $e');
    }
  }

  Future<void> deleteSubtask(String subtaskId) async {
    try {
      await (_database.delete(_database.subtasks)
            ..where((s) => s.subtaskId.equals(subtaskId)))
          .go();
    } catch (e) {
      debugPrint('Error deleting subtask: $e');
    }
  }

  Future<Map<String, int>> getTaskStats() async {
    try {
      final tasks = await getTasks();
      final completed = tasks.where((task) => task.completed).length;
      final pending = tasks.where((task) => !task.completed).length;
      final overdue = tasks.where((task) =>
        !task.completed && task.dueDate.isBefore(DateTime.now())).length;

      return {
        'total': tasks.length,
        'completed': completed,
        'pending': pending,
        'overdue': overdue,
      };
    } catch (e) {
      debugPrint('Error getting task stats: $e');
      return {'total': 0, 'completed': 0, 'pending': 0, 'overdue': 0};
    }
  }

  TaskModel _rowToModel(Task row) {
    return TaskModel(
      id: row.taskId,
      title: row.title,
      description: row.description,
      dueDate: row.dueDate ?? DateTime.now(),
      completed: row.completed,
      category: row.category,
      priority: row.priority,
      pageId: row.pageId,
      completedAt: row.completedAt,
      isRecurring: row.isRecurring,
      recurrenceRule: row.recurrenceRule,
      recurrenceInterval: row.recurrenceInterval,
      daysOfWeek: row.daysOfWeek != null
          ? row.daysOfWeek!.split(',').map((e) => int.parse(e.trim())).toList()
          : null,
      recurrenceEndDate: row.recurrenceEndDate,
      parentTaskId: row.parentTaskId,
      maxOccurrences: row.maxOccurrences,
      skipWeekends: row.skipWeekends,
      dayOfMonth: row.dayOfMonth,
      weekOfMonth: row.weekOfMonth,
      reminderEnabled: row.reminderEnabled,
      reminderTime: row.reminderTime,
      reminderPreset: row.reminderPreset,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  TasksCompanion _modelToCompanion(TaskModel model, {bool skipPrimaryKey = false}) {
    return TasksCompanion(
      id: skipPrimaryKey ? const Value.absent() : Value(model.id),
      taskId: skipPrimaryKey ? const Value.absent() : Value(model.id),
      title: Value(model.title),
      description: Value(model.description),
      dueDate: Value(model.dueDate),
      completed: Value(model.completed),
      completedAt: Value(model.completedAt),
      category: Value(model.category),
      priority: Value(model.priority),
      isRecurring: Value(model.isRecurring),
      recurrenceRule: Value(model.recurrenceRule),
      recurrenceInterval: Value(model.recurrenceInterval ?? 1),
      daysOfWeek: Value(model.daysOfWeek?.join(',')),
      recurrenceEndDate: Value(model.recurrenceEndDate),
      parentTaskId: Value(model.parentTaskId),
      maxOccurrences: Value(model.maxOccurrences),
      skipWeekends: Value(model.skipWeekends),
      dayOfMonth: Value(model.dayOfMonth),
      weekOfMonth: Value(model.weekOfMonth),
      reminderEnabled: Value(model.reminderEnabled ?? false),
      reminderTime: Value(model.reminderTime),
      reminderPreset: Value(model.reminderPreset),
      pageId: Value(model.pageId),
      createdAt: Value(model.createdAt),
      updatedAt: Value(model.updatedAt),
    );
  }
}
