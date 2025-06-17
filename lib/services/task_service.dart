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

  // Add a new task to the database
  Future<int?> addTask({
    required String name, // Add name parameter
    required String title,
    required String description,
    required DateTime dueDate,
    required bool completed,
    required String category,
    required String priority,
    int? pageId, // Optional pageId for associating with pages
  }) async {
    final task = TaskModel(
      id: const Uuid().v1(), // Placeholder for new tasks
      name: name, // Pass name to TaskModel
      title: title,
      description: description,
      dueDate: dueDate, // Pass DateTime directly
      completed: completed, // Pass bool directly
      category: category,
      priority: priority,
      pageId: pageId?.toString(), // Include pageId if needed
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

  // Delete a task from the database
  Future<void> deleteTask(String taskId) async {
    try {
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
      return TaskModel.fromData(taskData); // Convert TaskData to TaskModel
    } catch (e) {
      print('Error fetching task by ID: $e');
      return null; // Indicate failure
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
  }) async {
    final subtask = SubtaskModel(
      id: const Uuid().v1(), // Placeholder for new subtasks
      taskId: taskId,
      title: title,
      completed: completed,
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

  // Delete a subtask from the database
  Future<void> deleteSubtask(String subtaskId) async {
    try {
      await _dbHelper.deleteSubtask(subtaskId);
    } catch (e) {
      print('Error deleting subtask: $e');
    }
  }
}