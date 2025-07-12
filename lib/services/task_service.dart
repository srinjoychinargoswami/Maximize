import 'package:maximize/models/task_model.dart';
import 'package:maximize/models/database.dart';
import 'package:uuid/uuid.dart';

class TaskService {
  final AppDatabase _dbHelper; // Declare a variable to hold the database

  // Constructor that accepts the database
  TaskService(this._dbHelper); // Initialize the database

  // Fetch all tasks from the database
  Future<List<TaskModel>> getTasks() async {
    try {
      final taskDataList = await _dbHelper.getAllTasks(); // Fetch List<TaskData>
      return taskDataList.map((taskData) => TaskModel.fromData(taskData)).toList(); // Convert to List<TaskModel>
    } catch (e) {
      print('Error fetching tasks: $e');
      return []; // Return an empty list on error
    }
  }

  // ENHANCED: Fetch tasks with filtering options for better organization
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

  // ADDED: Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  // Add a new task to the database
  Future<int?> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required bool completed,
    required String category,
    required String priority,
    int? pageId, // Optional pageId for associating with pages
    // ADDED: New completion tracking parameters
    DateTime? completedAt,
    List<SubtaskModel>? subtasks,
    // ADDED: Recurring task parameters
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
  }) async {
    final task = TaskModel(
      id: const Uuid().v1(), // Placeholder for new tasks
      title: title,
      description: description,
      dueDate: dueDate, // Pass DateTime directly
      completed: completed, // Pass bool directly
      category: category,
      priority: priority,
      pageId: pageId?.toString(), // Include pageId if needed
      completedAt: completedAt, // ADDED: Track completion timestamp
      subtasks: subtasks, // ADDED: Include subtasks
      isRecurring: isRecurring, // ADDED: Recurring task support
      recurrenceRule: recurrenceRule,
      recurrenceInterval: recurrenceInterval,
      daysOfWeek: daysOfWeek,
      recurrenceEndDate: recurrenceEndDate,
      parentTaskId: parentTaskId,
      maxOccurrences: maxOccurrences,
      skipWeekends: skipWeekends,
      dayOfMonth: dayOfMonth,
      weekOfMonth: weekOfMonth,
    );

    try {
      return await _dbHelper.insertTask(task);
    } catch (e) {
      print('Error adding task: $e');
      return null; // Indicate failure
    }
  }

  // Update an existing task in the database
  Future<void> updateTask(TaskModel task) async {
    if (task.id.isEmpty) {
      print('Error: Task ID cannot be empty for update.');
      return; // Early return if ID is empty
    }

    try {
      await _dbHelper.updateTask(task); // Assuming this method accepts TaskModel
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // ADDED: Toggle task completion status (for checkbox functionality)
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task != null) {
        final updatedTask = task.toggleCompletion();
        await updateTask(updatedTask);
      }
    } catch (e) {
      print('Error toggling task completion: $e');
    }
  }

  // ADDED: Mark task as completed (for checkbox functionality)
  Future<void> markTaskCompleted(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task != null && !task.completed) {
        final updatedTask = task.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        await updateTask(updatedTask);
      }
    } catch (e) {
      print('Error marking task as completed: $e');
    }
  }

  // ADDED: Mark task as incomplete (for checkbox functionality)
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
      print('Error marking task as incomplete: $e');
    }
  }

  // ADDED: Get completed tasks for productivity tracking
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

  // ADDED: Get pending tasks for today's overview
  Future<List<TaskModel>> getTodaysTasks() async {
    try {
      final today = DateTime.now();
      return await getTasksFiltered(dueDate: today, completed: false);
    } catch (e) {
      print('Error fetching today\'s tasks: $e');
      return [];
    }
  }

  // ADDED: Get overdue tasks
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

  // Delete a task from the database
  Future<void> deleteTask(String taskId) async {
    try {
      // ENHANCED: Also delete associated subtasks
      final subtasks = await getSubtasks(taskId);
      for (final subtask in subtasks) {
        await deleteSubtask(subtask.id);
      }
      await _dbHelper.deleteTask(taskId);
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  // Fetch a task by its ID from the database
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final tasks = await _dbHelper.getAllTasks();
      final taskData = tasks.firstWhere(
        (task) => task.id == id,
        orElse: () => throw Exception('Task not found'), // Throw an exception if no task is found
      );
      
      // ENHANCED: Load subtasks with the task
      final subtasks = await getSubtasks(id);
      final taskModel = TaskModel.fromData(taskData);
      return taskModel.copyWith(subtasks: subtasks);
    } catch (e) {
      print('Error fetching task by ID: $e');
      return null; // Indicate failure
    }
  }

  // ENHANCED: Get task with all its subtasks loaded
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

  // ADDED: Helper method to find subtask by ID across all tasks
  Future<SubtaskModel?> getSubtaskById(String subtaskId) async {
    try {
      final allTasks = await _dbHelper.getAllTasks();
      
      for (final task in allTasks) {
        final subtasks = await getSubtasks(task.id);
        for (final subtask in subtasks) {
          if (subtask.id == subtaskId) {
            return subtask;
          }
        }
      }
      return null; // Subtask not found
    } catch (e) {
      print('Error fetching subtask by ID: $e');
      return null;
    }
  }

  // Subtask Methods

  // Fetch all subtasks for a specific task
  Future<List<SubtaskModel>> getSubtasks(String taskId) async {
    try {
      final subtaskDataList = await _dbHelper.getAllSubtasks(taskId); // Fetch List<SubtaskData>
      
      // Check if subtaskDataList is null or empty
      if (subtaskDataList.isEmpty) {
        return []; // Return an empty list if no subtasks found
      }

      return subtaskDataList.map((subtaskData) {
        return SubtaskModel(
          id: subtaskData.id,
          taskId: subtaskData.taskId,
          title: subtaskData.title,
          completed: subtaskData.completed,
          completedAt: subtaskData.completedAt, // ADDED: Map completion timestamp
        );
      }).toList(); // Convert to List<SubtaskModel>
    } catch (e) {
      print('Error fetching subtasks: $e');
      return []; // Return an empty list on error
    }
  }

  // Add a new subtask to a specific task
  Future<int?> addSubtask(String taskId, {
    required String title,
    bool completed = false, // Default to false
    DateTime? completedAt, // ADDED: Support completion timestamp
  }) async {
    final subtask = SubtaskModel(
      id: const Uuid().v1(), // Placeholder for new subtasks
      taskId: taskId,
      title: title,
      completed: completed,
      completedAt: completedAt, // ADDED: Include completion timestamp
    );

    try {
      return await _dbHelper.insertSubtask(subtask);
    } catch (e) {
      print('Error adding subtask: $e');
      return null; // Indicate failure
    }
  }

  // Update an existing subtask in the database
  Future<void> updateSubtask(SubtaskModel subtask) async {
    if (subtask.id.isEmpty) {
      print('Error: Subtask ID cannot be empty for update.');
      return; // Early return if ID is empty
    }

    try {
      await _dbHelper.updateSubtask(subtask); // Assuming this method accepts SubtaskModel
    } catch (e) {
      print('Error updating subtask: $e');
    }
  }

  // FIXED: Toggle subtask completion status (for checkbox functionality)
  Future<void> toggleSubtaskCompletion(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId); // FIXED: Use helper method
      
      if (subtask == null) {
        print('Subtask with ID $subtaskId not found');
        return; // Exit gracefully
      }
      
      final updatedSubtask = subtask.toggleCompletion();
      await updateSubtask(updatedSubtask);
    } catch (e) {
      print('Error toggling subtask completion: $e');
    }
  }

  // FIXED: Mark subtask as completed (for checkbox functionality)
  Future<void> markSubtaskCompleted(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId); // FIXED: Use helper method
      
      if (subtask == null) {
        print('Subtask with ID $subtaskId not found');
        return; // Exit gracefully
      }
      
      if (!subtask.completed) {
        final updatedSubtask = subtask.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
        await updateSubtask(updatedSubtask);
      }
    } catch (e) {
      print('Error marking subtask as completed: $e');
    }
  }

  // ADDED: Mark subtask as incomplete (for checkbox functionality)
  Future<void> markSubtaskIncomplete(String subtaskId) async {
    try {
      final subtask = await getSubtaskById(subtaskId);
      
      if (subtask == null) {
        print('Subtask with ID $subtaskId not found');
        return; // Exit gracefully
      }
      
      if (subtask.completed) {
        final updatedSubtask = subtask.copyWith(
          completed: false,
          completedAt: null,
        );
        await updateSubtask(updatedSubtask);
      }
    } catch (e) {
      print('Error marking subtask as incomplete: $e');
    }
  }

  // Delete a subtask from the database
  Future<void> deleteSubtask(String subtaskId) async {
    try {
      await _dbHelper.deleteSubtask(subtaskId);
    } catch (e) {
      print('Error deleting subtask: $e');
    }
  }

  // ADDED: Get task completion statistics
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
