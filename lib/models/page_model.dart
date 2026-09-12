import 'package:kinetic/models/task_model.dart';

class PageModel {
  final int id;
  final String name;
  final String description;
  final List<TaskModel> tasks; // List of tasks

  PageModel({
    required this.id,
    required this.name,
    required this.description,
    List<TaskModel>? tasks, // Allow optional tasks
  }) : tasks = tasks ?? []; // Initialize tasks to an empty list if null

  // Factory constructor to create a PageModel from JSON
  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      tasks: (json['tasks'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList(),
    );
  }

  // Convert PageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  // Factory constructor to create a PageModel from a Map (for database operations)
  factory PageModel.fromMap(Map<String, dynamic> map) {
    return PageModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      tasks: [], // Initialize with an empty list; tasks can be fetched separately
    );
  }

  // Convert PageModel to a Map (for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      // Note: tasks are not included in the map; they can be managed separately
    };
  }

  @override
  String toString() {
    return 'PageModel(id: $id, name: $name, description: $description, tasks: $tasks)';
  }

  // Add a task to the list
  void addTask(TaskModel task) {
    tasks.add(task);
  }

  // Remove a task from the list
  void removeTask(TaskModel task) {
    tasks.remove(task);
  }

  // Check if the task exists in the list
  bool hasTask(TaskModel task) {
    return tasks.contains(task);
  }
}