import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/subtask_model.dart';
import 'package:maximize/models/reminder_model.dart';
import 'package:maximize/database/daos/task_dao.dart';
import 'package:maximize/database/daos/subtask_dao.dart';
import 'package:maximize/database/daos/energy_entry_dao.dart';
import 'package:maximize/database/converters/task_converter.dart';
import 'package:maximize/database/converters/subtask_converter.dart';
import 'package:maximize/database/converters/energy_entry_converter.dart';
import 'package:maximize/database/models/isar_models.dart';
import 'package:maximize/services/completion_log_service.dart';
import 'package:maximize/services/reminder_service.dart';
import 'package:uuid/uuid.dart';

class TaskService {
  final TaskDAO _taskDao = TaskDAO();
  final SubtaskDAO _subtaskDao = SubtaskDAO();
  final EnergyEntryDAO _energyDao = EnergyEntryDAO();

  Future<List<TaskModel>> getTasks() async {
    try {
      final isarTasks = await _taskDao.getAllTasks();
      return isarTasks.map(TaskConverter.toTaskModel).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
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
      print('Error fetching filtered tasks: $e');
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
    final task = TaskModel(
      id: const Uuid().v1(),
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
    );

    try {
      final isarTask = TaskConverter.fromTaskModel(task);
      await _taskDao.insertTask(isarTask);
      await _scheduleTaskNotification(task);
      return 1;
    } catch (e) {
      print('Error adding task: $e');
      return null;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    if (task.id.isEmpty) {
      print('Error: Task ID cannot be empty for update.');
      return;
    }

    try {
      await _cancelTaskNotification(task.id);
      final isarTask = TaskConverter.fromTaskModel(task);
      await _taskDao.updateTask(isarTask);
      await _scheduleTaskNotification(task);
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task != null) {
        final updatedTask = task.toggleCompletion();
        await updateTask(updatedTask);

        // If toggled to completed, log the completion
        if (updatedTask.completed) {
          try {
            int? energyLevel;
            String? moodTags;
            String? privacyContext;
            String? location;

            final todayEntry = await _energyDao.getTodaysEntry();
            if (todayEntry != null) {
              energyLevel = todayEntry.energyLevel;
              moodTags = todayEntry.moodTags;
              privacyContext = todayEntry.privacyContext;
              location = todayEntry.location;
            }

            await CompletionLogService().logCompletion(
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
            print('Error logging completion: $e');
          }
        }
      }
    } catch (e) {
      print('Error toggling task completion: $e');
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
        final isarTask = TaskConverter.fromTaskModel(updatedTask);
        await _taskDao.updateTask(isarTask);

        try {
          int? energyLevel;
          String? moodTags;
          String? privacyContext;
          String? location;

          final todayEntry = await _energyDao.getTodaysEntry();
          if (todayEntry != null) {
            energyLevel = todayEntry.energyLevel;
            moodTags = todayEntry.moodTags;
            privacyContext = todayEntry.privacyContext;
            location = todayEntry.location;
          }

          await CompletionLogService().logCompletion(
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
          print('Error logging completion: $e');
        }

        await _cancelTaskNotification(taskId);
      }
    } catch (e) {
      print('Error marking task as completed: $e');
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
        final isarTask = TaskConverter.fromTaskModel(updatedTask);
        await _taskDao.updateTask(isarTask);
        await _scheduleTaskNotification(updatedTask);
      }
    } catch (e) {
      print('Error marking task as incomplete: $e');
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
      print('Error fetching completed tasks: $e');
      return [];
    }
  }

  Future<List<TaskModel>> getTodaysTasks() async {
    try {
      final today = DateTime.now();
      return await getTasksFiltered(dueDate: today, completed: false);
    } catch (e) {
      print('Error fetching today\'s tasks: $e');
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
      print('Error fetching overdue tasks: $e');
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
      await _taskDao.deleteTask(taskId);
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> insertSubtask(SubtaskModel subtask) async {
    try {
      final isarSubtask = SubtaskConverter.fromSubtaskModel(subtask);
      await _subtaskDao.insertSubtask(isarSubtask);
      print('[TaskService] Subtask restored: ${subtask.title}');
    } catch (e) {
      print('Error inserting subtask: $e');
      rethrow;
    }
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      await _cancelTaskNotification(task.id);
      final isarTask = TaskConverter.fromTaskModel(task);
      await _taskDao.insertTask(isarTask);
      await _scheduleTaskNotification(task);
      print('[TaskService] Task restored: ${task.title}');
    } catch (e) {
      print('Error inserting task: $e');
      rethrow;
    }
  }

  Future<TaskModel?> getTaskById(String id) async {
    try {
      final isarTask = await _taskDao.getTaskById(id);
      if (isarTask == null) return null;

      final taskModel = TaskConverter.toTaskModel(isarTask);
      final subtasks = await getSubtasks(id);
      return taskModel.copyWith(subtasks: subtasks);
    } catch (e) {
      print('Error fetching task by ID: $e');
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
      print('Error fetching task with subtasks: $e');
      return null;
    }
  }

  Future<SubtaskModel?> getSubtaskById(String subtaskId) async {
    try {
      final tasks = await getTasks();

      for (final task in tasks) {
        final subtasks = await getSubtasks(task.id);
        for (final subtask in subtasks) {
          if (subtask.id == subtaskId) {
            return subtask;
          }
        }
      }
      return null;
    } catch (e) {
      print('Error fetching subtask by ID: $e');
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

        await NotificationService.instance.scheduleNotification(reminder);
        print('[TaskService] Scheduled notification for task: ${task.title} at ${task.reminderTime}');
      }
    } catch (e) {
      print('[TaskService] Error scheduling task notification: $e');
    }
  }

  Future<void> _cancelTaskNotification(String taskId) async {
    try {
      await NotificationService.instance.cancelNotification('task_$taskId');
      print('[TaskService] Cancelled notification for task: $taskId');
    } catch (e) {
      print('[TaskService] Error cancelling task notification: $e');
    }
  }

  Future<List<SubtaskModel>> getSubtasks(String taskId) async {
    try {
      final isarSubtasks = await _subtaskDao.getAllSubtasks(taskId);
      return isarSubtasks.map(SubtaskConverter.toSubtaskModel).toList();
    } catch (e) {
      print('Error fetching subtasks: $e');
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
      final isarSubtask = SubtaskConverter.fromSubtaskModel(subtask);
      await _subtaskDao.insertSubtask(isarSubtask);
      return 1;
    } catch (e) {
      print('Error adding subtask: $e');
      return null;
    }
  }

  Future<void> updateSubtask(SubtaskModel subtask) async {
    if (subtask.id.isEmpty) {
      print('Error: Subtask ID cannot be empty for update.');
      return;
    }

    try {
      final isarSubtask = SubtaskConverter.fromSubtaskModel(subtask);
      await _subtaskDao.updateSubtask(isarSubtask);
    } catch (e) {
      print('Error updating subtask: $e');
    }
  }

  Future<void> toggleSubtaskCompletion(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId);

      if (subtask == null) {
        print('Subtask with ID $subtaskId not found');
        return;
      }

      final updatedSubtask = subtask.toggleCompletion();
      await updateSubtask(updatedSubtask);
    } catch (e) {
      print('Error toggling subtask completion: $e');
    }
  }

  Future<void> markSubtaskCompleted(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId);

      if (subtask == null) {
        print('Subtask with ID $subtaskId not found');
        return;
      }

      if (!subtask.completed) {
        final updatedSubtask = subtask.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        final isarSubtask = SubtaskConverter.fromSubtaskModel(updatedSubtask);
        await _subtaskDao.updateSubtask(isarSubtask);

        try {
          final parentTask = await getTaskById(subtask.taskId);
          int? energyLevel;
          String? moodTags;
          String? privacyContext;
          String? location;

          final todayEntry = await _energyDao.getTodaysEntry();
          if (todayEntry != null) {
            energyLevel = todayEntry.energyLevel;
            moodTags = todayEntry.moodTags;
            privacyContext = todayEntry.privacyContext;
            location = todayEntry.location;
          }

          await CompletionLogService().logCompletion(
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
          print('Error logging subtask completion: $e');
        }
      }
    } catch (e) {
      print('Error marking subtask as completed: $e');
    }
  }

  Future<void> markSubtaskIncomplete(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId);

      if (subtask == null) {
        print('Subtask with ID $subtaskId not found');
        return;
      }

      if (subtask.completed) {
        final updatedSubtask = subtask.copyWith(
          completed: false,
          completedAt: null,
        );
        final isarSubtask = SubtaskConverter.fromSubtaskModel(updatedSubtask);
        await _subtaskDao.updateSubtask(isarSubtask);
      }
    } catch (e) {
      print('Error marking subtask as incomplete: $e');
    }
  }

  Future<void> deleteSubtask(String subtaskId) async {
    try {
      await _subtaskDao.deleteSubtask(subtaskId);
    } catch (e) {
      print('Error deleting subtask: $e');
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
      print('Error getting task stats: $e');
      return {'total': 0, 'completed': 0, 'pending': 0, 'overdue': 0};
    }
  }
}
