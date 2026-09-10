import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'subtask_model.g.dart';

@JsonSerializable()
class SubtaskModel {
  final String id;
  final String subtaskId;
  final String taskId;
  final String title;
  bool completed;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubtaskModel({
    String? id,
    String? subtaskId,
    required this.taskId,
    required this.title,
    this.completed = false,
    this.completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        subtaskId = subtaskId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory SubtaskModel.fromJson(Map<String, dynamic> json) => _$SubtaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskModelToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subtaskId': subtaskId,
      'taskId': taskId,
      'title': title,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'] ?? '',
      subtaskId: map['subtaskId'] ?? '',
      taskId: map['taskId'] ?? '',
      title: map['title'] ?? '',
      completed: map['completed'] ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  SubtaskModel copyWith({
    String? id,
    String? subtaskId,
    String? taskId,
    String? title,
    bool? completed,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      subtaskId: subtaskId ?? this.subtaskId,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  SubtaskModel toggleCompletion() {
    return copyWith(
      completed: !completed,
      completedAt: !completed ? DateTime.now() : null,
    );
  }
}
