import 'package:maximize/models/database.dart'; // Import your database file
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart'; 

@JsonSerializable()
class TaskModel {
  final String id; // Non-optional ID for the task
  final String name; // Name of the task
  final String title; // Title of the task
  final String? description; // Description of the task (optional)
  final DateTime dueDate; // Due date of the task
  bool completed; // Completion status of the task (made non-final)
  final String? category; // Category of the task (optional)
  final String priority; // Priority of the task
  final String? customCategory; // Custom category (optional)
  final String? pageId; // Optional page ID for associating with pages
  final String? day; // Day of the task (optional)

  TaskModel({
    required this.id,
    required this.name,
    required this.title,
    this.description,
    required this.dueDate,
    this.completed = false, // Default to false
    this.category,
    required this.priority,
    this.customCategory,
    this.pageId,
    this.day,
  });

  factory TaskModel.fromData(TaskData data) {
    return TaskModel(
      id: data.id, // Changed to String
      name: data.name,
      title: data.title,
      description: data.description,
      dueDate: data.dueDate,
      completed: data.completed, // Ensure this is correctly mapped
      category: data.category,
      priority: data.priority,
      customCategory: data.customCategory,
      pageId: data.pageId, // Changed to String?
      day: data.day,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  TaskModel copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed, // Make this optional
    String? category,
    String? priority,
    String? customCategory,
    String? pageId,
    String? day,
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed, // Ensure this is correctly updated
      category: category ?? this.category,
      priority: priority ?? this.priority,
      customCategory: customCategory ?? this.customCategory,
      pageId: pageId ?? this.pageId,
      day: day ?? this.day,
    );
  }
}

// New Subtask Model
@JsonSerializable()
class SubtaskModel {
  final String id; // Non-optional ID for the subtask
  String taskId; // ID of the parent task
  String title; // Title of the subtask
  bool completed; // Completion status of the subtask

  SubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    this.completed = false, // Default to false
  });

  factory SubtaskModel.fromJson(Map<String, dynamic> json) => _$SubtaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskModelToJson(this);

  SubtaskModel copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? completed, // Make this optional
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      completed: completed ?? this.completed, // Ensure this is correctly updated
    );
  }
}