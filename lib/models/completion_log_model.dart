class CompletionLogModel {
  final String id;
  final String logId;
  final String? taskId;
  final String taskTitle;
  final String? description;
  final String? category;
  final String? priority;
  final DateTime completedAt;
  final bool isSubtask;
  final String? parentTaskTitle;
  final int? energyLevel;
  final String? moodTags;
  final String? privacyContext;
  final String? location;
  final DateTime createdAt;

  CompletionLogModel({
    required this.id,
    required this.logId,
    this.taskId,
    required this.taskTitle,
    this.description,
    this.category,
    this.priority,
    required this.completedAt,
    this.isSubtask = false,
    this.parentTaskTitle,
    this.energyLevel,
    this.moodTags,
    this.privacyContext,
    this.location,
    required this.createdAt,
  });

  CompletionLogModel copyWith({
    String? id,
    String? logId,
    String? taskId,
    String? taskTitle,
    String? description,
    String? category,
    String? priority,
    DateTime? completedAt,
    bool? isSubtask,
    String? parentTaskTitle,
    int? energyLevel,
    String? moodTags,
    String? privacyContext,
    String? location,
    DateTime? createdAt,
  }) {
    return CompletionLogModel(
      id: id ?? this.id,
      logId: logId ?? this.logId,
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      completedAt: completedAt ?? this.completedAt,
      isSubtask: isSubtask ?? this.isSubtask,
      parentTaskTitle: parentTaskTitle ?? this.parentTaskTitle,
      energyLevel: energyLevel ?? this.energyLevel,
      moodTags: moodTags ?? this.moodTags,
      privacyContext: privacyContext ?? this.privacyContext,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'CompletionLogModel(logId: $logId, taskTitle: $taskTitle, completedAt: $completedAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletionLogModel &&
          runtimeType == other.runtimeType &&
          logId == other.logId &&
          taskId == other.taskId;

  @override
  int get hashCode => logId.hashCode ^ taskId.hashCode;
}
